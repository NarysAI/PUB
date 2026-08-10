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
known_object_refs: set[tuple[str, str]] = set()
pending_component_refs: list[tuple[str, str, str]] = []
STEP_PRODUCT_PATTERN = re.compile(
    rb"\bPRODUCT\s*\(\s*'((?:''|[^'])*)'\s*,\s*'((?:''|[^'])*)'",
    re.IGNORECASE,
)


def step_product_has_identifier(content: bytes, identifier: bytes) -> bool:
    return any(identifier in product_id or identifier in name for product_id, name in STEP_PRODUCT_PATTERN.findall(content))


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
    package_name = str(data.get("name") or "//pub/" + config_path.parent.relative_to(root).as_posix())
    semantic_package = package_name.removeprefix("//pub/").removeprefix("//")
    for object_kind, section in (("part", "parts"), ("assembly", "assemblies"), ("sketch", "sketches")):
        entries = data.get(section) or {}
        if isinstance(entries, dict):
            known_object_refs.update(
                (object_kind, f"{semantic_package}:{name}") for name in entries
            )
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
                    allowed = {
                        "scad": {".scad"},
                        "stl": {".stl"},
                        "step": {".step", ".stp"},
                    }
                    if source_suffix.casefold() not in allowed.get(source_type, set()):
                        errors.append(
                            f"{config_path.relative_to(root)}: {section}.{name} electronic_component requires matching SCAD, STL, or STEP"
                        )
                    elif source_type == "scad" and raw.get("path"):
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
            narys = raw.get("narys") if isinstance(raw, dict) and isinstance(raw.get("narys"), dict) else {}
            representations = narys.get("representations")
            if representations is not None:
                label = f"{config_path.relative_to(root)}: {section}.{name}"
                if not isinstance(representations, dict) or representations.get("schema_version") != 1:
                    errors.append(f"{label} narys.representations requires schema_version 1")
                else:
                    files = representations.get("files")
                    if not isinstance(files, list) or not files:
                        errors.append(f"{label} representations.files must not be empty")
                    else:
                        seen_formats: set[str] = set()
                        primary_files = []
                        suffixes = {"scad": {".scad"}, "stl": {".stl"}, "step": {".step", ".stp"}}
                        for representation in files:
                            if not isinstance(representation, dict):
                                errors.append(f"{label} representation must be a mapping")
                                continue
                            source_format = str(representation.get("format", "")).casefold()
                            if source_format not in suffixes or source_format in seen_formats:
                                errors.append(f"{label} requires unique SCAD, STL, or STEP representations")
                                continue
                            seen_formats.add(source_format)
                            relative_rep = str(representation.get("path", ""))
                            rep_path = (package_root / relative_rep).resolve()
                            if not relative_rep or not rep_path.is_relative_to(package_root) or not rep_path.is_file():
                                errors.append(f"{label} missing representation: {relative_rep}")
                                continue
                            if rep_path.suffix.casefold() not in suffixes[source_format]:
                                errors.append(f"{label} representation does not match format: {relative_rep}")
                            expected_scope = "interior" if source_format == "step" else "exterior"
                            if representation.get("geometry_scope") != expected_scope:
                                errors.append(f"{label} {source_format} requires geometry_scope: {expected_scope}")
                            if representation.get("primary"):
                                primary_files.append(relative_rep)
                            if source_format == "step":
                                components = representation.get("components")
                                if not isinstance(components, list) or not components:
                                    errors.append(f"{label} STEP requires catalog components")
                                    continue
                                content = rep_path.read_bytes()
                                for component in components:
                                    if not isinstance(component, dict):
                                        errors.append(f"{label} STEP component must be a mapping")
                                        continue
                                    kind = str(component.get("kind", "part")).casefold().removesuffix("s")
                                    semantic_path = str(component.get("semantic_path", "")).strip()
                                    identifier = f"narys:{kind}/{semantic_path}"
                                    if kind not in {"part", "assembly", "sketch"} or not semantic_path:
                                        errors.append(f"{label} STEP component requires an exact catalog reference")
                                    elif not step_product_has_identifier(content, identifier.encode("ascii")):
                                        errors.append(f"{label} STEP component name is missing {identifier}")
                                    else:
                                        pending_component_refs.append((kind, semantic_path, label))
                        if len(primary_files) != 1 or primary_files[0] != str(raw.get("path", "")):
                            errors.append(f"{label} requires one primary representation matching path")
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

for kind, semantic_path, label in pending_component_refs:
    if (kind, semantic_path) not in known_object_refs:
        errors.append(f"{label} STEP component is absent from catalog: {kind}/{semantic_path}")

print("\n".join(errors) if errors else f"Validated {config_count} package configs and {source_count} source paths")
raise SystemExit(bool(errors))
