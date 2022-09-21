################################################################################
# Libraries required for the app                                               #
# @author Johnson Zhou zhoujj@student.unimelb.edu.au                           #
################################################################################

#' Dependencies used in the app
dependencies <- c(
  "shiny",
  "dplyr",
  "janitor",
  "tidyr",
  "tidyselect",
  "readxl",
  "ggplot2",
  "plotly",
  "leaflet",
  "geojsonio",
  "sp",
  "glue",
  "colorspace",
  "htmltools"
)

#' Attempts to load packages and install them if required
#' @param dependencies - a vector of dependency names
load_dependencies <- function(dependencies) {
  print(dependencies)
  for (package in dependencies) {
    tryCatch({
      library(package, character.only = TRUE)
    }, error = function(e) {
      install.packages(package, repos = "https://cloud.r-project.org")
      library(package, character.only = TRUE)
    })
  }
}

load_dependencies(dependencies)
