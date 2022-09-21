################################################################################
# Server components for the dashboard                                          #
# @author Johnson Zhou zhoujj@student.unimelb.edu.au                           #
################################################################################
library(dplyr)
library(shiny)
library(leaflet)

#' The server function to pass to the shiny dashboard
server <- function(input, output, session) {
  #' Provide the current map context
  current_context <- reactive({
    return(input$map_context_selector)
  })

  #' Filter map data based on context
  map_data_filter <- reactive({
    context <- input$map_context_selector
    spatial_df <- map_data(context)
    return(spatial_df)
  })

  #' Filter map data based on year slider
  year_filter <- reactive({
    # year_col <- paste0("prop_", input$map_year_slider)
    # return(year_col)
    return(input$map_year_slider)
  })

  #' Render the world map in a leaflet widget
  output$leaflet_map <- renderLeaflet(
    map_renderer(map_data_filter(), current_context(), year_filter())
  )
}