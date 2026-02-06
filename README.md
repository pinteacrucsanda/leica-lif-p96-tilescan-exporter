# LIF to OME-TIFF splitter for Leica Thunder p96 plates

## Description

This Fiji/ImageJ macro splits Leica `.lif` files acquired with **Leica Thunder** from **96-well Ibidi plates (p96)** into individual `.ome.tif` images.

Each output image corresponds to one **well** and one **field (position)** and is saved with a standardized filename encoding this information.

The macro is designed to be robust, re-runnable, and suitable for large multi-series `.lif` files.

---

## Experimental context

- Plate format: 96-well Ibidi plates (p96)
- Acquisition system: Leica Thunder
- Input: single `.lif` file containing multiple series
- Series naming pattern (as stored by Leica Thunder): TileScan X/<Row>/<Column>/P<Position>


For each field, Leica Thunder may also store an additional ICC (computational clearing) version.

---

## What the macro does

- Iterates over all series in a Leica `.lif` file
- Extracts **well ID** and **position number** from the series title
- Skips ICC (computational clearing) images
- Saves each raw field as an `.ome.tif` file
- Uses the naming scheme: Well_<Row><Column>_P<Position>.ome.tif

- Skips already processed images, allowing safe re-execution

---

## Output

For an input file: TITLE_IMAGE.lif

The macro generates:

TITLE_IMAGE/
├── Well_B3_P1.ome.tif
├── Well_B3_P2.ome.tif
├── Well_C4_P7.ome.tif
└── ...


---

## Requirements

- Fiji / ImageJ (Bio-Formats included)
- Leica `.lif` files acquired with Thunder

---

## Notes

- Execution can be slow for large files with many series; this is expected.
- The macro can be safely interrupted and re-run.
- ICC images are excluded by default to preserve raw data.

---
