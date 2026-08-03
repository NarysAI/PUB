# COMP-IVINS-CASE-4

A PartCAD package containing enclosure models for a Raspberry Pi 5 with the Pineboards AI Bundle.

## Models

| Part | Format | Description |
| --- | --- | --- |
| `enclosure-bottom` | STL | Bottom enclosure shell |
| `enclosure-top` | STL | Top enclosure shell |
| `thermal-insert` | 3MF | Thermal insert model |

## Use with PartCAD

```shell
pip install -U partcad-cli
pc list parts
pc inspect enclosure-bottom
pc render -r
```

The source geometry is preserved byte-for-byte from the original import. Generated previews are derivative renderings only.

## License and provenance

This repository is maintained by NarysAI. See [LICENSE](LICENSE) for reuse terms. References to Raspberry Pi and Pineboards identify compatibility only; their trademarks remain the property of their respective owners.
