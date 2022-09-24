################################################################################
# Plots                                                                        #
################################################################################
library(dplyr)
library(plotly)

#' Handles plo rendering functions for the world map
#' @param map_data the dataset for the world map with spacial information
#' @param state the "state" reactive object
#' @return a plotly plot widget
yearly_total_plot <- function(map_data, state) {
  # Unpack state variables
  context_color <- state$context_color

  # Define colors to be used
  plot_colors <- adjust_transparency(
    # c(fill area, line, gridlines)
    context_color, c(0.1, 1, 0.2)
  )

  # Tooltip template
  tooltip <- paste(
    "<b>Year:</b> %{x}",
    "<b>Number affected:</b> %{y:d}",
    "<extra></extra>",
    sep = "<br>"
  )

  return(map_data@data %>%
    # Wrangle data
    select(num_range("x", 2001:2020)) %>%
    replace(is.na(.), 0) %>%
    summarise_all(sum) %>%
    rename_with(
      ~ gsub("x", "", .),
      num_range("x", 2001:2020)
    ) %>%
    stack(.) %>%
    rename(
      "year" = "ind",
      "total_affected" = "values"
    ) %>%
    # Build the plot
    plot_ly(
      x = ~ .$year, y = ~.$total_affected,
      type = "scatter", mode = "lines", fill = "tozeroy",
      fillcolor = plot_colors[1],
      line = list(color = plot_colors[2], width = 2),
      hovertemplate = tooltip
    ) %>%
    plotly::config(.,
      displayModeBar = FALSE,
      scrollZoom = FALSE,
      frameMargins = 0,
      scrollZoom = FALSE,
      doubleClick = FALSE,
      showAxisDragHandles = FALSE,
      showAxisRangeEntryBoxes = FALSE,
      displaylogo = FALSE
    ) %>%
    plotly::layout(
      xaxis = list(
        title = "",
        zeroline = FALSE,
        showline = FALSE,
        showticklabels = FALSE,
        showgrid = FALSE
      ),
      yaxis = list(
        title = "",
        zeroline = FALSE,
        showline = FALSE,
        showticklabels = FALSE,
        showgrid = TRUE,
        gridcolor = plot_colors[3]
      ),
      paper_bgcolor = "rgba(0, 0, 0, 0)",
      plot_bgcolor = "rgba(0, 0, 0, 0)",
      margin = list(
        autoexpand = FALSE,
        t = 0, r = 0, b = 0, l = 0
      )
    )
  )
}

#' Produces a radar scatter plot
#' @param data the detail_data object in server
#' @param state the "state" reactive object
#' @return a plotly plot widget
indicators_radar_plot <- function(data, state) {
  # Unpack state parameters
  ui_colors <- state$ui_colors
  fonts <- state$fonts
  radar_colors <- state$radar_colors
  country <- state$country
  country_name <- state$country_name

  # Series columns to select
  # Excluding "wasting" data as it does not have temporal comparison
  series_1_cols <- c(3, 5, 7, 10, 12, 14, 16, 18, 20)
  series_2_cols <- c(4, 6, 8, 11, 13, 15, 17, 19, 21)

  # Filter data
  country_data <- data %>% filter(iso_3 == !!country)

  series_1 <- country_data %>%
    select(series_1_cols) %>%
    as.numeric()

  series_2 <- country_data %>%
    select(series_2_cols) %>%
    as.numeric()
    
  # Adjust to percentage
  series_1 <- series_1 / 100
  series_2 <- series_2 / 100

  # Attributes
  theta <- c(
    "Undernourishment",
    "Severe food insecurity",
    "Moderate food insecurity",
    "Stunting in children",
    "Overweight in children",
    "Obesity in adults",
    "Anaemia in women",
    "Exclusive breastfeeding",
    "Low birthweight"
  )

  # Define colors to be used
  series_1_colors <- adjust_transparency(
    # c(fill area, line)
    radar_colors$past, c(0.3, 1)
  )

  series_2_colors <- adjust_transparency(
    # c(fill area, line)
    radar_colors$latest, c(0.3, 1)
  )

  return(plot_ly(
      type = "scatterpolar",
      fill = "toself",
      mode = "lines+markers"
    ) %>%
    # Add series_1 as "Past"
    add_trace(
      r = series_1,
      theta = theta,
      name = "Past",
      fillcolor = series_1_colors[1],
      line = list(color = series_1_colors[2], width = 2),
      marker = list(color = series_1_colors[2])
    ) %>%
    # Add series_2 as "Latest"
    add_trace(
      r = series_2,
      theta = theta,
      name = "Latest",
      fillcolor = series_2_colors[1],
      line = list(color = series_2_colors[2], width = 2),
      marker = list(color = series_2_colors[2])
    ) %>%
    # Plot configurations and layout
    plotly::config(.,
      displayModeBar = FALSE,
      scrollZoom = FALSE,
      frameMargins = 0,
      scrollZoom = FALSE,
      doubleClick = FALSE,
      showAxisDragHandles = FALSE,
      showAxisRangeEntryBoxes = FALSE,
      displaylogo = FALSE
    ) %>%
    layout(
      polar = list(
        radialaxis = list(
          visible = TRUE,
          range = c(0, max(series_1, series_2)),
          color = ui_colors$foreground,
          gridcolor = ui_colors$gray,
          linecolor = ui_colors$foreground,
          tickcolor = ui_colors$foreground,
          tickfont = list(
            color = ui_colors$foreground,
            family = fonts$monospace
          ),
          tickformat = ".0%",
          bgcolor = "#FFFFFFFF"
        )
      ),
      font = list(
        family = fonts$secondary,
        color = ui_colors$foreground
      ),
      paper_bgcolor = "rgba(0, 0, 0, 0)",
      plot_bgcolor = "rgba(0, 0, 0, 0)",
      margin = list(
        autoexpand = TRUE,
        t = 0, r = 150, b = 0, l = 150
      )
    )
  )
}
