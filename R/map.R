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

map_colors <- list(
  "background" = "#f4f5f3",
  "gray" = "#e7e5e6",
  "darkgray" = "#79757d",
  "foreground" = "#1a1b19",
  "obesity" = "#65acab",
  "stunting" = "#fe8a5e"
)

alpha_palette <- function(hex_col, bins = 1) {
  colors <- adjust_transparency(hex_col, (1:bins) / bins)
  return(colors)
}

obesity_pal <- alpha_palette(map_colors$obesity, color_bins)
stunting_pal <- alpha_palette(map_colors$stunting, color_bins)

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
