from __future__ import annotations

import tempfile
import unittest
from pathlib import Path

from tools.validate_release import validate_scad_stl_bundle


ASCII_STL = """solid model
facet normal 0 0 1
  outer loop
    vertex 0 0 0
    vertex 1 0 0
    vertex 0 1 0
  endloop
endfacet
endsolid model
"""


class ScadStlBundleTests(unittest.TestCase):
    def setUp(self) -> None:
        self.temporary = tempfile.TemporaryDirectory()
        self.root = Path(self.temporary.name)
        (self.root / "model.scad").write_text("cube([1, 1, 1]);\n", encoding="utf-8")
        (self.root / "model.stl").write_text(ASCII_STL, encoding="ascii")
        self.assets = {"model.scad": "scad-digest", "model.stl": "stl-digest"}
        self.record = {
            "representations": [
                {"format": "scad", "source": "model.scad"},
                {"format": "stl", "source": "model.stl"},
            ]
        }

    def tearDown(self) -> None:
        self.temporary.cleanup()

    def test_complete_bundle_passes(self) -> None:
        self.assertEqual(validate_scad_stl_bundle(self.root, self.record, self.assets, "part"), [])

    def test_missing_stl_is_rejected(self) -> None:
        record = {"representations": [{"format": "scad", "source": "model.scad"}]}
        errors = validate_scad_stl_bundle(self.root, record, self.assets, "part")
        self.assertTrue(any("requires optimized SCAD and STL" in error for error in errors))

    def test_mismatched_names_are_rejected(self) -> None:
        record = {
            "representations": [
                {"format": "scad", "source": "model.scad"},
                {"format": "stl", "source": "different.stl"},
            ]
        }
        assets = {**self.assets, "different.stl": self.assets["model.stl"]}
        (self.root / "different.stl").write_text(ASCII_STL, encoding="ascii")
        errors = validate_scad_stl_bundle(self.root, record, assets, "part")
        self.assertTrue(any("same path and base filename" in error for error in errors))

    def test_scad_import_is_rejected(self) -> None:
        (self.root / "model.scad").write_text('import("model.stl");\n', encoding="utf-8")
        errors = validate_scad_stl_bundle(self.root, self.record, self.assets, "part")
        self.assertTrue(any("self-contained" in error for error in errors))

    def test_invalid_stl_is_rejected(self) -> None:
        (self.root / "model.stl").write_bytes(b"not an stl")
        errors = validate_scad_stl_bundle(self.root, self.record, self.assets, "part")
        self.assertTrue(any("invalid STL" in error for error in errors))


if __name__ == "__main__":
    unittest.main()
