################################################################################
# World map                                                                    #
################################################################################
library(geojsonio)
library(dplyr)
library(leaflet)
library(sp)
library(colorspace)


# Colour definitions-----------------------------------------------------------

#' Specify the number of color bins used in the chloropleth map
map_color_bins <- 5

#' Colour theme definitions
map_colors <- list(
  "background" = "#f4f5f3",
  "gray" = "#e7e5e6",
  "darkgray" = "#79757d",
  "foreground" = "#1a1b19",
  "obesity" = "#65acab",
  "stunting" = "#fe8a5e"
)

#' Generates a colour palette based on specified colour varying in alpha
#' @param hex_col the specified colour as a hex value
#' @param bins the number of colour (alpha) bins to generate
#' @return a vector of colours
alpha_palette <- function(hex_col, bins = 1) {
  colors <- adjust_transparency(hex_col, (1:bins) / bins)
  return(colors)
}

obesity_pal <- alpha_palette(map_colors$obesity, map_color_bins)
stunting_pal <- alpha_palette(map_colors$stunting, map_color_bins)

# Map definition---------------------------------------------------------------

#' Load the world map spacial data from a geojson file
world_geojson <- geojsonio::geojson_read(
  "./data/countries.geo.json",
  what = "sp"
)

#' Handles leaflet rendering functions for the world map
#' @param highlight_data the dataset used for chloropleth highlighting
#' @param map_data the base dataset for the world map with spacial information
#' @return a leaflet widget
map_renderer <- function(highlight_data, map_data) {
  # chloropleth colour palette
  chloropleth_colors <- colorBin(
    palette = stunting_pal,
    domain = highlight_data,
    na.color = "#FFFFFF00",
    bins = map_color_bins,
    alpha = TRUE
  )

  # leaflet widget displaying the map_data
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
      opacity = 1
    )
  return(map)
}
