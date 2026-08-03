from __future__ import annotations
import hashlib, sys
from pathlib import Path
import yaml

LIMIT = 100 * 1024 * 1024
errors = []
manifests = list(Path(sys.argv[1]).rglob(".narys-upstream.yaml"))
for manifest in manifests:
    package = manifest.parent
    data = yaml.safe_load(manifest.read_text(encoding="utf-8")) or {}
    if not data.get("upstream_url") or not data.get("upstream_revision"):
        errors.append(f"{manifest}: missing upstream metadata")
    if not (package / "partcad.yaml").is_file():
        errors.append(f"{package}: missing partcad.yaml")
    for relative, expected in (data.get("checksums") or {}).items():
        path = (package / relative).resolve()
        if not path.is_relative_to(package.resolve()) or not path.is_file():
            errors.append(f"{manifest}: unsafe or missing {relative}")
        elif path.stat().st_size > LIMIT:
            errors.append(f"{path}: exceeds 100 MiB")
        elif hashlib.sha256(path.read_bytes()).hexdigest() != expected:
            errors.append(f"{path}: checksum mismatch")
print("\n".join(errors) if errors else f"Validated {len(manifests)} packages")
raise SystemExit(bool(errors))
