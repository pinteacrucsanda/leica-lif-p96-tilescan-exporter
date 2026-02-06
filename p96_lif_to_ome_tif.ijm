// ======================================================================
// Leica LIF p96 TileScan Exporter
// ======================================================================
//
// Description:
// ImageJ/Fiji macro for robust batch export of TileScan acquisitions from
// Leica LIF files acquired on 96-well plates. The macro iterates over all
// series in a LIF file, automatically extracts well and position metadata
// from the image title, skips ICC (Illumination Correction Channel) images,
// and exports RAW TileScan positions as individually named TIFF files.
//
// Output naming convention:
//   Well_[Row][Column]_P[Position].ome.tif
//   Example: Well_B3_P5.ome.tif
//
// Key features:
// - Designed for 96-well plate TileScan acquisitions (A–H, 1–12)
// - Automatic detection and exclusion of ICC images
// - Robust parsing of well and position metadata
// - Safe re-execution (skips already exported files)
// - Optimized for stability in large datasets
//
// Requirements:
// - ImageJ/Fiji
// - Bio-Formats plugin (standard Fiji installation)
//
// Tested on:
// - Fiji (ImageJ 1.54p)
// - Windows 10
// - Leica LIF files acquired with TileScan + ICC enabled
//
// Author: Rucsanda Pinteac
// License: MIT
// Repository: https://github.com/<your-username>/leica-lif-p96-tilescan-exporter
// ======================================================================


// ==============================
// OPEN SERIES AND PARSE TITLE (ROBUST)
// ==============================

lifPath = File.openDialog("Select LIF file");
if (lifPath == "") exit("No LIF selected");

print("Processing: " + lifPath);

// === OUTPUT DIRECTORY ===
parentDir = File.getParent(lifPath);
baseName = File.getName(lifPath);
baseName = replace(baseName, ".lif", "");

outputDir = parentDir + File.separator + baseName + File.separator;
File.makeDirectory(outputDir);

// Speed up (no GUI redraw)
setBatchMode(true);

run("Bio-Formats Macro Extensions");
Ext.setId(lifPath);
Ext.getSeriesCount(seriesCount);
print("Series count: " + seriesCount);

for (s = 0; s < seriesCount; s++) {

 run(
    "Bio-Formats Importer",
    "open=[" + lifPath + "] series_" + s +
    " autoscale color_mode=Default view=Hyperstack stack_order=XYCZT"
);


    title = getTitle();
    print("Opened title: " + title);

    // --- Skip ICC ---
    if (indexOf(title, "_ICC") >= 0) {
        print("   Skipping ICC image");
        close();
        continue;
    }

    // --- Extract TileScan metadata ---
    idx = indexOf(title, "TileScan");
    if (idx < 0) {
        print("WARNING: TileScan not found in title");
        close();
        continue;
    }

    meta = substring(title, idx);
    parts = split(meta, "/");

    if (parts.length < 4) {
        print("WARNING: Unexpected TileScan format: " + meta);
        close();
        continue;
    }

    row = parts[1];
    col = parts[2];
    pos = replace(parts[3], "P", "");
    well = row + col;

    print("   Well: " + well + " | Position: " + pos);

    outName = "Well_" + well + "_P" + pos + ".ome.tif";
    outPath = outputDir + outName;

    if (File.exists(outPath)) {
        print("   Already exists, skipping: " + outName);
        close();
        continue;
    }

    saveAs("Tiff", outPath);
    close();
}

// 🔴 SOLO AQUÍ
setBatchMode(false);
print("Done.");
