# Global Sediment Retention

This repository contains the MATLAB analysis behind a global assessment of sediment retention in deltas. The work quantifies how much river-borne sediment is stored on delta plains relative to the total sediment delivered to delta mouths, and it links the calculation to a set of global delta metrics, uncertainty estimates, and figure-generation scripts used in the associated manuscript.

Associated manuscript / preprint:
https://essopenarchive.org/doi/full/10.22541/essoar.15002227/v1

## Overview

The central idea is simple but powerful: for each delta, estimate the sediment flux that can be retained on the delta plain and compare it with the total fluvial sediment supply. The repository computes a retention fraction, f, using the relationship:

f = Q_plain / Q_river

where:
- Q_plain = delta area × effective delta-plain depth / delta residence time
- Q_river = river sediment flux converted to volumetric units

This creates a global, sediment-weighted assessment of how much terrestrial sediment is stored in deltaic systems rather than exported to the coast and shelf.

## Repository contents

The project includes both analysis scripts and figure-generation routines.

### Core analysis scripts
- `get_retention.m` — computes the retention fraction from river discharge, delta area, and estimated plain depth.
- `get_retention_montecarlo.m` — runs a Monte Carlo uncertainty analysis for the retention estimate.
- `get_deltaarea.m` — combines delta-area estimates from the cited data sources into a global delta-area dataset.
- `export_retention_netcdf.m` — exports summary outputs into a MATLAB structure and spreadsheet.
- `Text_Numbers.m` — assembles the main summary calculations and numerical results used in the study.

### Data and supporting files
- `GlobalDeltaArea.mat` — global delta area dataset used in the retention calculation.
- `GlobalDeltaRetention.mat` — exported retention results for each delta.
- `GlobalDeltaRetention.xlsx` — same retention results in tabular form.
- `regions.mat` — regional classification used in comparative analysis.
- `Outlets/` — outlet shapefile dataset used for spatial analysis.
- `Edmondsetal2020_NatCom_suppdata.xlsx` — supporting dataset from Edmonds et al. (2020).
- `SI_SedimentRetentionLiterature.xlsx` — literature summary used in the broader sediment retention context.
- `StanleyWarne_DeltaInitiation.xlsx` — supporting data for delta initiation context.

### Figure generation scripts
The repository also contains scripts that reproduce the publication figures, including:
- `Fig2_MethodRetention.m`
- `Fig3_Distribution.m`
- `Fig4_validation.m`
- `Fig5_QRiver.m`
- `Fig6_MarineControls.m`
- `Fig7_DeltaControls.m`

These scripts generate the figure panels and summary diagnostics shown in the manuscript.

## Output products

The main export from the analysis is a per-delta summary table with fields such as:
- `delta_name`
- `BasinID2`
- `MouthLat`
- `MouthLon`
- `Dplain_m`
- `Darea_m2`
- `Qplain_m3_yr`
- `QRiver_m3_yr`
- `fr`

where `fr` is the estimated fraction of river sediment retained by the delta.

## How the calculation works

The repository uses a global set of deltas and estimates:
1. river sediment discharge to each delta,
2. delta area and effective plain depth,
3. the floodplain or delta-plain accommodation volume available for storage,
4. the fraction of river sediment trapped by the delta.

The core logic is implemented in `get_retention.m`, which calculates a retention ratio from discharge and plain geometry. The Monte Carlo routine in `get_retention_montecarlo.m` explores uncertainty by sampling around the key inputs, providing a distribution of retention estimates rather than a single deterministic value.

## Notes on data dependencies

Several scripts reference external datasets such as `GlobalDeltaData.mat`, which are not stored in this repository. This project is therefore best interpreted as a focused analysis package for the global delta-retention calculations and figure generation, rather than a fully self-contained dataset archive.

## MATLAB usage

A typical workflow is:

```matlab
load('GlobalDeltaArea.mat','delta_area');
load('GlobalDeltaData.mat','QRiver_prist','Discharge_prist','QRiver_bedload');

QRiver = QRiver_prist + QRiver_bedload;
[fr, depth, Q_plain] = get_retention(QRiver, Discharge_prist, delta_area, 7000, 1600);
```

The scripts can then be used to compute summary statistics, create figures, or export the final retention dataset.

## Why this matters

Deltas are among the most important sediment sinks on Earth, and their ability to trap sediment controls:
- delta growth and stability,
- coastal land-building,
- ecosystem productivity,
- the delivery of sediment to adjacent marine environments.

This repository provides a reproducible framework for evaluating that retention at a global scale.

## License

This project is licensed under the MIT License. See `LICENSE` for details.

## Contact / development

For questions about the project or the analysis workflow, please contact the repository maintainer via the GitHub profile associated with this repository.
