# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

A small collection of standalone R analysis scripts (coursework/textbook exercises): exploratory data analysis, hypothesis tests, linear regression, bootstrapping, and CART / entropy-based decision trees. There is no package structure, build system, test suite, or linter. Each script is self-contained and runs top to bottom.

## Running

```r
install.packages(c("readr", "readxl", "dplyr", "ggplot2", "rpart", "rpart.plot"))
```

```bash
Rscript R/carseats_analysis.R   # run from the repo root
```

- Scripts read data via `file.path("data", ...)`, so the working directory must be the repo root. Opening `R_Projects.Rproj` sets this in RStudio.
- Each script begins with `if (!interactive()) pdf(file.path("output", "<script>.pdf"))`, so `Rscript` runs write every plot to `output/` (git-ignored). Keep this block when adding scripts.
- The only "test" is that every script in `R/` runs under `Rscript` without errors or warnings.

## Layout

- `R/` holds the analysis scripts, with snake_case filenames.
- `data/` holds the input datasets (CSV/XLSX), which are committed.
- `output/` holds generated plots. Never commit it.

## Code conventions

- Style is flat, procedural scripts: a header comment saying what the script covers, then a comment above each step. Results are shown with `print()` or bare top-level expressions.
- Plots use `ggplot2` for most charts. Base graphics are used for residual plots and histograms, and `rpart.plot` for trees. Use `linewidth` (not `size`) for ggplot line widths.
- Entropy and information gain are hand-written (`calculate_entropy` / `calculate_info_gain`) in both the ATM and student scripts. They are then compared against `rpart(..., method = "class", parms = list(split = "information"))`, so the tree uses the same criterion.
- RStudio project settings: 2-space indentation, UTF-8.
