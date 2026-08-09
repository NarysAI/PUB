from __future__ import annotations

import json
import re
import subprocess
import sys
from pathlib import Path, PurePosixPath


SEMVER = re.compile(r"^(0|[1-9]\d*)\.(0|[1-9]\d*)\.(0|[1-9]\d*)$")
CANONICAL_CAD_EXTENSIONS = {".scad", ".fcstd"}


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
        if Path(path).suffix.casefold() not in CANONICAL_CAD_EXTENSIONS
    )
    if invalid_assets:
        errors.append(
            "new or modified CAD assets must use .scad or .FCStd:\n- "
            + "\n- ".join(invalid_assets)
        )

    canonical_assets = {
        path.casefold(): path
        for path in current_assets
        if PurePosixPath(path).suffix.casefold() in CANONICAL_CAD_EXTENSIONS
    }
    incomplete_pairs: list[str] = []
    invalid_case: list[str] = []
    for path in sorted(changed_assets):
        source = PurePosixPath(path)
        suffix = source.suffix.casefold()
        if suffix not in CANONICAL_CAD_EXTENSIONS or source.stem.startswith("_"):
            continue
        if suffix == ".scad" and source.suffix != ".scad":
            invalid_case.append(path)
        if suffix == ".fcstd" and source.suffix != ".FCStd":
            invalid_case.append(path)
        scad = str(source.with_suffix(".scad"))
        fcstd = str(source.with_suffix(".FCStd"))
        if scad.casefold() not in canonical_assets or fcstd.casefold() not in canonical_assets:
            incomplete_pairs.append(f"{path} requires both {scad} and {fcstd}")
    if invalid_case:
        errors.append("canonical extensions must be exactly .scad and .FCStd:\n- " + "\n- ".join(invalid_case))
    if incomplete_pairs:
        errors.append("incomplete canonical model pairs:\n- " + "\n- ".join(incomplete_pairs))

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
