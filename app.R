################################################################################
# GEOM90007 Assignment 2                                                       #
# Semester 2, 2022                                                             #
# @author Johnson Zhou zhoujj@student.unimelb.edu.au                           #
################################################################################
source("./src/libraries.R")

app <- c(
  #' dependencies required in the app
  dependencies = c(
    "shiny",
    "dplyr",
    "readxl",
    "ggplot2",
    "plotly",
    "leaflet",
    "glue"
  ),
  load_dependencies = load_dependencies
  #' data
  #' ui
  #' server
)

class(app) <- "App"


app$load_dependencies(app$dependencies)
