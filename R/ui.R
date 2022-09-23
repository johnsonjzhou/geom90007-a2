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
  # web fonts
  tags$link(
    rel = "stylesheet", type = "text/css",
    href = "https://fonts.googleapis.com/css2?family=Inter"
  ),
  tags$link(
    rel = "stylesheet", type = "text/css",
    href = "https://fonts.googleapis.com/css2?family=League+Spartan"
  ),
  # css overrides
  tags$link(
    rel = "stylesheet", type = "text/css",
    href = "shiny_app.css"
  ),
  # javascript
  tags$script(
    src = "shiny_app.js"
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

map_controls <- wellPanel(
  id = "leaflet_map_panel",
  h1("Title"),
  plotlyOutput(
    outputId = "yearly_total_plot",
    width = "100%",
    height = "80px"
  ),
  sliderInput(
    inputId = "map_year_slider",
    label = "Year",
    value = 2001,
    min = 2001,
    max = 2020,
    step = 1,
    ticks = TRUE,
    width = "100%",
    sep = ""
  ),
  selectInput(
    inputId = "map_context_selector",
    label = "Context",
    choices = list("Stunting", "Overweight"),
    selected = "Stunting",
    multiple = FALSE,
    selectize = FALSE
  )
)

map_panel <- tabPanel(
  title = "Map",
  leafletOutput(
    "leaflet_map",
    height = "100%", width = "100%"
  ),
  map_controls,
  icon = d_icon("map")
)

# Navigation bar---------------------------------------------------------------

nav_menu <- navbarMenu(
  info_panel,
  map_panel
)

title_panel <- tabPanel(
  title = "Title",
  h1("Nutrition and Food Security around the world"),
  actionButton(
    inputId = "title_about",
    label = "Learn"
  )
)

# UI element-------------------------------------------------------------------

ui <- navbarPage(
  title = "Nutrition and Food Security around the world",
  map_panel,
  title_panel,
  info_panel,
  header = headers,
  windowTitle = "Nutrition and Food Security around the world",
  fluid = FALSE,
  position = "fixed-top",
  lang = "en"
)
