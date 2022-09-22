################################################################################
# World map                                                                    #
################################################################################
library(geojsonio)
library(dplyr)
library(leaflet)
library(sp)
library(colorspace)
library(glue)
library(htmltools)


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
#' @param year the year to highlight data
#' @return a leaflet widget
map_renderer <- function(map_data, map_context, year, zoom = 1) {
  # Isolate year_data from map_data
  year_data <- map_data@data %>%
    select("ISO_A3", "NAME", ends_with(paste0("", year))) %>%
    rename_with(
      ~ gsub(paste0("", year), "", .),
      everything()
    )

  # Hover labels
  #! work in progress
  year_data$label <-
    paste(
      glue("<h1 class = 'lab-title'>{year_data$NAME}</h1>"),
      glue("<b>Numbers affected:</b>: {year_data$x}"),
      glue("<b>Proportion:</b>: {year_data$prop_}"),
      sep = "<br>"
    )

  #' Generates a proportional symbol
  #' @param ratio a normalised ratio range [-1..1]
  #' @param sizes a vector specifying symbol size range c(min, max)
  #' @param zoom the map zoom level
  #' @param name the name of the region/country
  #' @return icon
  map_symbol <- function(ratio, sizes = c(8, 24), zoom = 1, name = "") {
    class <- case_when(
      ratio < 0 ~ "sym_down",
      ratio > 0 ~ "sym_up",
      ratio == 0 ~ "sym_flat",
      is.na(ratio) ~ "sym_flat"
    )
    img <- case_when(
      ratio < 0 ~ "./www/down.svg",
      ratio > 0 ~ "./www/up.svg",
      ratio == 0 ~ "./www/dash.svg",
      is.na(ratio) ~ "./www/dash.svg",
    )
    size <- ifelse(
      class == "sym_flat", 0,
      (zoom * (sizes[1] + (sizes[2] * abs(ratio)))))
    icon <- makeIcon(img, NULL, size, size, className = glue("{class} {name}"))
    return(icon)
  }

  # Define the colour palette
  colors <- switch(
    map_context,
    "Stunting" = stunting_pal,
    "Overweight" = overweight_pal
  )

  # Build chloropleth colour bins
  chloropleth_colors <- colorBin(
    palette = colors,
    domain = year_data$prop_,
    na.color = "#FFFFFF00",
    bins = 5,
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
      fillColor = ~ chloropleth_colors(year_data$prop_),
      fillOpacity = 1,
      label = lapply(year_data$label, HTML)
    ) %>%
    addMarkers(
      ~ LON, ~ LAT,
      icon = ~ map_symbol(
        year_data$diff_norm_, zoom = zoom, name = year_data$NAME
      ),
      label = lapply(year_data$label, HTML)
  ) %>%
    addLegend(
      position = "topright",
      pal = chloropleth_colors,
      values = year_data$prop_,
      na.label = "Not available",
      opacity = 1
    )
  return(map)
}
