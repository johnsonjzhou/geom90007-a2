################################################################################
# World map                                                                    #
################################################################################
library(geojsonio)
library(dplyr)
library(leaflet)
library(sp)
library(colorspace)


# Colour definitions-----------------------------------------------------------

#' Colour theme definitions
map_colors <- list(
  "background" = "#f4f5f3",
  "gray" = "#e7e5e6",
  "darkgray" = "#79757d",
  "foreground" = "#1a1b19",
  "obesity" = "#65acab",
  "stunting" = "#fe786e"
)

#' Generates a colour palette based on specified colour varying in alpha
#' @param hex_col the specified colour as a hex value
#' @param bins the number of colour (alpha) bins to generate
#' @return a vector of colours
alpha_palette <- function(hex_col, bins = 1) {
  colors <- adjust_transparency(hex_col, (1:bins) / bins)
  return(colors)
}

overweight_pal <- alpha_palette(map_colors$obesity, 10)
stunting_pal <- alpha_palette(map_colors$stunting, 10)

# Map definition---------------------------------------------------------------

#' Handles leaflet rendering functions for the world map
#' @param map_data the dataset for the world map with spacial information
#' @param map_context Stunting or Overweight
#' @param highlight_col the column name for the data to hilight
#' @return a leaflet widget
map_renderer <- function(map_data, map_context, highlight_col) {
  # Pull map_year to highlight
  highlight_data <- map_data@data %>% pull(highlight_col)

  # Define the colour palette
  colors <- switch(
    map_context,
    "Stunting" = stunting_pal,
    "Overweight" = overweight_pal
  )

  # Define the color bins
  color_bins <- switch(
    map_context,
    "Stunting" = c(0, 10, 20, 30, 40, 50, 60, 70),
    "Overweight" = c(0, 5, 10, 15, 20, 25, 30)
  )

  # Build chloropleth colour bins
  chloropleth_colors <- colorBin(
    palette = colors,
    domain = highlight_data,
    na.color = "#FFFFFF00",
    bins = color_bins,
    alpha = TRUE
  )

  # Leaflet widget displaying the map_data
  # and overlaid with highlight_data
  map <- map_data %>%
    leaflet(
      options = leafletOptions(
        minZoom = 3,
        maxZoom = 6
      ),
      sizingPolicy = leafletSizingPolicy(
        defaultWidth = "100%",
        defaultHeight = "100%"
      )
    ) %>%
    addPolygons(
      color = map_colors$darkgray,
      weight = 1,
      fillColor = map_colors$gray,
      fillOpacity = 1,
    ) %>%
    addPolygons(
      weight = 0,
      fillColor = ~ chloropleth_colors(highlight_data),
      fillOpacity = 1,
      label = ~ x2020
    ) %>%
    addLegend(
      position = "topright",
      pal = chloropleth_colors,
      values = highlight_data,
      na.label = "Not available",
      opacity = 1
    )
  return(map)
}
