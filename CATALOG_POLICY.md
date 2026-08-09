# NarysAI PUB change policy

This document is normative for every change to `NarysAI/PUB`, regardless of
whether it is made by a person, script, migration, or AI agent.

## 1. Core guarantees

1. **No data loss.** Existing files, packages, object names, provenance, and
   licenses must not disappear silently.
2. **One canonical tree.** The protected `PUB/main` directory tree is the source
   of truth. Every PartCAD package in it must be covered by `narys-index` and
   therefore appear in the website repository tree.
3. **Stable identity.** A package path plus its object kind and name is a public
   API. Moving or renaming it is a breaking change unless a working compatibility
   alias remains.
4. **Reproducibility.** A clean clone with Git LFS must contain everything needed
   to validate and render the catalog.
5. **Traceability.** Every merged change belongs to a numbered catalog version,
   an inventory, a changelog entry, and a reviewed pull request.

## 2. Required workflow

All changes follow this order:

1. Start from current `origin/main` in a dedicated branch or clean worktree.
2. If the working directory contains unrelated or uncommitted data, create a
   recoverable backup branch before changing or synchronizing it.
3. Add or edit the smallest complete package. Do not mix unrelated catalog work.
4. Update `VERSION` according to section 3.
5. Add the release entry to `CHANGELOG.md`.
6. Regenerate `catalog-inventory.json`.
7. Run both repository validators and render every new or changed model.
8. If the package tree changed, update `NarysAI/narys-index` in a separate PR.
9. Open a PR using the repository template. Agent-authored PRs require human
   approval. Never force-push or delete protected history.
10. Merge only after required CI passes. Create the matching `vX.Y.Z` release tag
    on the protected `main` merge commit, then verify the website.

Direct commits to `main`, unversioned changes, and release tags pointing outside
protected `main` are prohibited.

## 3. Semantic Versioning

The current catalog version is stored in `VERSION`.

- **PATCH** (`1.1.0` → `1.1.1`): documentation, metadata, previews, rules, or a
  compatible geometry correction that preserves all package and object IDs.
- **MINOR** (`1.1.1` → `1.2.0`): one or more new packages or objects, with no
  removal of existing IDs.
- **MAJOR** (`1.2.0` → `2.0.0`): removal, rename, relocation without an alias, or
  any other incompatible semantic-path change.

Each PR must make exactly one appropriate increment. CI compares the PR against
its base inventory and rejects an absent, insufficient, or malformed bump.

## 4. Package and file rules

Each publishable package must contain a valid `partcad.yaml` with a stable
absolute `/pub/...` name. Every declared source must stay inside its package and
must exist with exact filename casing.

For new or imported models:

- retain the best available editable/original source and a browser-convertible
  model where practical;
- document source URL, author/vendor, part number or SKU, dimensional accuracy,
  and any known limitations in `README.md` or provenance metadata;
- include the original license. Unknown terms must be marked
  `license_status: unverified` and must never be represented as permissive;
- store large supported assets through Git LFS and verify that LFS objects exist
  on GitHub from a clean checkout;
- do not commit caches, generated temporary files, secrets, credentials, or
  unrelated inherited test artifacts.

Generated GLB/STL previews are derivatives, not replacements for the canonical
CAD source. A source may be removed only when the changelog explains why and the
package remains reproducible.

### Canonical CAD formats

Every new or changed model declares exactly one `model_role`, and that role
determines its only canonical source format:

- **`electronic_component` → `.scad` only.** Cameras, PCBs, modules, connectors,
  motors, sensors, purchased assemblies, and other real-world components use a
  self-contained, AI-readable OpenSCAD representation for reasoning, dimensional
  inspection, placement, clearance, and website preview. They must not contain
  an FCStd master in PUB.
- **`printable_part` → `.FCStd` only.** A custom part intended to be manufactured
  or 3D-printed uses an editable FreeCAD document with correct units, construction
  history, and a final valid solid/body. STL and STEP are generated from this
  master outside the canonical source tree.

The roles and formats are mutually exclusive. A standalone object must not carry
both SCAD and FCStd sources. Shared SCAD libraries whose filename begins with `_`
are implementation helpers for electronic-component models and are not catalog
objects themselves.

STEP/STP, STL, 3MF, OBJ, GLB/glTF, IGES, BREP, DXF, F3D, and other CAD/mesh
formats are not accepted as new canonical PUB data. They may be generated outside
PUB for interchange, slicing, download, or browser caching, but they do not
replace the role-selected `.scad` or `.FCStd` source. Generated STL and STEP files
for printable parts are created from the FreeCAD master and are not stored as
canonical PUB data.

Legacy non-canonical assets already present in a released inventory are retained
until a lossless, reviewed migration is available. They must not be deleted in
bulk, silently rewritten, or treated as evidence of an editable source. Any
change to a legacy asset requires migration to the correct role and format in
the same PR, preservation of provenance, visual/dimensional comparison, and the version
bump required by the resulting identity changes. CI blocks newly added or
modified non-canonical CAD assets and role/format mismatches while allowing
unchanged legacy data.

## 5. Modification, relocation, and deletion

- Never overwrite the only copy of local work. Preserve it in Git before sync.
- Prefer additive compatibility aliases over renames.
- A deletion must list every removed stable package/object path in the changelog,
  state the reason, and provide a replacement or migration path when one exists.
- Deleting or moving an asset requires intentional inventory removal in the same
  PR. Deleting an object/package requires a MAJOR release.
- Bulk mechanical changes must be isolated from functional catalog changes and
  must prove that object identities and geometry were preserved.

## 6. Mandatory validation

Before merge, the PR must pass:

```text
python tools/validate_registry.py .
python tools/catalog_inventory.py . --check
python tools/validate_release.py . origin/main
```

New or changed 3D sources must additionally render successfully through the same
conversion path used by `narys-web`. After index merge, verify:

- the package is present under `/repository` in the expected directory;
- search returns the package and objects;
- every changed model preview returns HTTP 200;
- the website tree coverage workflow passes in `narys-index`.

## 7. Ownership and recovery

`NeoUKR` owns final catalog approval. Backup branches are not releases and must
not be deleted until their contents are either merged, intentionally rejected,
or archived elsewhere. Recovery actions must name the source branch and commit.

## 8. Policy versioning

Policy versions are independent from catalog versions. `POLICY_VERSION` uses
Semantic Versioning and every policy release is tagged `policy-vX.Y.Z`:

- PATCH clarifies wording without changing obligations;
- MINOR adds a backward-compatible requirement or validation;
- MAJOR removes or incompatibly changes an established workflow.

Policy changes are recorded in `POLICY_CHANGELOG.md`. A policy edit may also
require a catalog PATCH because the policy files themselves are versioned in PUB.
