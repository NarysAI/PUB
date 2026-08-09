from __future__ import annotations

import argparse
import difflib
import hashlib
import json
import math
import re
import sys
from pathlib import Path

import yaml
from jinja2 import ChoiceLoader, Environment, FileSystemLoader, StrictUndefined


ASSET_EXTENSIONS = {
    ".3mf", ".assy", ".brep", ".dxf", ".f3d", ".fcstd", ".glb", ".gltf",
    ".iges", ".igs", ".kicad_mod", ".kicad_pcb", ".kicad_pro", ".kicad_sch",
    ".obj", ".scad", ".step", ".stl", ".stp", ".svg",
}
TEXT_ASSET_EXTENSIONS = {
    ".dxf", ".gltf", ".kicad_mod", ".kicad_pcb", ".kicad_pro", ".kicad_sch",
    ".scad", ".svg",
}
SECTIONS = ("parts", "sketches", "assemblies")
SEMVER = re.compile(r"^(0|[1-9]\d*)\.(0|[1-9]\d*)\.(0|[1-9]\d*)$")


def canonical_bytes(path: Path, text: bool = False) -> bytes:
    content = path.read_bytes()
    return content.replace(b"\r\n", b"\n") if text else content


def sha256(content: bytes) -> str:
    return hashlib.sha256(content).hexdigest()


def load_config(path: Path) -> dict:
    source = path.read_text(encoding="utf-8")
    if "{%" in source or "{{" in source:
        search_dirs = [path.parent, *list(path.parents)[:4]]
        environment = Environment(
            loader=ChoiceLoader([FileSystemLoader(str(directory)) for directory in search_dirs]),
            undefined=StrictUndefined,
            autoescape=False,
        )
        source = environment.from_string(source).render(
            package_name=path.parent.name,
            M_PI=math.pi,
            PI=math.pi,
            SQRT_2=math.sqrt(2),
            SQRT_3=math.sqrt(3),
            SQRT_5=math.sqrt(5),
            INCH=25.4,
            INCHES=25.4,
            FOOT=304.8,
            FEET=304.8,
            get_from_config=lambda: None,
        )
    data = yaml.safe_load(source) or {}
    if not isinstance(data, dict):
        raise ValueError("top level must be a mapping")
    return data


def build_inventory(root: Path) -> dict:
    packages = []
    objects = []
    configs = sorted(root.rglob("partcad.yaml"), key=lambda path: path.relative_to(root).as_posix())
    for config_path in configs:
        relative_config = config_path.relative_to(root).as_posix()
        data = load_config(config_path)
        package_name = str(data.get("name") or "/" + config_path.parent.relative_to(root).as_posix())
        packages.append({
            "name": package_name,
            "config": relative_config,
            "config_sha256": sha256(canonical_bytes(config_path, text=True)),
        })
        for section in SECTIONS:
            entries = data.get(section) or {}
            if not isinstance(entries, dict):
                continue
            for name, raw in sorted(entries.items()):
                raw = raw if isinstance(raw, dict) else {}
                item = {
                    "package": package_name,
                    "section": section,
                    "name": str(name),
                    "type": str(raw.get("type") or "native"),
                }
                if raw.get("path"):
                    item["source"] = (config_path.parent / str(raw["path"])).relative_to(root).as_posix()
                objects.append(item)

    assets = []
    paths = sorted(root.rglob("*"), key=lambda path: path.relative_to(root).as_posix())
    for path in paths:
        if path.is_file() and path.suffix.lower() in ASSET_EXTENSIONS:
            content = canonical_bytes(path, text=path.suffix.lower() in TEXT_ASSET_EXTENSIONS)
            assets.append({
                "path": path.relative_to(root).as_posix(),
                "bytes": len(content),
                "sha256": sha256(content),
            })

    version = (root / "VERSION").read_text(encoding="utf-8").strip()
    if not SEMVER.fullmatch(version):
        raise ValueError(f"VERSION is not a stable Semantic Version: {version!r}")
    package_names = [item["name"] for item in packages]
    if len(package_names) != len(set(package_names)):
        raise ValueError("duplicate PartCAD package names found")
    return {
        "schema_version": 1,
        "catalog_version": version,
        "summary": {
            "packages": len(packages),
            "objects": len(objects),
            "assets": len(assets),
            "asset_bytes": sum(item["bytes"] for item in assets),
        },
        "packages": packages,
        "objects": objects,
        "assets": assets,
    }


def serialize(inventory: dict) -> str:
    return json.dumps(inventory, indent=2, ensure_ascii=False) + "\n"


def main() -> int:
    parser = argparse.ArgumentParser(description="Build or verify the NarysAI PUB inventory")
    parser.add_argument("root", nargs="?", default=".")
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    root = Path(args.root).resolve()
    destination = root / "catalog-inventory.json"
    rendered = serialize(build_inventory(root))
    if args.check:
        current = destination.read_text(encoding="utf-8") if destination.is_file() else ""
        if current != rendered:
            print("catalog-inventory.json is stale; run: python tools/catalog_inventory.py .", file=sys.stderr)
            diff = difflib.unified_diff(
                current.splitlines(), rendered.splitlines(),
                fromfile="committed/catalog-inventory.json",
                tofile="generated/catalog-inventory.json",
                n=2,
            )
            for line in list(diff)[:80]:
                print(line, file=sys.stderr)
            return 1
        print("Catalog inventory is complete and current")
        return 0
    destination.write_text(rendered, encoding="utf-8", newline="\n")
    print(f"Wrote {destination}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
