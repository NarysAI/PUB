from __future__ import annotations

import json
import re
import subprocess
import sys
from pathlib import Path, PurePosixPath


SEMVER = re.compile(r"^(0|[1-9]\d*)\.(0|[1-9]\d*)\.(0|[1-9]\d*)$")
CANONICAL_CAD_EXTENSIONS = {".scad", ".fcstd", ".stl", ".step", ".stp"}
DECLARATIVE_ASSEMBLY_EXTENSION = ".assy"
MAX_STL_TRIANGLES = 250_000


def parse_version(value: str) -> tuple[int, int, int]:
    value = value.strip()
    if not SEMVER.fullmatch(value):
        raise ValueError(f"invalid stable Semantic Version: {value!r}")
    return tuple(int(part) for part in value.split("."))  # type: ignore[return-value]


def git_file(root: Path, ref: str, path: str) -> str:
    result = subprocess.run(
        ["git", "-C", str(root), "show", f"{ref}:{path}"],
        check=True,
        capture_output=True,
        text=True,
        encoding="utf-8",
    )
    return result.stdout


def package_ids(inventory: dict) -> set[str]:
    return {str(item["name"]) for item in inventory.get("packages", [])}


def object_ids(inventory: dict) -> set[tuple[str, str, str]]:
    return {
        (str(item["package"]), str(item["section"]), str(item["name"]))
        for item in inventory.get("objects", [])
    }


def object_records(inventory: dict) -> dict[tuple[str, str, str], dict]:
    return {
        (str(item["package"]), str(item["section"]), str(item["name"])): item
        for item in inventory.get("objects", [])
    }


def asset_digests(inventory: dict) -> dict[str, str]:
    return {
        str(item["path"]): str(item["sha256"])
        for item in inventory.get("assets", [])
    }


def stl_triangle_count(path: Path) -> int:
    content = path.read_bytes()
    if len(content) >= 84:
        binary_count = int.from_bytes(content[80:84], "little")
        if 84 + binary_count * 50 == len(content):
            return binary_count
    ascii_count = len(re.findall(rb"(?im)^\s*facet\s+normal\b", content))
    if ascii_count:
        return ascii_count
    raise ValueError("not a valid binary or ASCII STL")


def validate_scad_stl_bundle(
    root: Path, record: dict, current_assets: dict[str, str], label: str
) -> list[str]:
    bundle_errors: list[str] = []
    representations = {
        str(item.get("format", "")).casefold(): item
        for item in record.get("representations", [])
        if isinstance(item, dict)
    }
    missing = sorted({"scad", "stl"} - representations.keys())
    if missing:
        return [f"{label}: new 3D part requires optimized SCAD and STL representations"]

    scad_source = PurePosixPath(str(representations["scad"].get("source", "")))
    stl_source = PurePosixPath(str(representations["stl"].get("source", "")))
    if scad_source.with_suffix("") != stl_source.with_suffix(""):
        bundle_errors.append(f"{label}: SCAD and STL representations must use the same path and base filename")

    if str(scad_source) not in current_assets or str(stl_source) not in current_assets:
        bundle_errors.append(f"{label}: SCAD/STL delivery bundle is missing from the catalog inventory")
        return bundle_errors

    try:
        scad_content = (root / Path(str(scad_source))).read_text(encoding="utf-8")
    except (OSError, UnicodeError) as exc:
        bundle_errors.append(f"{label}: cannot read SCAD representation: {exc}")
    else:
        if re.search(r"\b(?:import|include|use)\s*(?:\(|<)", scad_content):
            bundle_errors.append(f"{label}: optimized SCAD must be self-contained without import/include/use")

    try:
        triangle_count = stl_triangle_count(root / Path(str(stl_source)))
    except (OSError, ValueError) as exc:
        bundle_errors.append(f"{label}: invalid STL representation: {exc}")
    else:
        if triangle_count == 0:
            bundle_errors.append(f"{label}: STL representation must not be empty")
        elif triangle_count > MAX_STL_TRIANGLES:
            bundle_errors.append(
                f"{label}: optimized STL has {triangle_count} triangles; "
                f"maximum is {MAX_STL_TRIANGLES}"
            )
    return bundle_errors


def expected_version(
    base: tuple[int, int, int], breaking: bool, additive: bool
) -> tuple[int, int, int]:
    major, minor, patch = base
    if breaking:
        return major + 1, 0, 0
    if additive:
        return major, minor + 1, 0
    return major, minor, patch + 1


def main() -> int:
    root = Path(sys.argv[1] if len(sys.argv) > 1 else ".").resolve()
    base_ref = sys.argv[2] if len(sys.argv) > 2 else "origin/main"
    errors: list[str] = []

    try:
        current_version_text = (root / "VERSION").read_text(encoding="utf-8").strip()
        current_version = parse_version(current_version_text)
        base_version = parse_version(git_file(root, base_ref, "VERSION"))
        current_inventory = json.loads((root / "catalog-inventory.json").read_text(encoding="utf-8"))
        base_inventory = json.loads(git_file(root, base_ref, "catalog-inventory.json"))
    except (OSError, ValueError, json.JSONDecodeError, subprocess.CalledProcessError) as exc:
        print(f"release validation setup failed: {exc}")
        return 1

    removed_packages = package_ids(base_inventory) - package_ids(current_inventory)
    removed_objects = object_ids(base_inventory) - object_ids(current_inventory)
    added_packages = package_ids(current_inventory) - package_ids(base_inventory)
    added_objects = object_ids(current_inventory) - object_ids(base_inventory)
    breaking = bool(removed_packages or removed_objects)
    additive = bool(added_packages or added_objects)
    expected = expected_version(base_version, breaking, additive)

    if current_version != expected:
        change_type = "MAJOR" if breaking else "MINOR" if additive else "PATCH"
        errors.append(
            f"{change_type} change requires version {'.'.join(map(str, expected))}; "
            f"found {current_version_text} (base {'.'.join(map(str, base_version))})"
        )

    changelog = (root / "CHANGELOG.md").read_text(encoding="utf-8")
    if f"## [{current_version_text}]" not in changelog:
        errors.append(f"CHANGELOG.md has no release heading for {current_version_text}")
    if str(current_inventory.get("catalog_version")) != current_version_text:
        errors.append("catalog-inventory.json catalog_version does not match VERSION")

    base_assets = asset_digests(base_inventory)
    current_assets = asset_digests(current_inventory)
    changed_assets = {
        path for path, digest in current_assets.items()
        if base_assets.get(path) != digest
    }
    invalid_assets = sorted(
        path for path in changed_assets
        if Path(path).suffix.casefold() not in CANONICAL_CAD_EXTENSIONS | {DECLARATIVE_ASSEMBLY_EXTENSION}
    )
    if invalid_assets:
        errors.append(
            "new or modified CAD assets must use SCAD, STL, STEP, or FCStd; declarative assemblies use .assy:\n- "
            + "\n- ".join(invalid_assets)
        )

    base_records = object_records(base_inventory)
    current_records = object_records(current_inventory)
    changed_records = {
        key: record for key, record in current_records.items()
        if base_records.get(key) != record
    }
    source_records = {
        str(record.get("source", "")).casefold(): record
        for record in current_records.values() if record.get("source")
    }
    representation_records = {
        str(representation.get("source", "")).casefold(): record
        for record in current_records.values()
        for representation in record.get("representations", [])
        if isinstance(representation, dict) and representation.get("source")
    }

    for key in sorted(added_objects):
        record = current_records[key]
        if record.get("section") != "parts":
            continue
        label = ":".join(key)
        errors.extend(validate_scad_stl_bundle(root, record, current_assets, label))
    assembly_sources = {
        str(
            PurePosixPath(str(record["package"]).lstrip("/"))
            / str(record.get("source") or f"{record['name']}.assy")
        ).casefold()
        for record in current_records.values()
        if record.get("section") == "assemblies" and record.get("type") == "assy"
    }

    def validate_role(record: dict, label: str) -> None:
        role = str(record.get("model_role", ""))
        source = PurePosixPath(str(record.get("source", "")))
        source_type = str(record.get("type", "")).casefold()
        if role in {"electronic_component", "mechanical_component"}:
            allowed = {"scad": {".scad"}, "stl": {".stl"}, "step": {".step", ".stp"}}
            if source.suffix.casefold() not in allowed.get(source_type, set()):
                errors.append(f"{label}: catalog component requires matching SCAD, STL, or STEP")
        elif role == "printable_part":
            if source_type != "freecad" or source.suffix != ".FCStd":
                errors.append(f"{label}: printable_part requires one .FCStd source with type: freecad")
        else:
            errors.append(f"{label}: changed object requires a supported catalog model_role")

    for key, record in changed_records.items():
        if record.get("section") == "parts":
            validate_role(record, ":".join(key))

    for path in sorted(changed_assets):
        source = PurePosixPath(path)
        record = source_records.get(path.casefold()) or representation_records.get(path.casefold())
        if source.suffix.casefold() == DECLARATIVE_ASSEMBLY_EXTENSION:
            if path.casefold() not in assembly_sources:
                errors.append(f"{path}: declarative assembly source is not referenced by an assembly object")
            continue
        if source.suffix == ".scad" and source.stem.startswith("_"):
            continue
        if source.suffix.casefold() in CANONICAL_CAD_EXTENSIONS and not record:
            errors.append(f"{path}: canonical model asset is not referenced by a catalog object")
        elif record and source_records.get(path.casefold()):
            validate_role(record, path)

    if errors:
        print("\n".join(errors))
        return 1
    print(
        f"Release {current_version_text} is valid: "
        f"{len(added_packages)} packages added, {len(added_objects)} objects added, "
        f"{len(removed_packages)} packages removed, {len(removed_objects)} objects removed"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
