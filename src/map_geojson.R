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

pal <- colorNumeric(
  "Green",
  domain = map_data@data$"2020"
)

map_data <- sp::merge(
  world_geojson, malnutrition_point,
  by.x = "id", by.y = "iso_code"
)

map_data %>%
  leaflet() %>%
  addTiles() %>%
  addPolygons(
    fillColor = ~ pal(map_data@data$"x2020"),
    popup = ~ x2020
  )
