from __future__ import annotations

import math
import re
import sys
from pathlib import Path

import yaml
from jinja2 import ChoiceLoader, Environment, FileSystemLoader, StrictUndefined


root = Path(sys.argv[1]).resolve()
errors: list[str] = []
config_count = 0
source_count = 0


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


for config_path in root.rglob("partcad.yaml"):
    config_count += 1
    try:
        data = load_config(config_path)
    except Exception as exc:
        errors.append(f"{config_path.relative_to(root)}: invalid configuration: {exc}")
        continue

    package_root = config_path.parent.resolve()
    for section in ("parts", "sketches", "assemblies"):
        entries = data.get(section) or {}
        if not isinstance(entries, dict):
            errors.append(f"{config_path.relative_to(root)}: {section} must be a mapping")
            continue
        for name, raw in entries.items():
            if isinstance(raw, dict) and raw.get("model_role"):
                role = str(raw["model_role"])
                source_type = str(raw.get("type", "")).casefold()
                source_suffix = Path(str(raw.get("path", ""))).suffix
                if role == "electronic_component":
                    if source_type != "scad" or source_suffix != ".scad":
                        errors.append(
                            f"{config_path.relative_to(root)}: {section}.{name} electronic_component requires one .scad source"
                        )
                    elif raw.get("path"):
                        scad_path = package_root / str(raw["path"])
                        if scad_path.is_file() and re.search(r"\bimport\s*\(", scad_path.read_text(encoding="utf-8")):
                            errors.append(
                                f"{config_path.relative_to(root)}: {section}.{name} SCAD must not import mesh/CAD geometry"
                            )
                elif role == "printable_part":
                    if source_type != "freecad" or source_suffix != ".FCStd":
                        errors.append(
                            f"{config_path.relative_to(root)}: {section}.{name} printable_part requires one .FCStd source with type: freecad"
                        )
                else:
                    errors.append(
                        f"{config_path.relative_to(root)}: {section}.{name} has invalid model_role: {role}"
                    )
            if not isinstance(raw, dict) or not raw.get("path"):
                continue
            source_count += 1
            relative = str(raw["path"])
            source_path = (package_root / relative).resolve()
            if not source_path.is_relative_to(package_root):
                errors.append(f"{config_path.relative_to(root)}: unsafe {section}.{name}.path: {relative}")
            elif not source_path.is_file():
                errors.append(f"{config_path.relative_to(root)}: missing {section}.{name}.path: {relative}")

if config_count == 0:
    errors.append("no partcad.yaml files found")

print("\n".join(errors) if errors else f"Validated {config_count} package configs and {source_count} source paths")
raise SystemExit(bool(errors))
