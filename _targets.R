#
library(targets)
library(tarchetypes) 

# Set target options:
tar_option_set(
  packages = c("tibble", "sf", "tidyverse")
)

# Run the R scripts in the R/ folder with your custom functions:
tar_source("src/fire_area.R")
tar_source("src/overlap_difference.R")
tar_source("src/overlap_intersection.R")
tar_source("src/processing_tools.R")

# directories
fire_path <- "/Users/jgoldman/Library/CloudStorage/OneDrive-UniversityofToronto/Data/quebec-disturbance-data/qc-fire-perims-shield-2.shp"
defol_path <- "/Users/jgoldman/Library/CloudStorage/OneDrive-UniversityofToronto/Data/qc-data/clean-data/qc_sbw.shp"
RES_DIR <- "/Users/jgoldman/Library/CloudStorage/OneDrive-UniversityofToronto/Data/qc-data/clean-data/"

# Replace the target list below with your own:
list(
  tar_target(name = fire.file, fire_path, format = "file"),
  tar_target(name = fire.data, getData(fire.file)),
  tar_target(name = defol.file, defol_path, format = "file"),
  tar_target(name = defol.data, getData(defol.file)),
  tar_target(intersection, overlap_intersection(fire.data, defol.data, 2012, 1970, 15)),
  tar_target(difference, overlap_difference(fire.data, intersection)),
  tar_target(data.int.v1, fire_area(intersection)),
  tar_target(data.diff.v1, fire_area(difference)),
  tar_target(data.list , clean_overlap(data.int.v1, data.diff.v1)),
  tar_map(values = tibble::tribble(
    ~df.name,  
    "data.d",  
    "data.nd"  
  ) |> tidyr::expand(df.name),
  tar_target(data.output, output_data(data.list, df.name, RES_DIR))
  )
)
