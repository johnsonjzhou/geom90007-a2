################################################################################
# World map                                                                    #
################################################################################
library(geojsonio)
library(dplyr)
library(leaflet)
library(sp)


world_geojson <- geojsonio::geojson_read(
  "./data/countries.geo.json",
  what = "sp"
)

map_data <- sp::merge(
  world_geojson, malnutrition_point,
  by.x = "id", by.y = "iso_code"
)

chloropleth_colors <- colorNumeric(
  "Green",
  domain = map_data@data$"2020"
)

leaflet_map <- map_data %>%
  leaflet() %>%
  addTiles() %>%
  addPolygons(
    fillColor = ~ chloropleth_colors(map_data@data$"x2020"),
    #! x2020 doesn't work below
    popup = ~ x2020
  )
