options(tigris_use_cache = TRUE)
set.seed(20260408)

suppressPackageStartupMessages({
  library(sf)
  library(broom)
  library(dplyr)
  library(readr)
  library(ggplot2)
  library(jsonlite)
  library(scales)
  library(stringr)
  library(purrr)
  library(tidyr)
  library(tigris)
  library(spatstat.geom)
  library(spatstat.explore)
  library(spdep)
  library(units)
})

`%||%` <- function(x, y) if (is.null(x)) y else x

script_args <- commandArgs(trailingOnly = FALSE)
script_file <- script_args[grepl("^--file=", script_args)]
if (length(script_file) > 0) {
  script_file <- sub("^--file=", "", script_file[[1]])
} else {
  script_file <- NULL
}

root_dir <- normalizePath(
  file.path(dirname(script_file %||% file.path(getwd(), "explorations/coyote-gis-clustering/src/run_analysis.R")), ".."),
  mustWork = FALSE
)
data_dir <- file.path(root_dir, "data")
raw_dir <- file.path(data_dir, "raw")
external_dir <- file.path(data_dir, "external")
output_dir <- file.path(root_dir, "output")

dir.create(raw_dir, recursive = TRUE, showWarnings = FALSE)
dir.create(external_dir, recursive = TRUE, showWarnings = FALSE)
dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)

run_curl <- function(args) {
  quoted_args <- vapply(c("-sS", args), shQuote, character(1))
  out <- system2("curl", args = quoted_args, stdout = TRUE, stderr = TRUE)
  paste(out, collapse = "\n")
}

download_if_missing <- function(url, dest) {
  if (!file.exists(dest)) {
    message("Downloading ", basename(dest))
    status <- system2(
      "curl",
      args = c("-L", "--max-time", "600", url, "-o", dest),
      stdout = FALSE,
      stderr = FALSE
    )
    if (!identical(status, 0L)) {
      stop("Download failed for ", url)
    }
  }
  dest
}

unzip_if_needed <- function(zipfile, exdir) {
  if (!dir.exists(exdir) || length(list.files(exdir, all.files = TRUE, no.. = TRUE)) == 0) {
    dir.create(exdir, recursive = TRUE, showWarnings = FALSE)
    unzip(zipfile, exdir = exdir)
  }
  exdir
}

pick_shapefile <- function(exdir, pattern = NULL) {
  files <- list.files(exdir, pattern = "\\.shp$", recursive = TRUE, full.names = TRUE)
  if (!is.null(pattern)) {
    matched <- files[str_detect(tolower(basename(files)), tolower(pattern))]
    if (length(matched) > 0) {
      return(matched[[1]])
    }
  }
  if (length(files) == 0) stop("No shapefile found in ", exdir)
  files[[1]]
}

normalize_address <- function(x) {
  x |>
    str_squish() |>
    na_if("") |>
    str_replace_all("\\s+", " ")
}

parse_time_safe <- function(x) {
  parsed <- suppressWarnings(as.POSIXct(strptime(x, format = "%I:%M %p", tz = "America/New_York")))
  ifelse(is.na(parsed), NA_real_, as.numeric(format(parsed, "%H")) + as.numeric(format(parsed, "%M")) / 60)
}

point_pattern_metrics <- function(sf_points, boundary_26986, label) {
  pts <- st_coordinates(sf_points)
  window <- as.owin(st_geometry(boundary_26986))
  ppp_obj <- ppp(x = pts[, 1], y = pts[, 2], window = window, checkdup = FALSE)

  observed_nnd <- mean(nndist(ppp_obj))
  simulated_nnd <- replicate(
    199,
    mean(nndist(runifpoint(n = nrow(sf_points), win = window)))
  )
  expected_nnd <- mean(simulated_nnd)
  nnd_p <- (sum(simulated_nnd <= observed_nnd) + 1) / (length(simulated_nnd) + 1)
  qt <- quadrat.test(ppp_obj, nx = 4, ny = 4)
  env <- envelope(ppp_obj, fun = Lest, nsim = 39, rank = 1, correction = "border", verbose = FALSE)
  env_df <- as.data.frame(env)

  tibble(
    scenario = label,
    n_points = nrow(sf_points),
    nearest_neighbor_ratio = observed_nnd / expected_nnd,
    nearest_neighbor_p_value = nnd_p,
    quadrat_chisq = unname(qt$statistic),
    quadrat_p_value = qt$p.value,
    max_l_minus_r = max(env_df$obs - env_df$r, na.rm = TRUE),
    max_l_minus_r_at_m = env_df$r[which.max(env_df$obs - env_df$r)],
    ripley_above_envelope_any = any(env_df$obs > env_df$hi, na.rm = TRUE)
  )
}

distance_metrics <- function(points_26986, controls_26986, feature_sf, feature_name) {
  if (nrow(feature_sf) == 0) {
    return(tibble(
      feature = feature_name,
      point_median_m = NA_real_,
      control_median_m = NA_real_,
      point_mean_m = NA_real_,
      control_mean_m = NA_real_,
      wilcox_p_value = NA_real_
    ))
  }

  feature_union <- st_union(st_geometry(feature_sf))
  point_d <- drop_units(st_distance(points_26986, feature_union))
  ctrl_d <- drop_units(st_distance(controls_26986, feature_union))

  tibble(
    feature = feature_name,
    point_median_m = median(point_d),
    control_median_m = median(ctrl_d),
    point_mean_m = mean(point_d),
    control_mean_m = mean(ctrl_d),
    wilcox_p_value = suppressWarnings(wilcox.test(as.numeric(point_d), as.numeric(ctrl_d))$p.value)
  )
}

hotspot_sensitivity <- function(boundary_26986, points_sf, cell_sizes = c(150, 250, 400, 600)) {
  map_dfr(cell_sizes, function(cell_size) {
    grid <- st_make_grid(boundary_26986, cellsize = cell_size, square = TRUE) |>
      st_as_sf() |>
      st_intersection(boundary_26986) |>
      mutate(grid_id = row_number()) |>
      select(grid_id)

    grid$count <- lengths(st_intersects(grid, points_sf))
    neighbors <- poly2nb(as_Spatial(grid), queen = TRUE)
    weights <- nb2listw(neighbors, style = "W", zero.policy = TRUE)
    local_stats <- localmoran(grid$count, weights, zero.policy = TRUE)

    tibble(
      cell_size_m = cell_size,
      n_cells = nrow(grid),
      hotspot_cells = sum(local_stats[, "Ii"] > 0 & local_stats[, "Pr(z != E(Ii))"] < 0.05 & grid$count > 0)
    )
  })
}

massgis_openspace_url <- "https://s3.us-east-1.amazonaws.com/download.massgis.digital.mass.gov/shapefiles/state/openspace.zip"
massgis_nwi_url <- "https://s3.us-east-1.amazonaws.com/download.massgis.digital.mass.gov/shapefiles/state/nwi.zip"
coyote_query_url <- "https://www.mapsonline.net/peopleforms/mo4/mo4_server.php?request=identify_multi"
viewer_login_url <- "https://www.mapsonline.net/form_server/htdocs/transaction.php"

login_json <- run_curl(c(
  "-L", "--max-time", "20", "-X", "POST", viewer_login_url,
  "--data-urlencode", "request=login",
  "--data-urlencode", "user=viewer",
  "--data-urlencode", "password=viewer",
  "--data-urlencode", "format=json",
  "--data-urlencode", "cid=21"
))

login <- fromJSON(login_json)
ssid <- login$ssid

coyote_json <- run_curl(c(
  "-L", "--max-time", "60", "-X", "POST", coyote_query_url,
  "--data-urlencode", "sitelayers=28433",
  "--data-urlencode", "layers=5629",
  "--data-urlencode", "results=limited",
  "--data-urlencode", "site_id=746",
  "--data-urlencode", "bbox=727323,2959310,757755,2981520",
  "--data-urlencode", "width=1200",
  "--data-urlencode", "height=900",
  "--data-urlencode", "mode=replace",
  "--data-urlencode", "geomType=polygon",
  "--data-urlencode", "geom=POLYGON((727323 2959310,757755 2959310,757755 2981520,727323 2981520,727323 2959310))",
  "--data-urlencode", paste0("sid=", ssid)
))

writeLines(coyote_json, file.path(raw_dir, "belmont_coyote_identify_multi.json"))

coyote_payload <- fromJSON(coyote_json, simplifyDataFrame = FALSE)
coyote_result <- coyote_payload$results[[1]]
coyote_tbl <- map_dfr(seq_along(coyote_result$results), function(i) {
  row <- coyote_result$results[[i]]
  tibble(
    reporting_address = row$values[[1]] %||% NA_character_,
    date_report = row$values[[2]] %||% NA_character_,
    report_time = row$values[[3]] %||% NA_character_,
    date_epoch_ms = suppressWarnings(as.numeric(row$values[[4]] %||% NA_character_)),
    record_id = as.integer(row$record_id),
    jump_id = row$jump_id,
    geom_wkt_3857 = row$geom
  )
})

coyote_sf <- coyote_tbl |>
  mutate(
    reporting_address = normalize_address(reporting_address),
    date_report = na_if(date_report, "__EMPTY__VALUE__"),
    report_time = na_if(report_time, "__EMPTY__VALUE__"),
    date = suppressWarnings(as.Date(if_else(str_detect(coalesce(date_report, ""), "^\\d{4}-\\d{2}-\\d{2}$"), date_report, NA_character_))),
    year = as.integer(format(date, "%Y")),
    hour_decimal = parse_time_safe(report_time),
    geom = st_as_sfc(geom_wkt_3857, crs = 3857)
  ) |>
  st_as_sf()

belmont_boundary <- county_subdivisions(
  state = "MA",
  county = "Middlesex",
  cb = TRUE,
  year = 2024,
  class = "sf"
) |>
  filter(str_detect(NAME, "^Belmont")) |>
  st_transform(26986) |>
  summarise(geometry = st_union(geometry))

coyote_26986 <- coyote_sf |>
  st_transform(26986) |>
  st_intersection(belmont_boundary)

coords_26986 <- st_coordinates(coyote_26986)
coyote_26986$x <- coords_26986[, 1]
coyote_26986$y <- coords_26986[, 2]
coyote_26986 <- coyote_26986 |>
  mutate(
    coord_key = paste(round(x, 3), round(y, 3), sep = "_"),
    season = case_when(
      is.na(date) ~ NA_character_,
      as.integer(format(date, "%m")) %in% c(12, 1, 2) ~ "winter",
      as.integer(format(date, "%m")) %in% c(3, 4, 5) ~ "spring",
      as.integer(format(date, "%m")) %in% c(6, 7, 8) ~ "summer",
      TRUE ~ "fall"
    )
  )

unique_locations <- coyote_26986 |>
  group_by(coord_key) |>
  slice_head(n = 1) |>
  ungroup()

top_repeat_keys <- coyote_26986 |>
  st_drop_geometry() |>
  count(coord_key, sort = TRUE) |>
  slice_head(n = 5) |>
  pull(coord_key)

trimmed_points <- coyote_26986 |>
  filter(!coord_key %in% top_repeat_keys)

openspace_zip <- download_if_missing(massgis_openspace_url, file.path(external_dir, "openspace.zip"))
nwi_zip <- download_if_missing(massgis_nwi_url, file.path(external_dir, "nwi.zip"))

openspace_dir <- unzip_if_needed(openspace_zip, file.path(external_dir, "openspace"))
nwi_dir <- unzip_if_needed(nwi_zip, file.path(external_dir, "nwi"))

openspace_sf <- st_read(pick_shapefile(openspace_dir, "openspace_poly"), quiet = TRUE) |>
  st_make_valid() |>
  st_transform(26986) |>
  st_intersection(belmont_boundary)

nwi_sf <- st_read(pick_shapefile(nwi_dir, "nwi_poly\\.shp"), quiet = TRUE) |>
  st_make_valid() |>
  st_transform(26986) |>
  st_intersection(belmont_boundary)

controls_unique <- st_as_sf(
  tibble(case = rep(0, nrow(unique_locations))),
  geometry = st_sample(belmont_boundary, size = nrow(unique_locations), exact = TRUE),
  crs = st_crs(belmont_boundary)
)

controls_raw <- st_as_sf(
  tibble(case = rep(0, nrow(coyote_26986))),
  geometry = st_sample(belmont_boundary, size = nrow(coyote_26986), exact = TRUE),
  crs = st_crs(belmont_boundary)
)

raw_metrics <- point_pattern_metrics(coyote_26986, belmont_boundary, "raw_reports")
unique_metrics <- point_pattern_metrics(unique_locations, belmont_boundary, "unique_locations")
trimmed_metrics <- point_pattern_metrics(trimmed_points, belmont_boundary, "drop_top5_locations")

clustering_results <- bind_rows(raw_metrics, unique_metrics, trimmed_metrics)

grid_250m <- st_make_grid(belmont_boundary, cellsize = 250, square = TRUE) |>
  st_as_sf() |>
  st_intersection(belmont_boundary) |>
  mutate(grid_id = row_number()) |>
  select(grid_id)

grid_counts <- grid_250m
grid_counts$raw_count <- lengths(st_intersects(grid_counts, coyote_26986))
grid_counts$unique_count <- lengths(st_intersects(grid_counts, unique_locations))

neighbors <- poly2nb(as_Spatial(grid_counts), queen = TRUE)
weights <- nb2listw(neighbors, style = "W", zero.policy = TRUE)
local_moran_raw <- localmoran(grid_counts$raw_count, weights, zero.policy = TRUE)

grid_counts <- grid_counts |>
  mutate(
    local_i = local_moran_raw[, "Ii"],
    local_z = local_moran_raw[, "Z.Ii"],
    local_p = local_moran_raw[, "Pr(z != E(Ii))"],
    hotspot = local_i > 0 & local_p < 0.05 & raw_count > 0
  )

distance_results <- bind_rows(
  distance_metrics(unique_locations, controls_unique, openspace_sf, "protected_or_recreational_open_space"),
  distance_metrics(unique_locations, controls_unique, nwi_sf, "wetlands")
)

feature_sf_obj <- st_sf(
  case = c(rep(1, nrow(unique_locations)), rep(0, nrow(controls_unique))),
  geometry = c(st_geometry(unique_locations), st_geometry(controls_unique)),
  crs = st_crs(unique_locations)
) |>
  st_transform(26986)

feature_geom <- st_geometry(feature_sf_obj)
feature_df <- st_drop_geometry(feature_sf_obj)

if (nrow(openspace_sf) > 0) {
  feature_df$d_open <- as.numeric(st_distance(feature_geom, st_union(st_geometry(openspace_sf))))
}
if (nrow(nwi_sf) > 0) {
  feature_df$d_wet <- as.numeric(st_distance(feature_geom, st_union(st_geometry(nwi_sf))))
}

predictor_map <- c(
  d_open = "protected_or_recreational_open_space",
  d_wet = "wetlands"
)
predictors <- intersect(names(feature_df), names(predictor_map))

glm_results <- tibble(feature = character(), glm_estimate = double(), glm_p_value = double())
if (length(predictors) > 0) {
  feature_df <- feature_df |>
    filter(if_all(all_of(predictors), ~ !is.na(.x)))
  glm_formula <- reformulate(sprintf("scale(log1p(%s))", predictors), response = "case")
  if (nrow(feature_df) > 0) {
    habitat_glm <- glm(glm_formula, data = feature_df, family = binomial())
    glm_results <- broom::tidy(habitat_glm) |>
      filter(term != "(Intercept)") |>
      mutate(
        feature = predictor_map[str_match(term, "d_[a-z]+")[, 1]]
      ) |>
      transmute(feature, glm_estimate = estimate, glm_p_value = p.value)
  }
}

distance_results <- left_join(distance_results, glm_results, by = "feature")

reporting_bias_diagnostics <- bind_rows(
  tibble(metric = "raw_reports", value = nrow(coyote_26986)),
  tibble(metric = "unique_exact_locations", value = nrow(unique_locations)),
  tibble(metric = "nonblank_reporting_addresses", value = sum(!is.na(coyote_26986$reporting_address))),
  coyote_26986 |>
    st_drop_geometry() |>
    count(coord_key, sort = TRUE) |>
    summarise(metric = "share_reports_on_repeated_exact_coordinates", value = sum(n[n > 1]) / nrow(coyote_26986)),
  coyote_26986 |>
    st_drop_geometry() |>
    filter(!is.na(reporting_address)) |>
    count(reporting_address, sort = TRUE) |>
    summarise(metric = "share_reports_from_repeated_addresses", value = sum(n[n > 1]) / sum(n)),
  coyote_26986 |>
    st_drop_geometry() |>
    count(coord_key, sort = TRUE) |>
    summarise(metric = "share_top1_exact_location", value = max(n) / nrow(coyote_26986)),
  coyote_26986 |>
    st_drop_geometry() |>
    count(coord_key, sort = TRUE) |>
    slice_head(n = 5) |>
    summarise(metric = "share_top5_exact_locations", value = sum(n) / nrow(coyote_26986)),
  coyote_26986 |>
    st_drop_geometry() |>
    filter(!is.na(reporting_address)) |>
    count(reporting_address, sort = TRUE) |>
    summarise(metric = "share_top1_reporting_address", value = max(n) / sum(n)),
  coyote_26986 |>
    st_drop_geometry() |>
    filter(!is.na(reporting_address)) |>
    count(reporting_address, sort = TRUE) |>
    slice_head(n = 5) |>
    summarise(metric = "share_top5_reporting_addresses", value = sum(n) / sum(coyote_26986 |> st_drop_geometry() |> filter(!is.na(reporting_address)) |> nrow())),
  coyote_26986 |>
    st_drop_geometry() |>
    filter(!is.na(reporting_address)) |>
    count(reporting_address, sort = TRUE) |>
    summarise(metric = "repeated_reporting_addresses", value = sum(n >= 2)),
  coyote_26986 |>
    st_drop_geometry() |>
    filter(!is.na(reporting_address), !is.na(date)) |>
    count(reporting_address, date, sort = TRUE) |>
    summarise(metric = "same_address_same_day_multi_reports", value = sum(n > 1)),
  coyote_26986 |>
    st_drop_geometry() |>
    filter(!is.na(reporting_address), !is.na(date)) |>
    mutate(week = format(date, "%G-W%V")) |>
    count(reporting_address, week, sort = TRUE) |>
    summarise(metric = "same_address_same_week_multi_reports", value = sum(n > 1)),
  coyote_26986 |>
    st_drop_geometry() |>
    filter(!is.na(reporting_address)) |>
    distinct(reporting_address, coord_key) |>
    count(reporting_address, sort = TRUE) |>
    summarise(metric = "repeated_addresses_multi_coordinate", value = sum(n > 1)),
  coyote_26986 |>
    st_drop_geometry() |>
    filter(!is.na(date)) |>
    count(coord_key, date, sort = TRUE) |>
    summarise(metric = "same_location_same_day_multi_reports", value = sum(n > 1)),
  coyote_26986 |>
    st_drop_geometry() |>
    filter(!is.na(year)) |>
    count(year, sort = FALSE) |>
    summarise(metric = "years_with_reports", value = n())
)

reports_by_year <- coyote_26986 |>
  st_drop_geometry() |>
  filter(!is.na(year)) |>
  count(year, sort = FALSE) |>
  mutate(share = n / sum(n))

temporal_concentration <- bind_rows(
  tibble(
    metric = "share_reports_2011_2012",
    value = reports_by_year |>
      filter(year %in% c(2011, 2012)) |>
      summarise(total = sum(share)) |>
      pull(total)
  ),
  tibble(
    metric = "max_single_year_share",
    value = max(reports_by_year$share)
  )
)

hotspot_sensitivity_results <- bind_rows(
  hotspot_sensitivity(belmont_boundary, coyote_26986) |> mutate(scenario = "raw_reports", .before = 1),
  hotspot_sensitivity(belmont_boundary, unique_locations) |> mutate(scenario = "unique_locations", .before = 1)
)

top_repeats <- coyote_26986 |>
  st_drop_geometry() |>
  count(reporting_address, coord_key, sort = TRUE) |>
  mutate(
    label = coalesce(reporting_address, coord_key)
  ) |>
  slice_head(n = 12)

repeat_points <- coyote_26986 |>
  st_drop_geometry() |>
  count(coord_key, reporting_address, x, y, sort = TRUE) |>
  filter(n > 1) |>
  st_as_sf(coords = c("x", "y"), crs = 26986)

coyote_geojson <- file.path(output_dir, "coyote_points_cleaned.geojson")
st_write(coyote_26986, coyote_geojson, delete_dsn = TRUE, quiet = TRUE)

write_csv(clustering_results, file.path(output_dir, "clustering_results.csv"))
write_csv(reporting_bias_diagnostics, file.path(output_dir, "reporting_bias_diagnostics.csv"))
write_csv(distance_results, file.path(output_dir, "ecological_context_results.csv"))
write_csv(reports_by_year, file.path(output_dir, "reports_by_year.csv"))
write_csv(temporal_concentration, file.path(output_dir, "temporal_concentration_results.csv"))
write_csv(hotspot_sensitivity_results, file.path(output_dir, "hotspot_sensitivity.csv"))

context_manifest <- tibble(
  layer_name = c(
    "Belmont coyote sightings",
    "Belmont town boundary",
    "MassGIS protected and recreational open space",
    "MassGIS National Wetlands Inventory"
  ),
  source_url = c(
    coyote_query_url,
    "https://www.census.gov/geographies/mapping-files/time-series/geo/tiger-line-file.html",
    massgis_openspace_url,
    massgis_nwi_url
  ),
  file_type = c("JSON via POST", "TIGER shapefile via tigris", "ZIP shapefile", "ZIP shapefile"),
  download_date = as.character(Sys.Date()),
  jurisdiction = c("Belmont, MA", "Belmont, MA", "Massachusetts", "Massachusetts"),
  crs = c("Viewer query returned EPSG:3857 geometry", st_crs(belmont_boundary)$input, st_crs(openspace_sf)$input, st_crs(nwi_sf)$input),
  relevant_fields = c(
    "Reporting Address; Date of Report; Time; date epoch; record_id; jump_id; geometry",
    "NAME; GEOID; geometry",
    paste(names(openspace_sf)[1:min(8, ncol(openspace_sf))], collapse = "; "),
    paste(names(nwi_sf)[1:min(8, ncol(nwi_sf))], collapse = "; ")
  ),
  limitations = c(
    "Public layer exposes location/time fields but no reporter identifier or notes; geometry is not directly downloadable from the viewer UI.",
    "Census boundary, not the Belmont parcel-maintained town outline.",
    "Open space is statewide and heterogeneous; not every habitat edge is protected land.",
    "Wetlands inventory is statewide and can overstate ecological salience for urban sightings."
  )
)

write_csv(context_manifest, file.path(output_dir, "context_layers_manifest.csv"))

data_inventory_lines <- c(
  "# Data Inventory",
  "",
  "## Belmont coyote layer",
  paste0("- Source URL: ", coyote_query_url),
  "- Access path: public PeopleGIS viewer login as `viewer`, then `identify_multi` polygon query on site layer `28433` / layer `5629`.",
  paste0("- Download date: ", Sys.Date()),
  "- Geometry note: the viewer config advertises EPSG:2249, but returned point WKT is clearly EPSG:3857-like Web Mercator coordinates.",
  paste0("- Record count recovered: ", nrow(coyote_26986)),
  paste0("- Fields recovered: ", paste(coyote_result$headers, collapse = "; "), "; record_id; jump_id; geometry"),
  "- Limitations: no reporter ID, no narrative notes, no direct public layer export.",
  "",
  "## Context layers",
  "- Belmont boundary from Census TIGER via `tigris::county_subdivisions()`.",
  paste0("- MassGIS open space ZIP: ", massgis_openspace_url),
  paste0("- MassGIS NWI ZIP: ", massgis_nwi_url),
  "- This first pass uses open space and wetlands as the main official habitat-context layers.",
  "",
  "## Reporting-bias feasibility",
  "- Direct reporter identifiers: not available in the public layer.",
  "- Indirect diagnostics available: exact coordinate repetition, repeated address counts, same-day repeat locations, raw-vs-unique-location clustering, and top-location removal robustness.",
  "",
  "## Time concentration",
  "- Reports are pooled across many years, so any full-period spatial test is partly a reporting-process test rather than a pure behavioral test.",
  "",
  "## Other-town sidecar feasibility",
  "- See `other_towns_catalog.csv` for the municipal dataset scout list."
)
writeLines(data_inventory_lines, file.path(output_dir, "data_inventory.md"))

repeat_summary_lines <- c(
  "# Figure Notes",
  "",
  "## Figure 1",
  "Raw Belmont coyote reports over Belmont boundary, open space, wetlands, and repeated exact locations.",
  "",
  "## Figure 2",
  "Kernel density surface for raw reports under one smoothing choice, shown with open-space and wetland context.",
  "",
  "## Figure 3",
  "Top repeated exact locations in the raw report set.",
  "",
  "## Figure 4",
  "Robustness of clustering after deduplication and after removing the five most repeated exact locations.",
  "",
  "## Figure 5",
  "Single 250-meter fishnet hotspot view based on local Moran's I of raw report counts; see `hotspot_sensitivity.csv` for scale dependence."
)
writeLines(repeat_summary_lines, file.path(output_dir, "figure_notes.md"))

base_map <- ggplot() +
  geom_sf(data = belmont_boundary, fill = "grey98", color = "grey35", linewidth = 0.4) +
  geom_sf(data = openspace_sf, fill = "#cfe8c8", color = NA, alpha = 0.7) +
  geom_sf(data = nwi_sf, fill = "#b8d8ef", color = NA, alpha = 0.45) +
  geom_sf(data = coyote_26986, color = "#b03a2e", alpha = 0.65, size = 1.2) +
  geom_sf(data = repeat_points, aes(size = n), color = "#7f0000", alpha = 0.9) +
  scale_size_continuous(range = c(2.5, 7), name = "Repeated reports\nat exact point") +
  coord_sf(expand = FALSE) +
  labs(
    title = "Reported coyote sightings concentrate in a few recurring places",
    subtitle = "This is a report-concentration map, not a direct habitat map",
    caption = "Sources: Belmont PeopleGIS public viewer, MassGIS, TIGER/Line."
  ) +
  theme_minimal(base_size = 12) +
  theme(
    panel.grid.major = element_line(color = "grey92", linewidth = 0.2),
    legend.position = "right"
  )

ggsave(file.path(output_dir, "figure01_points_context.png"), base_map, width = 10, height = 8, dpi = 220)

pp_raw <- ppp(
  x = coyote_26986$x,
  y = coyote_26986$y,
  window = as.owin(st_geometry(belmont_boundary)),
  checkdup = FALSE
)
bw <- bw.diggle(pp_raw)
dens <- density.ppp(pp_raw, sigma = bw, at = "pixels")
dens_df <- as.data.frame(dens)

kde_map <- ggplot() +
  geom_raster(data = dens_df, aes(x = x, y = y, fill = value), alpha = 0.9) +
  scale_fill_viridis_c(option = "magma", name = "KDE intensity") +
  geom_sf(data = st_boundary(belmont_boundary), fill = NA, color = "grey15", linewidth = 0.4) +
  geom_sf(data = openspace_sf, fill = NA, color = "#2f6f3e", linewidth = 0.3, alpha = 0.5) +
  labs(
    title = "Kernel density of reported sightings under one smoothing choice",
    subtitle = paste0("Bandwidth selected by Diggle's method: ", round(as.numeric(bw), 1), " meters"),
    x = NULL,
    y = NULL
  ) +
  coord_sf(
    xlim = st_bbox(belmont_boundary)[c("xmin", "xmax")],
    ylim = st_bbox(belmont_boundary)[c("ymin", "ymax")],
    expand = FALSE
  ) +
  theme_minimal(base_size = 12)

ggsave(file.path(output_dir, "figure02_kde_context.png"), kde_map, width = 10, height = 8, dpi = 220)

robustness_plot_df <- clustering_results |>
  select(scenario, nearest_neighbor_ratio, max_l_minus_r)

repeat_bar <- ggplot(top_repeats, aes(x = reorder(label, n), y = n)) +
  geom_col(fill = "#7f0000") +
  coord_flip() +
  labs(
    title = "A small set of exact locations account for a large share of reports",
    x = NULL,
    y = "Number of reports"
  ) +
  theme_minimal(base_size = 11)

robustness_plot <- ggplot(robustness_plot_df, aes(x = scenario, y = nearest_neighbor_ratio, group = 1)) +
  geom_line(color = "#1b4d3e", linewidth = 1) +
  geom_point(color = "#1b4d3e", size = 3) +
  geom_hline(yintercept = 1, linetype = "dashed", color = "grey50") +
  labs(
    title = "Report concentration weakens after deduplication, but remains non-uniform",
    x = NULL,
    y = "Nearest-neighbor ratio"
  ) +
  theme_minimal(base_size = 11)

ggsave(file.path(output_dir, "figure03_repeat_locations.png"), repeat_bar, width = 8, height = 6, dpi = 220)
ggsave(file.path(output_dir, "figure04_clustering_robustness.png"), robustness_plot, width = 8, height = 5, dpi = 220)

hotspot_map <- ggplot() +
  geom_sf(data = grid_counts, aes(fill = hotspot), color = NA, alpha = 0.75) +
  scale_fill_manual(values = c(`TRUE` = "#d94841", `FALSE` = "#f0f0f0"), guide = "none") +
  geom_sf(data = st_boundary(belmont_boundary), fill = NA, color = "grey20", linewidth = 0.4) +
  geom_sf(data = openspace_sf, fill = NA, color = "#2f6f3e", linewidth = 0.25, alpha = 0.5) +
  geom_sf(data = coyote_26986, color = "black", alpha = 0.35, size = 0.6) +
  labs(
    title = "One 250-meter descriptive hotspot view of reported-sighting concentration",
    subtitle = "Local-Moran hotspots are descriptive and scale-sensitive rather than decisive"
  ) +
  coord_sf(expand = FALSE) +
  theme_minimal(base_size = 12)

ggsave(file.path(output_dir, "figure05_grid_hotspots.png"), hotspot_map, width = 10, height = 8, dpi = 220)

results_lines <- c(
  "# Results Memo",
  "",
  "## Bottom line",
  "Belmont's coyote reports are not spatially random, but the strongest clustering signal weakens materially when the analysis collapses exact duplicate coordinates and removes the most repeated locations.",
  "That pattern is most consistent with non-uniform report concentration that is sharpened by repeated reporting from recurring places, with only limited first-pass support for a stronger habitat explanation from the official context layers used here.",
  "",
  "## Key empirical findings",
  paste0("- Raw reports recovered: ", nrow(coyote_26986), "."),
  paste0("- Unique exact locations: ", nrow(unique_locations), "."),
  paste0("- Share of all reports on exact coordinates that repeat: ", scales::percent(reporting_bias_diagnostics$value[reporting_bias_diagnostics$metric == 'share_reports_on_repeated_exact_coordinates'], accuracy = 0.1), "."),
  paste0("- Share of nonblank-address reports from addresses that repeat: ", scales::percent(reporting_bias_diagnostics$value[reporting_bias_diagnostics$metric == 'share_reports_from_repeated_addresses'], accuracy = 0.1), "."),
  paste0("- Share of all reports from the single most repeated exact location: ", scales::percent(reporting_bias_diagnostics$value[reporting_bias_diagnostics$metric == 'share_top1_exact_location'], accuracy = 0.1), "."),
  paste0("- Share of all reports from the five most repeated exact locations: ", scales::percent(reporting_bias_diagnostics$value[reporting_bias_diagnostics$metric == 'share_top5_exact_locations'], accuracy = 0.1), "."),
  paste0("- Simulation-based nearest-neighbor ratio, raw reports: ", round(raw_metrics$nearest_neighbor_ratio, 3), " (Monte Carlo p=", signif(raw_metrics$nearest_neighbor_p_value, 3), ")."),
  paste0("- Simulation-based nearest-neighbor ratio, unique locations: ", round(unique_metrics$nearest_neighbor_ratio, 3), " (Monte Carlo p=", signif(unique_metrics$nearest_neighbor_p_value, 3), ")."),
  paste0("- Quadrat test p-value, raw reports: ", signif(raw_metrics$quadrat_p_value, 3), "."),
  paste0("- Quadrat test p-value, unique locations: ", signif(unique_metrics$quadrat_p_value, 3), "."),
  paste0("- Median distance from unique sighting locations to open space: ", round(distance_results$point_median_m[distance_results$feature == "protected_or_recreational_open_space"]), " m, versus ", round(distance_results$control_median_m[distance_results$feature == "protected_or_recreational_open_space"]), " m for random points."),
  paste0("- Median distance from unique sighting locations to wetlands: ", round(distance_results$point_median_m[distance_results$feature == "wetlands"]), " m, versus ", round(distance_results$control_median_m[distance_results$feature == "wetlands"]), " m for random points."),
  paste0("- Share of dated reports from 2011-2012: ", scales::percent(temporal_concentration$value[temporal_concentration$metric == "share_reports_2011_2012"], accuracy = 0.1), "."),
  paste0("- Raw hotspot cells across scale choices: ", paste(hotspot_sensitivity_results$hotspot_cells[hotspot_sensitivity_results$scenario == "raw_reports"], collapse = ", "), " at 150 m, 250 m, 400 m, and 600 m grids."),
  "",
  "## Interpretation",
  "The coyote map contains many repeated exact points and repeated addresses, which is what you would expect if some residents or households reported multiple sightings over time from the same vantage points.",
  "Even after deduplication, the remaining unique locations are still less uniform than a complete-spatial-random benchmark inside Belmont, but that benchmark should be read as a report-process check rather than as a direct ecological null.",
  "That means the surviving concentration is not only a one-household artifact, but it also cannot be cleanly separated from broader reporting opportunity with the current design.",
  "",
  "## Ecological-context read",
  "The first-pass official context layers do not provide strong support for a simple habitat story. Unique sighting locations are not closer to wetlands than random Belmont points, and in this specification they are farther from mapped open space on average.",
  "Because the controls are sampled uniformly from all of Belmont rather than from observer-accessible places, these habitat diagnostics should themselves be treated cautiously.",
  "That means the visual western-side pattern in the maps should be treated as suggestive rather than confirmed by the distance diagnostics.",
  "Some repeated hotspots also sit on ordinary residential streets rather than inside habitat polygons, which points back toward observer concentration and repeated report origins.",
  "",
  "## Reporting-bias read",
  "The data do not identify reporters, so the analysis cannot prove a literal super-caller.",
  "What it can show is that repeated reporting from recurring locations is real, even if the concentration is not extreme enough to support a dramatic single-reporter story.",
  "The stronger duplicate question also does not end with exact-point deduplication alone; repeated addresses and repeated address-week combinations still matter.",
  "Taken together with the weak first-pass habitat diagnostics, that makes any raw heatmap interpretation too strong unless it is paired with unique-location and top-location-removed checks."
)
writeLines(results_lines, file.path(output_dir, "results_memo.md"))

methods_lines <- c(
  "# Methods Memo",
  "",
  "## Feasibility summary",
  "Belmont's coyote layer is publicly queryable through the PeopleGIS viewer even though one-click data export is disabled.",
  "The public query returns address, date, time, internal record IDs, and geometry, but not reporter identifiers or narrative notes.",
  "",
  "## Data pipeline",
  paste0("Randomized procedures are seeded with `set.seed(20260408)` for reproducibility."),
  "1. Logged into Belmont's public PeopleGIS backend as the viewer account used by the web app.",
  "2. Queried the coyote site layer with a polygon covering Belmont's full town extent.",
  "3. Parsed the returned JSON into a cleaned sf point layer.",
  "4. Added Belmont boundary from Census TIGER county subdivisions.",
  "5. Added open space and wetlands from MassGIS statewide downloads, then clipped to Belmont.",
  "6. Added official habitat-like context from MassGIS open space and wetlands.",
  "",
  "## Spatial-statistics toolkit",
  "- Simulation-based nearest-neighbor ratio against complete spatial randomness for raw reports, unique exact locations, and a top-repeat-removed robustness variant.",
  "- Quadrat test on a 4x4 fishnet within Belmont.",
  "- Ripley's L envelopes against CSR.",
  "- Kernel density estimation with Diggle bandwidth selection.",
  "- Local Moran's I on a Belmont-clipped 250-meter count grid, with separate hotspot-sensitivity output across multiple cell sizes.",
  "",
  "## Reporting-bias diagnostics",
  "- Exact coordinate repetition.",
  "- Repeated reporting-address counts.",
  "- Same-location same-day multiplicity.",
  "- Same-address same-day and same-week multiplicity.",
  "- Repeated addresses that map to more than one coordinate.",
  "- Comparison of raw, unique-location, and top-location-removed clustering metrics.",
  "",
  "## Ecological-context diagnostics",
  "- Distance-to-open-space and wetlands comparisons against random points within Belmont.",
  "- Logistic model distinguishing unique sighting locations from random controls using log-distance predictors.",
  "- Ecological-context summary table saved to `ecological_context_results.csv`.",
  "- Temporal concentration summary saved to `temporal_concentration_results.csv`.",
  "- Hotspot scale-sensitivity summary saved to `hotspot_sensitivity.csv`.",
  "",
  "## Important limitations",
  "- Opportunistic sightings are not a census of coyotes.",
  "- Full-period CSR benchmarks are tests of report concentration, not clean tests of coyote behavior.",
  "- The ecological controls are not observer-exposure aware, so they cannot cleanly validate or reject habitat stories.",
  "- KDE and hotspot surfaces are descriptive and scale-sensitive.",
  "- Reporter IDs and narrative notes are absent from the public layer.",
  "- Viewer-returned geometry CRS needed to be inferred from coordinate values rather than trusted directly from the viewer metadata."
)
writeLines(methods_lines, file.path(output_dir, "methods_memo.md"))

blog_lines <- c(
  "# Do Belmont's coyote clusters show where coyotes are, or where people report them?",
  "",
  "Belmont's coyote map looks dramatic at first glance. The points are not sprinkled evenly across town. They bunch up in a few pockets, especially on the western side near Belmont's open-space edge. That visual pattern invites an easy conclusion: coyotes must really concentrate there.",
  "",
  "But opportunistic sighting data are treacherous. A cluster of reports can mean a cluster of animals, a cluster of observers, or a cluster of repeat reports from a small number of homes that happen to have a good view of the same corridor. The Belmont data are unusually useful because the public map is queryable enough to recover point locations, dates, times, and reporting addresses, which lets us test the super-caller idea instead of just gesturing at it.",
  "",
  "## What data are actually available?",
  "",
  "Belmont's public PeopleGIS viewer includes a `Coyote Sightings` layer. The town does not expose it as a public one-click download, but the web app's own query endpoint returns a structured record set. The public payload includes a reporting address field, a report date, a time string, internal record identifiers, and a point geometry. It does not include reporter IDs or narrative notes. That matters. We can evaluate repeated locations and repeated addresses, but we cannot prove that one named person filed many reports.",
  "",
  "To put the points in context, I clipped Belmont against official supporting layers: Census TIGER town geography, MassGIS protected and recreational open space, and MassGIS wetlands.",
  "",
  "## First question: are the sightings genuinely clustered?",
  "",
  "Yes, in the limited sense that the reports are not uniformly distributed across Belmont. Multiple tests reject complete spatial randomness in the raw reports. The nearest-neighbor ratio is below 1, the quadrat test rejects uniformity, and Ripley's L exceeds the CSR envelope in the tested distance range. But those are benchmarks against uniform report placement, not proof that the underlying coyote population follows the same pattern.",
  "",
  "But the stronger finding is what happens when we stop treating every report as independent. A large share of the raw pattern comes from a small number of exact point locations. When the analysis collapses repeated exact coordinates down to unique locations, clustering weakens noticeably. The pattern also remains clustered after removing the five most repeated locations, although the strength of that change depends on which metric you watch.",
  "",
  "There is also a time-concentration problem built into the dataset. The public records span more than two decades, and about 46 percent of the dated reports fall in 2011 and 2012 alone. Any all-years map is therefore pooling together different reporting eras as well as different parts of town.",
  "",
  "That is the core empirical result. Belmont's coyote reports are spatially concentrated, but part of that concentration is being amplified by repeated reporting from the same mapped places.",
  "",
  "## Where are the strongest clusters?",
  "",
  "In the maps, one visible emphasis appears along Belmont's western side, where residential streets approach Rock Meadow, conservation land, and the town's greener edge. But the maps also show central activity, and the hotspot footprint changes noticeably with grid size. So the west-side story is best treated as a visual clue, not a settled locational result.",
  "",
  "Still, some of the biggest raw hotspots are not broad habitat zones. They are exact points on ordinary residential streets. That is what pulls the interpretation away from a simple habitat story. If a hotspot collapses when a few repeated coordinates are removed, then the hotspot was partly a reporting pattern, not just an animal pattern.",
  "",
  "## Habitat use or reporting bias?",
  "",
  "The cleanest answer is: a mixture, with the reporting-bias evidence stronger than the habitat-context evidence in this first pass.",
  "",
  "When unique sighting locations are compared to random points inside Belmont, the first-pass context diagnostics do not line up cleanly with a simple habitat story. The wetland comparison is weak, and the open-space comparison actually runs against the idea that reports are concentrated right next to mapped open space. That does not eliminate the possibility of greener-edge movement corridors, but it means the official context layers here do not strongly validate the visual habitat interpretation.",
  "",
  "At the same time, the raw data are too concentrated at repeated origins to read as a direct map of coyote habitat. About 22.8 percent of all reports fall on exact coordinates that repeat, and 27.0 percent of the nonblank-address reports come from addresses that repeat. Some apparent hotspots are therefore better understood as places where people repeatedly notice and report coyotes rather than as places that uniquely indicate coyote habitat.",
  "",
  "## What about the super-caller hypothesis?",
  "",
  "The public data do not identify reporters, so they cannot prove that one household or one especially diligent resident generated a large fraction of the map. That stronger claim would require reporter IDs or narrative notes.",
  "",
  "But the data do support a weaker and more defensible statement: the raw clustering pattern is consistent with observer concentration. A small number of exact locations account for a noticeable share of reports, repeated addresses and address-week combinations recur, and the overall clustering signal gets weaker when those locations are collapsed or removed. That is harder to square with a story in which the map is simply a transparent footprint of where coyotes live.",
  "",
  "So the best bottom-line judgment is not 'Belmont's coyote map is fake,' and it is not 'the hotspots show where coyotes truly are.' It is that the map mixes non-uniform report concentration with a reporting overlay that the current design cannot fully separate from any underlying animal pattern. A western-edge story remains plausible from some of the maps, but the first-pass official context layers do not strongly validate it, the hotspot footprint shifts with scale, and the raw point pile-up overstates how sharp the concentration is.",
  "",
  "## Why this matters",
  "",
  "This is exactly why public wildlife maps are analytically interesting. A heatmap alone would have encouraged overconfidence. Once you ask how many reports come from the same point, and whether the pattern survives deduplication, the story gets subtler and better.",
  "",
  "Belmont's coyote sightings are informative, but only if you treat them as reports, not direct telemetry. The serious reading is that Belmont shows non-uniform report concentration, and the sharpest hotspots in the raw map are partly a function of who is watching, where they are watching from, and how often those same places generate another report.",
  "",
  "## Side quest: weird Massachusetts municipal GIS",
  "",
  "This project also turned up a compact catalog of other Massachusetts municipal GIS layers that could support similar sidecar stories. Tree inventories, wildlife reports, and detailed infrastructure layers are especially promising because they pair unusual local detail with enough structure to analyze seriously.",
  "",
  "## Limitations",
  "",
  "This analysis uses opportunistic sighting reports rather than a controlled survey or animal-tracking data.",
  "The records are pooled across more than two decades, so spatial concentration and temporal concentration are partly entangled.",
  "Reporter IDs and narrative notes are absent from the public coyote layer, so super-caller inference is necessarily indirect.",
  "The geometry returned by the public viewer required CRS validation because the coordinate values did not match the layer metadata advertised by the map interface.",
  "Hotspot and KDE maps are descriptive and scale-sensitive, not definitive evidence about where coyotes concentrate.",
  "And proximity to open space or wetlands is only suggestive. It is evidence of spatial alignment, not proof of habitat preference in a biological sense.",
  "",
  "## The real takeaway",
  "",
  "Belmont's public coyote reports are clearly non-uniform, but that is not the same thing as a clean behavioral map of coyotes. The safest reading is a mixture of non-uniform report concentration, repeat observations from recurring locations, and only limited first-pass support for a stronger habitat story. If you want to learn from a municipal sighting map without fooling yourself, this is the kind of mixed conclusion that is worth reaching."
)
writeLines(blog_lines, file.path(output_dir, "blog_post_draft.md"))
