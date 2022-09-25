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

#' Generates a colour palette based on specified colour varying in alpha
#' @param hex_col the specified colour as a hex value
#' @param bins the number of colour (alpha) bins to generate
#' @return a vector of colours
alpha_palette <- function(hex_col, bins = 1) {
  colors <- adjust_transparency(hex_col, (1:bins) / bins)
  return(colors)
}

# Map definition---------------------------------------------------------------

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
    (zoom * (sizes[1] + (sizes[2] * abs(ratio))))
  )
  icon <- makeIcon(img, NULL, size, size, className = glue("{class} {name}"))
  return(icon)
}

#' Handles leaflet rendering functions for the world map
#' @param map_data the dataset for the world map with spacial information
#' @param state the reactive "state" object
#' @return a leaflet widget
map_renderer <- function(map_data, state) {
  # Unpack state parameters
  year <- state$year
  context_color <- state$context_color
  ui_colors <- state$ui_colors
  zoom <- 1

  # Isolate year_data from map_data
  year_data <- map_data@data %>%
    select("ISO_A3", "NAME", ends_with(paste0("", year))) %>%
    rename_with(
      ~ gsub(paste0("", year), "", .),
      everything()
    )

  # Hover labels
  label_data <- list(
    prev = year_data$prop_,
    num = year_data$x,
    prop = round(year_data$norm_ * 100, digits = 1),
    chng = round(year_data$diff_, digits = 1)
  )
  year_data$label <- paste(
    glue("<h1>{year_data$NAME}</h1>"),
    case_when(
      (!is.na(year_data$prop_) & !is.na(year_data$x))
        ~ paste(
          glue("<b>Prevalence:</b>: <i>{label_data$prev}%</i>"),
          glue("<b>Number of children affected:</b>: <i>{label_data$num}k</i>"),
          glue("<b>Proportion of all children affected:</b>: <i>{label_data$prop}%</i>"),
          glue("<b>Change from previous year:</b>: <i>{label_data$chng}k</i>"),
          "<em>Click for details</em>",
          sep = "<br>"
        ),
      TRUE ~ "<i>No data to display</i>"
    ),
    sep = "<br>"
  )

  # Define the colour palette
  colors <- alpha_palette(context_color, 10)

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
    # Initialise leaflet
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
    # Add base map layer
    addPolygons(
      color = ui_colors$darkgray,
      weight = 1,
      fillColor = ui_colors$gray,
      fillOpacity = 1,
    ) %>%
    # Add chloropleth layer
    addPolygons(
      layerId = ~ ISO_A3,
      weight = 0,
      fillColor = ~ chloropleth_colors(year_data$prop_),
      fillOpacity = 1,
      label = lapply(year_data$label, HTML)
    ) %>%
    # Add proportional symbol layer
    addMarkers(
      ~ LON, ~ LAT,
      icon = ~ map_symbol(
        year_data$diff_norm_, zoom = zoom, name = year_data$NAME
      ),
      label = lapply(year_data$label, HTML)
    ) %>%
    # Add legend
    addLegend(
      position = "topright",
      pal = chloropleth_colors,
      values = year_data$prop_,
      na.label = "Not available",
      opacity = 1,
      title = "Prevalence %"
    ) %>%
    # Add Reference Scale
    addScaleBar(
      position = "bottomleft",
      options = scaleBarOptions(
        metric = TRUE,
        imperial = FALSE
      )
    ) %>%
    # North arrow
    addControl(
      html = tags$img(width = 36, height = 36, src = "north.svg"),
      position = "bottomright",
      className = "leaflet-control-north-arrow "
    )
  return(map)
}
