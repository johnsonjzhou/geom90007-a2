################################################################################
# UI components for the dashboard                                              #
# @author Johnson Zhou zhoujj@student.unimelb.edu.au                           #
################################################################################
library(shiny)

# Utilities--------------------------------------------------------------------

#' Renders an icon for the shiny dashboard
#' @param name name of the font-awesome icon
#' @return a shiny::icon object
d_icon <- function(name) {
  return(icon(name = name, lib = "font-awesome"))
}

# Header elements--------------------------------------------------------------

headers <- tags$head(
  # css overrides
  tags$link(
    rel = "stylesheet", type = "text/css",
    href = "shiny.css"
  )
)

# Info Panel-------------------------------------------------------------------

info_panel <- tabPanel(
  title = "Info",
  h1("Food security and nutrition around the world"),
  p("Lorem ipsum dolor sit amet, consectetur adipiscing elit."),
  icon = d_icon("circle-info")
)

# Map Panel---------------------------------------------------------------------

map_panel <- tabPanel(
  title = "Map",
  leafletOutput(
    "leaflet_map",
    height = "100vh", width = "100vw"
  ),
  icon = d_icon("map")
)

# Navigation bar---------------------------------------------------------------

nav_menu <- navbarMenu(
  info_panel,
  map_panel
)

# UI element-------------------------------------------------------------------

ui <- navbarPage(
  title = "Food security and nutrition around the world",
  info_panel,
  map_panel,
  header = headers,
  windowTitle = "Food security and nutrition around the world",
  fluid = FALSE,
  position = "fixed-top",
  lang = "en"
)
