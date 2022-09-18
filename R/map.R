################################################################################
# World map                                                                    #
################################################################################
library(geojsonio)
library(dplyr)
library(leaflet)
library(sp)
library(colorspace)


# Colour definitions-----------------------------------------------------------

color_bins <- 5

alpha_palette <- function(hex_col, bins = 1) {
  colors <- adjust_transparency(hex_col, (1:bins) / bins)
  return(colors)
}

obesity_pal <- alpha_palette("#65acab", color_bins)
stunting_pal <- alpha_palette("#fe8a5e", color_bins)

# Map definition---------------------------------------------------------------

world_geojson <- geojsonio::geojson_read(
  "./data/countries.geo.json",
  what = "sp"
)

map_data <- sp::merge(
  world_geojson, malnutrition_point,
  by.x = "id", by.y = "iso_code"
)

highlight_data <- map_data@data$"x2020"

chloropleth_colors <- colorBin(
  palette = stunting_pal,
  domain = highlight_data,
  na.color = "#FFFFFF00",
  bins = color_bins,
  alpha = TRUE
)

leaflet_map <- map_data %>%
  leaflet(
    options = leafletOptions(
      minZoom = 2,
      maxZoom = 7
    ),
    sizingPolicy = leafletSizingPolicy(
      defaultWidth = "100%",
      defaultHeight = "100%"
    )
  ) %>%
  addPolygons(
    fill = FALSE,
    fillOpacity = 0,
    weight = 1,
    color = "#79757d"
  ) %>%
  addPolygons(
    weight = 0,
    fillColor = ~ chloropleth_colors(highlight_data),
    fillOpacity = 1,
    label = ~ x2020
  ) %>%
  addLegend(
    position = "bottomright",
    pal = chloropleth_colors,
    values = highlight_data,
    bins = color_bins,
    opacity = 1
  )
