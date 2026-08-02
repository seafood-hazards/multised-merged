options(timeout = 600)

# ── SQLite databases ───────────────────────────────────────────────────────
# The merged database and the Norwegian aquaculture reference, from this repo's
# GitHub release. Downloaded once; a local copy (e.g. symlinked from the pipeline
# output) is reused if present.
release <- "https://github.com/seafood-hazards/multised-merged/releases/download/v0.1.0"
dbs <- c("multised_merged.sqlite", "aquaculture_no.sqlite")
for (f in dbs) {
  if (!file.exists(f)) {
    download.file(file.path(release, f), f, mode = "wb")
    message(f, " downloaded.")
  } else {
    message("Using existing ", f)
  }
}

# ── Summary CSVs ───────────────────────────────────────────────────────────
# Tidy tables written by the processing pipeline and read at render time by the
# Analyses pages ("Data Categories", "Outlier Flagging", "Grain Size", "Fe/Al
# Normalisation", "Organic Carbon", "Depth Profiles", "Bulk vs Sieved", "Depth
# and Coast", "Sampling Year", "Repeat-Sampled Sites"). Same release as the databases.
csv_dir <- "data/merged_summary"
dir.create(csv_dir, recursive = TRUE, showWarnings = FALSE)
csvs <- c("merged_coverage_fraction.csv",
          "merged_bulk_factors.csv",
          "merged_layering.csv",
          "merge_outlier_summary.csv",
          "merge_outlier_hist.csv",
          "merge_outlier_examples.csv",
          "merged_grainsize_fraction_summary.csv",
          "merged_grainsize_fines_summary.csv",
          "merged_grainsize_conc_vs_fines.csv",
          "merged_grainsize_bulk_vs_sieved.csv",
          "merged_grainsize_targets_fines.csv",
          "merged_normalisation_availability.csv",
          "merged_normalisation_correlation.csv",
          "merged_normalisation_ratios.csv",
          "merged_normalisation_pairs.csv",
          "merged_organic_availability.csv",
          "merged_organic_distribution.csv",
          "merged_organic_correlation.csv",
          "merged_organic_pairs.csv",
          "merged_depthprofile_trends.csv",
          "merged_depthprofile_enrichment.csv",
          "merged_depthprofile_pooled.csv",
          "merged_depthprofile_core_rho.csv",
          "merged_enrichment_paired.csv",
          "merged_enrichment_pairs.csv",
          "merged_enrichment_pooled.csv",
          "merged_spatial_enrichment.csv",
          "merged_spatial_covariate.csv",
          "merged_spatial_pairs.csv",
          "merged_temporal_enrichment.csv",
          "merged_temporal_covariate.csv",
          "merged_temporal_yearly.csv",
          "merged_temporal_pairs.csv",
          "merged_siteyears_trends.csv",
          "merged_siteyears_cells.csv",
          "merged_siteyears_pooled.csv",
          "merged_siteyears_meta.csv",
          "merged_clustering_kselect.csv",
          "merged_clustering_centroids.csv",
          "merged_clustering_assignments.csv",
          "merged_clustering_meta.csv",
          "merged_hotspots_summary.csv",
          "merged_hotspots_top.csv",
          "merged_hotspots_points.csv",
          "merged_hotspots_meta.csv",
          "merged_regions_weightsweep.csv",
          "merged_regions_assignments.csv",
          "merged_regions_signature.csv",
          "merged_regions_meta.csv",
          "refined_tables.csv",
          "refined_reconciliation.csv",
          "refined_coverage.csv")
for (f in csvs) {
  dest <- file.path(csv_dir, f)
  if (!file.exists(dest)) {
    download.file(file.path(release, f), dest, mode = "wb")
    message(f, " downloaded.")
  } else {
    message("Using existing ", dest)
  }
}

# ── sql.js + stratum-sqlite ────────────────────────────────────────────────
# All four files are downloaded once and served from the site.
# sql-wasm.js and sql-wasm.wasm are the sql.js engine that stratum-sqlite uses.
# stratum-sqlite.umd.js and stratum-sqlite.esm.js wrap sql.js with a clean API.
sqljs_dir <- "libs/sqljs"
dir.create(sqljs_dir, recursive = TRUE, showWarnings = FALSE)

# sql.js engine files
sqljs_base <- "https://cdnjs.cloudflare.com/ajax/libs/sql.js/1.10.3/"
for (f in c("sql-wasm.js", "sql-wasm.wasm")) {
  dest <- file.path(sqljs_dir, f)
  if (!file.exists(dest)) {
    download.file(paste0(sqljs_base, f), dest, mode = "wb")
    message(f, " downloaded.")
  }
}

# stratum-sqlite libraries
for (f in c("stratum-sqlite.umd.js", "stratum-sqlite.esm.js")) {
  dest <- file.path(sqljs_dir, f)
  if (!file.exists(dest)) {
    download.file(
      paste0("https://github.com/stratum-toolkit/stratum-sqlite/releases/latest/download/", f),
      dest, mode = "wb"
    )
    message(f, " downloaded.")
  }
}
