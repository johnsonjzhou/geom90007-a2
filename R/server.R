################################################################################
# Server components for the dashboard                                          #
# @author Johnson Zhou zhoujj@student.unimelb.edu.au                           #
################################################################################
library(dplyr)
library(shiny)
library(leaflet)
library(plotly)

#' The server function to pass to the shiny dashboard
server <- function(input, output, session) {
  #' Event handlers ----------------------------------------------------------

  # About page revealer
  observeEvent(input$about_open, {
    session$sendCustomMessage(type = "about_open", message = "open")
  })

  observeEvent(input$about_close, {
    session$sendCustomMessage(type = "about_close", message = "close")
  })

  #' State -------------------------------------------------------------------

  #' Reactive states
  state <- reactiveValues()
  state$ui_colors <- list(
    "background" = "#f5f3ec",
    "gray" = "#e7e5e6",
    "darkgray" = "#79757d",
    "foreground" = "#1a1b19"
  )
  state$fonts <- list(
    "primary" = "'League Spartan', 'Helvetica', 'Arial', sans-serif",
    "secondary" = "'Inter', 'Helvetica', 'Arial', sans-serif",
    "monospace" = "'JetBrains Mono', monospace"
  )
  state$map_context <- "Stunting"
  state$map_colors <- list(
    "Overweight" = "#e28a2e",
    "Stunting" = "#65acab"
  )
  state$context_color <- "#65acab"
  state$year <- "2001"

  #' Observe states
  observe({
    state$year <- input$map_year_slider
    state$map_context <- input$map_context_selector
    state$context_color <- state$map_colors[state$map_context]
  })

  #' Mapping -----------------------------------------------------------------

  #' Filter map data based on context
  map_data_filter <- reactive({
    spatial_df <- map_data(state$map_context)
    return(spatial_df)
  })

  #' Render the world map in a leaflet widget
  output$leaflet_map <- renderLeaflet(
    map_renderer(map_data_filter(), state)
  )
  
  #' Render a plot of yearly totals
  output$yearly_total_plot <- renderPlotly(
    yearly_total_plot(map_data_filter(), state)
  )
}