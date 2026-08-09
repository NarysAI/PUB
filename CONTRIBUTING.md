# Contributing to NarysAI PUB

Read and follow [`CATALOG_POLICY.md`](CATALOG_POLICY.md) before making changes.
It is the authoritative rule set; this file is the short operational checklist.

## Normal change

1. Update from `origin/main` and create one purpose-specific branch.
2. Add or change the package and its provenance/license documentation.
   Declare `model_role: electronic_component` with one `.scad` source for a
   real-world component, or `model_role: printable_part` with one `.FCStd`
   FreeCAD master for a manufactured/printed custom part. Never add both.
3. Bump `VERSION` and add the matching `CHANGELOG.md` entry.
4. Run `python tools/catalog_inventory.py .` to regenerate the inventory.
5. Run the registry, inventory, and release validators.
6. Render every changed model.
7. Open a PR and complete every checkbox in the template.
8. If package paths changed, open the corresponding `narys-index` PR.
9. After merge, tag the merge commit and verify `/repository`.

## Local work that must be preserved

Do not reset, overwrite, or synchronize a dirty working tree. First create and
commit a clearly named backup branch. Perform the release from a separate clean
worktree and only then switch the visible local directory to the released
`origin/main`. Keep the backup branch until its remaining work is resolved.

## Commit and branch names

Use focused names such as `feat/add-ky-009`, `fix/rpi5-preview`, or
`docs/catalog-rules`. Use Conventional Commit prefixes: `feat`, `fix`, `docs`,
`chore`, `refactor`, `test`, or `ci`.
