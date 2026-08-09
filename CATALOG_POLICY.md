# NarysAI PUB catalog policy

`PUB` is an append-safe public CAD catalog. Its stable identity is the PartCAD
package path and the object name inside that package.

## Versioning

The catalog follows Semantic Versioning and stores the current version in
`VERSION`.

- **PATCH**: metadata, documentation, preview, or geometry correction that keeps
  every existing package path and object name working.
- **MINOR**: new packages or objects, including backward-compatible aliases.
- **MAJOR**: removal or rename of a package/object, or any incompatible change to
  a stable semantic path.

Every version change must update `CHANGELOG.md` and regenerate
`catalog-inventory.json`.

## Change rules

1. Never delete or rename a package, object, or CAD asset silently. Record the
   old path and migration path under `Changed` or `Removed` in the changelog.
2. Run `python tools/validate_registry.py .` and
   `python tools/catalog_inventory.py .` before committing catalog changes.
3. Commit the regenerated inventory with the same change. CI rejects an
   inventory that does not exactly match package configurations and CAD assets.
4. New external models require provenance and license information. If the
   license is unknown, mark it `license_status: unverified`; do not claim reuse
   rights that have not been confirmed.
5. Changes reach `main` through a pull request. Agent-authored pull requests
   require review; force pushes and branch deletion remain prohibited.
6. A release tag is `v` plus the catalog version (for example `v1.2.0`) and must
   point to protected `main`.

## Review checklist

- Stable paths were preserved, or the version was bumped as a breaking change.
- Inventory and changelog were updated intentionally.
- The registry validator and inventory check pass.
- New models appear in the Narys index and on the `/repository` page.
