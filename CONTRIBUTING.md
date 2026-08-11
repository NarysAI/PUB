# Contributing to NarysAI PUB

Read and follow [`CATALOG_POLICY.md`](CATALOG_POLICY.md) before making changes.
It is the authoritative rule set; this file is the short operational checklist.

## Normal change

1. Update from `origin/main` and create one purpose-specific branch.
2. Add or change the package and its provenance/license documentation.
   Every new 3D part must include an optimized same-stem `.scad` + `.stl` pair
   in `narys.representations`. Declare the appropriate `model_role`; a printable
   part additionally keeps its canonical `.FCStd` FreeCAD master. Two-dimensional
   sketches use PartCAD sketch source types and do not declare a 3D model role.
3. Bump `VERSION` and add the matching `CHANGELOG.md` entry.
4. Run `python tools/catalog_inventory.py .` to regenerate the inventory.
5. Run the registry, inventory, and release validators.
6. Render every changed model.
7. Open a PR and complete every checkbox in the template.
8. If package paths changed, open the corresponding `narys-index` PR.
9. After merge, tag the merge commit, refresh production, and verify the public
   HTTPS object page, search, downloads, and 3D preview. Do not mark the task
   complete while the change exists only locally or in a PR.

## Local work that must be preserved

Do not reset, overwrite, or synchronize a dirty working tree. First create and
commit a clearly named backup branch. Perform the release from a separate clean
worktree and only then switch the visible local directory to the released
`origin/main`. Keep the backup branch until its remaining work is resolved.

## Commit and branch names

Use focused names such as `feat/add-ky-009`, `fix/rpi5-preview`, or
`docs/catalog-rules`. Use Conventional Commit prefixes: `feat`, `fix`, `docs`,
`chore`, `refactor`, `test`, or `ci`.
