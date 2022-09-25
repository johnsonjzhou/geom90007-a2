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

  #' Observe map clicks and reveal Details page
  observeEvent(input$leaflet_map_shape_click, {
    # set the country code based on map click
    state$country <- input$leaflet_map_shape_click$id
    state$country_name <- get_country_name()
    # trigger message to the frontend
    session$sendCustomMessage(type = "detail_open", message = "open")
  })

  observeEvent(input$detail_close, {
    session$sendCustomMessage(type = "detail_close", message = "close")
  })

  # Info_Map page revealer
  observeEvent(input$info_map_open, {
    session$sendCustomMessage(type = "info_map_open", message = "open")
  })

  observeEvent(input$info_map_close, {
    session$sendCustomMessage(type = "info_map_close", message = "close")
  })

  # Info_Detail page revealer
  observeEvent(input$info_detail_open, {
    session$sendCustomMessage(type = "info_detail_open", message = "open")
  })

  observeEvent(input$info_detail_open_about, {
    session$sendCustomMessage(type = "info_detail_open", message = "open")
  })

  observeEvent(input$info_detail_close, {
    session$sendCustomMessage(type = "info_detail_close", message = "close")
  })

  #' State -------------------------------------------------------------------

  #' Reactive states and settable defaults
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
  state$map_colors <- list(
    "Overweight" = "#e28a2e",
    "Stunting" = "#65acab"
  )
  state$radar_colors <- list(
    "past" = "#fec201",
    "latest" = "#88e5bd"
  )
  state$map_context <- "Stunting"
  state$context_color <- "#65acab"
  state$year <- "2001"
  state$country <- ""
  state$country_name <- ""

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

  #' Polar plot --------------------------------------------------------------

  #' Provides data for the indicators polar plot
  detail_data <- data_loader("./data/indicators.xlsx", sheet = "data")
  # detail_data <- function() {
  #   return(data_loader("./data/indicators.xlsx", sheet = "data"))
  # }

  get_country_name <- function() {
    # Unpack state parameters
    country_code <- state$country

    # Get country name from data
    country_name <- detail_data %>%
      filter(iso_3 == !!country_code) %>%
      pull(country)

    return(country_name)
  }

  #' Renders detailed indicators as a polar radial plot
  output$details_plot <- renderPlotly(
    indicators_radar_plot(detail_data, state)
  )
  
  #' Renders a heading based on the currently selected country in state
  output$country_heading <- renderUI(
    render_detail_header(state)
  )
}