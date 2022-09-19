################################################################################
# Server components for the dashboard                                          #
# @author Johnson Zhou zhoujj@student.unimelb.edu.au                           #
################################################################################
library(dplyr)
library(shiny)
library(leaflet)

#' The server function to pass to the shiny dashboard
server <- function(input, output, session) {

  map_data <- sp::merge(
    world_geojson, malnutrition_point,
    by.x = "id", by.y = "iso_code"
  )

  #' Filter map data based on year slider
  highlight_filter <- reactive({
    map_year <- paste0("x", input$map_year_slider)
    highlight_data <- map_data@data %>% pull(map_year)
    return(highlight_data)
  })

  #' Render the world map in a leaflet widget
  output$leaflet_map <- renderLeaflet(
    map_renderer(highlight_filter(), map_data)
  )
}