################################################################################
# Data provider for the app                                                    #
# @author Johnson Zhou zhoujj@student.unimelb.edu.au                           #
################################################################################
library(dplyr)
library(tidyr)
library(janitor)

#' Load data from either excel file or csv
#' @param filename the filename for the file to be loaded
#' @param type EXCEL or CSV
#' @param ... additional parameters to pass to read.csv or readxl::read_excel
#' @return dataframe
data_loader <- function(filename, type = "EXCEL", ...) {
  df <- switch(
    type,
    "CSV" = read.csv(filename, ...),
    "EXCEL" = readxl::read_excel(filename, ...)
  )
  return(df)
}

#' Load and provide malnutrition data from the SOFI dataset
#' @param context Stunting or Overweight
#' @return dataframe
malnutrition_data <- function(context) {
  # Match context to sheet name in the excel file
  sheet <- switch(
    context,
    "Stunting" = "Stunting Proportion (Model)",
    "Overweight" = "Overweight Proportion (Model)"
  )

  # Load the data from excel file
  df <- data_loader("./data/malnutrition.xlsx", type = "EXCEL", sheet = sheet)

  # Clean and tidy the data
  df_tidy <- df %>%
  clean_names() %>%
  rename(., "x2020" = "x2020_1") %>%
  filter(
    .$x2020 != "-",
    .$estimate == "Point Estimate"
  ) %>%
  mutate(across("x2000":"x2020", as.numeric))

  return(df_tidy)
}

#' Load the world map spacial data from a geojson file
world_geojson <- geojsonio::geojson_read(
  "./data/countries.geo.json",
  what = "sp"
)

#' Generates map data by merging spatial polygons with data
#' @param context Stunting or Overweight
#' @return a dataframe with spatial information
map_data <- function(context) {
  spatial_df <- sp::merge(
    world_geojson, malnutrition_data(context),
    by.x = "id", by.y = "iso_code"
  )
  return(spatial_df)
}
