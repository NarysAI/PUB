from __future__ import annotations

import json
import re
import subprocess
import sys
from pathlib import Path, PurePosixPath


SEMVER = re.compile(r"^(0|[1-9]\d*)\.(0|[1-9]\d*)\.(0|[1-9]\d*)$")
CANONICAL_CAD_EXTENSIONS = {".scad", ".fcstd"}
DECLARATIVE_ASSEMBLY_EXTENSION = ".assy"


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
            "new or modified CAD assets must use .scad or .FCStd; declarative assemblies use .assy:\n- "
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
        if role == "electronic_component":
            if source_type != "scad" or source.suffix != ".scad":
                errors.append(f"{label}: electronic_component requires one .scad source with type: scad")
        elif role == "printable_part":
            if source_type != "freecad" or source.suffix != ".FCStd":
                errors.append(f"{label}: printable_part requires one .FCStd source with type: freecad")
        else:
            errors.append(f"{label}: changed object requires model_role electronic_component or printable_part")

    for key, record in changed_records.items():
        if record.get("section") == "parts":
            validate_role(record, ":".join(key))

    for path in sorted(changed_assets):
        source = PurePosixPath(path)
        record = source_records.get(path.casefold())
        if source.suffix.casefold() == DECLARATIVE_ASSEMBLY_EXTENSION:
            if path.casefold() not in assembly_sources:
                errors.append(f"{path}: declarative assembly source is not referenced by an assembly object")
            continue
        if source.suffix == ".scad" and source.stem.startswith("_"):
            continue
        if source.suffix.casefold() in CANONICAL_CAD_EXTENSIONS and not record:
            errors.append(f"{path}: canonical model asset is not referenced by a catalog object")
        elif record:
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
