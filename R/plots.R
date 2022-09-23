################################################################################
# Plots                                                                        #
################################################################################
library(dplyr)
library(plotly)

#' Handles plo rendering functions for the world map
#' @param map_data the dataset for the world map with spacial information
#' @param map_context Stunting or Overweight
#' @param year the year to highlight data
#' @return a leaflet widget
yearly_total_plot <- function(map_data, map_context, year) {
  # Define colors to be used
  plot_colors <- adjust_transparency(
    # c(fill area, line, gridlines)
    "#210ced", c(0.1, 1, 0.2)
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
