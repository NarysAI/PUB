from __future__ import annotations

import math
import re
import sys
from pathlib import Path
from urllib.parse import urlparse

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


def validate_project_pointer(config_path: Path, data: dict, package_root: Path) -> bool:
    metadata = data.get("narys_project")
    if metadata is None:
        return False
    label = config_path.relative_to(root)
    if not isinstance(metadata, dict):
        errors.append(f"{label}: narys_project must be a mapping")
        return True
    required = {
        "schema_version", "kind", "access", "canonical_repo", "default_branch",
        "contribution_url", "issues_url", "current_drawing", "category",
    }
    missing = sorted(required - metadata.keys())
    if missing:
        errors.append(f"{label}: narys_project is missing: {', '.join(missing)}")
    if metadata.get("schema_version") != 1:
        errors.append(f"{label}: narys_project.schema_version must be 1")
    if metadata.get("kind") != "project":
        errors.append(f"{label}: narys_project.kind must be project")
    if metadata.get("access") != "public":
        errors.append(f"{label}: PUB project pointers must have public access")
    canonical = str(metadata.get("canonical_repo", ""))
    parsed = urlparse(canonical)
    if parsed.scheme != "https" or parsed.netloc != "github.com" or len(parsed.path.strip("/").split("/")) != 2:
        errors.append(f"{label}: canonical_repo must be an HTTPS GitHub repository URL")
    for key in ("contribution_url", "issues_url"):
        value = str(metadata.get(key, ""))
        if not value.startswith(canonical.rstrip("/") + "/"):
            errors.append(f"{label}: {key} must point inside canonical_repo")
    for section in ("parts", "sketches", "assemblies"):
        if data.get(section):
            errors.append(f"{label}: project pointer must not declare {section}")
    cad_extensions = {
        ".fcstd", ".step", ".stp", ".stl", ".3mf", ".obj", ".glb", ".gltf",
        ".iges", ".igs", ".brep", ".dxf", ".f3d", ".scad",
    }
    if any(path.is_file() and path.suffix.casefold() in cad_extensions for path in package_root.rglob("*")):
        errors.append(f"{label}: project pointer contains CAD assets")
    return True


for config_path in root.rglob("partcad.yaml"):
    config_count += 1
    try:
        data = load_config(config_path)
    except Exception as exc:
        errors.append(f"{config_path.relative_to(root)}: invalid configuration: {exc}")
        continue

    package_root = config_path.parent.resolve()
    if validate_project_pointer(config_path, data, package_root):
        continue
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
