################################################################################
# Data provider for the app                                                    #
# @author Johnson Zhou zhoujj@student.unimelb.edu.au                           #
################################################################################
library(dplyr)
library(tidyr)
library(janitor)
library(tidyselect)
library(rworldmap)

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

#' Tidy the dataframe to a standard format
#' @param df the dataframe to tidy, loaded from data_loader
#' @return dataframe
data_tidy <- function(df) {
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

#' Load and provide malnutrition data from the SOFI dataset
#' @param context Stunting or Overweight
#' @return dataframe
#' @example x{year} numbers affected
#' @example prop_{year} proportion affected
#' @example total_{year} total of numbers affected
#' @example norm_{year} normalised to total numbers affected
#' @example diff_{year} difference numbers affected from year before
malnutrition_data <- function(context) {
  # Match context to sheet name in the excel file
  # Numbers affected (base)
  sheet <- switch(
    context,
    "Stunting" = "Stunting Numb Affected(Model)",
    "Overweight" = "Overweight Numb Affected(Model)"
  )

  # Proportion by country
  sheet_prop <- switch(
    context,
    "Stunting" = "Stunting Proportion (Model)",
    "Overweight" = "Overweight Proportion (Model)"
  )

  # Load base data
  df <- data_tidy(data_loader(
    "./data/malnutrition.xlsx", type = "EXCEL", sheet = sheet
  ))

  # Load proportion data
  df_prop <- data_tidy(data_loader(
    "./data/malnutrition.xlsx", type = "EXCEL", sheet = sheet_prop
  )) %>%
    select(
      "iso_code",
      num_range("x", 2001:2020)
    ) %>%
    rename_with(
      ~ gsub("x", "prop_", .),
      num_range("x", 2001:2020)
    )

  # Add proportion and insights
  df_insights <- df %>%
    # Join with proportion data
    # prop_{year}
    inner_join(
      df_prop,
      by = c("iso_code" = "iso_code")
    ) %>%
    # Totals of all countries per year
    # total_{year}
    mutate(
      across(
        num_range("x", 2001:2020),
        ~ sum(.x, na.rm = TRUE),
        .names = "{gsub('x', 'total_', .col)}"
      )
    ) %>%
    # Affected in each country normalised
    # norm_{year}
    mutate(
      across(
        num_range("x", 2001:2020),
        ~ .x / max(.x) * 100,
        .names = "{gsub('x', 'norm_', .col)}"
      )
    ) %>%
    # Difference in affected versus previous year
    # diff_{year}
    mutate(
      across(
        num_range("x", 2001:2020),
        # eg. x2001 - x2000
        ~ .x - get(paste0("x", strtoi(substr(cur_column(), 2, 5)) - 1)),
        .names = "{gsub('x', 'diff_', .col)}"
      )
    )

  return(df_insights)
}

#' Generates map data by merging spatial polygons with data
#' @param context Stunting or Overweight
#' @return a dataframe with spatial information
map_data <- function(context) {
  # Import world map
  world_map <- rworldmap::getMap()
  # Add data
  spatial_df <- sp::merge(
    world_map, malnutrition_data(context),
    by.x = "ISO_A3", by.y = "iso_code"
  )
  return(spatial_df)
}
