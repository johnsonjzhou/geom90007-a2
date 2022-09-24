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
    href = paste0(
      "https://fonts.googleapis.com/css2?",
      "family=Inter:wght@400;500;600",
      "&family=JetBrains+Mono:ital,wght@0,400;0,500;0,600;1,400;1,500;1,600",
      "&family=League+Spartan:wght@500;600",
      "&display=swap"
    )
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

# Title Panel------------------------------------------------------------------

title_panel <- tabPanel(
  title = "Title",
  h1("Nutrition and Food Security around the world"),
  fluidRow(
    id = "title_controls",
    column(
      width = 1,
      actionButton(
        inputId = "about_open",
        label = "About"
      )
    ),
    column(
      width = 3,
      selectInput(
        inputId = "map_context_selector",
        label = "Burden",
        choices = list("Stunting", "Overweight"),
        selected = "Stunting",
        multiple = FALSE,
        selectize = FALSE
      )
    )
  )
)

dimmer_panel <- tabPanel(
  title = "Dimmer"
)

# Info Panel-------------------------------------------------------------------

info_panel <- tabPanel(
  title = "About",
  actionButton(
    inputId = "about_close",
    label = "Close"
  ),
  h1("Nutrition and Food Security around the world"),
  p("Lorem ipsum dolor sit amet, consectetur adipiscing elit."),
  icon = d_icon("circle-info")
)

# Map Panel---------------------------------------------------------------------

map_controls <- fluidRow(
  id = "leaflet_map_panel",
  column(
    id = "map_year_combo",
    width = 12,
    plotlyOutput(
      outputId = "yearly_total_plot",
      width = "550px",
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

# UI element-------------------------------------------------------------------

ui <- navbarPage(
  title = "Nutrition and Food Security around the world",
  map_panel,
  title_panel,
  dimmer_panel,
  info_panel,
  header = headers,
  windowTitle = "Nutrition and Food Security around the world",
  fluid = FALSE,
  position = "fixed-top",
  lang = "en"
)
