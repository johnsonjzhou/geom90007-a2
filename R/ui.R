################################################################################
# UI components for the dashboard                                              #
################################################################################
library(shiny)
library(glue)
library(htmltools)

# Utilities--------------------------------------------------------------------

#' Renders an icon for the shiny dashboard
#' @param name name of the font-awesome icon
#' @return a shiny::icon object
d_icon <- function(name) {
  return(icon(name = name, lib = "font-awesome"))
}

# Header elements--------------------------------------------------------------

headers <- tags$head(
  # web fonts
  tags$link(
    rel = "stylesheet", type = "text/css",
    href = paste0(
      "https://fonts.googleapis.com/css2?",
      "family=Inter:wght@400;500;600",
      "&family=JetBrains+Mono:ital,wght@0,400;0,500;0,600;1,400;1,500;1,600",
      "&family=League+Spartan:wght@500;600",
      "&family=PT+Serif:ital,wght@0,400;0,700;1,400",
      "&display=swap"
    )
  ),
  tags$link(
    rel = "stylesheet", type = "text/css",
    href = "https://fonts.googleapis.com/icon?family=Material+Icons"
  ),
  # css overrides
  tags$link(
    rel = "stylesheet", type = "text/css",
    href = "shiny_app.css"
  ),
  # javascript
  tags$script(
    src = "shiny_app.js"
  )
)

# Title Panel------------------------------------------------------------------

title_panel <- tabPanel(
  title = "Title",
  h1("Nutrition and Food Security around the world"),
  fluidRow(
    id = "title_controls",
    class = "flex-row",
    column(
      width = 1,
      actionButton(
        inputId = "about_open",
        label = "About"
      )
    ),
    column(
      width = 3,
      selectInput(
        inputId = "map_context_selector",
        label = "Burden",
        choices = list("Stunting", "Overweight"),
        selected = "Stunting",
        multiple = FALSE,
        selectize = FALSE
      )
    )
  )
)

dimmer_panel <- tabPanel(
  title = "Dimmer"
)

# Info Panel-------------------------------------------------------------------

info_panel <- tabPanel(
  title = "About",
  icon = d_icon("circle-info"),
  actionButton(
    inputId = "about_close",
    label = "Close"
  ),
  includeMarkdown("./www/about.md"),
  fluidRow(
    class = "flex-row",
    column(
      width = 2,
      tags$image(
        class = "showcase",
        src = "map_view.png"
      ),
      actionButton(
        inputId = "info_map_open",
        label = "About Map View"
      )
    ),
    column(
      width = 2,
      tags$image(
        class = "showcase",
        src = "detail_view.png"
      ),
      actionButton(
        inputId = "info_detail_open_about",
        label = "About Details View"
      )
    )
  ),
  tags$div(class = "vertical-space"),
  includeMarkdown("./www/developer.md")
)

# Info_Map panel

info_map_panel <- tabPanel(
  title = "Info_Map",
  icon = d_icon("circle-info"),
  actionButton(
    inputId = "info_map_close",
    label = "Close"
  ),
  includeMarkdown("./www/map_view.md")
)

# Info_Detail panel

info_detail_panel <- tabPanel(
  title = "Info_Detail",
  icon = d_icon("circle-info"),
  actionButton(
    inputId = "info_detail_close",
    label = "Close"
  ),
  includeMarkdown("./www/detail_view.md")
)

# Map Panel---------------------------------------------------------------------

map_controls <- fluidRow(
  id = "leaflet_map_panel",
  column(
    id = "map_year_combo",
    width = 12,
    plotlyOutput(
      outputId = "yearly_total_plot",
      width = "550px",
      height = "80px"
    ),
    sliderInput(
      inputId = "map_year_slider",
      label = "Year (slide to change)",
      value = 2001,
      min = 2001,
      max = 2020,
      step = 1,
      ticks = TRUE,
      width = "100%",
      sep = ""
    ),
  )
)

map_panel <- tabPanel(
  title = "Map",
  leafletOutput(
    "leaflet_map",
    height = "100%", width = "100%"
  ),
  map_controls,
  icon = d_icon("map")
)

# Details panel----------------------------------------------------------------

detail_panel <- tabPanel(
  title = "Detail",
  fluidRow(
    class = "flex-row",
    column(
      width = 1,
      actionButton(
        inputId = "detail_close",
        label = "Close"
      )
    ),
    column(
      width = 1,
      actionButton(
        inputId = "info_detail_open",
        label = "Details"
      ),
    )
  ),
  htmlOutput(
    outputId = "country_heading"
  ),
  plotlyOutput(
    outputId = "details_plot",
    # 600px - 30px padding
    width = "570px",
    height = "400px"
  ),
  tags$div(
    class = "vertical-space"
  ),
  tags$div(
    class = "blockquote",
    "Data may not be complete for all countries"
  )
)

#' Renders a country name header based on state, to be called in server
#' @param state the "state" reactive object
#' @return a htmltools::tags object
render_detail_header <- function(state) {
  # Unpack state parameters
  country_name <- state$country_name

  # Error message if country name could not be found
  if (length(nchar(country_name)) < 1) {
    return(tags$div(
      h1("Country not found"),
      p(glue(
        "The selected country code cannot be located in the dataset."
      )),
      br()
    ))
  }

  # Return the header with country name
  return(tags$h1(country_name))
}

# UI element-------------------------------------------------------------------

ui <- navbarPage(
  title = "Nutrition and Food Security around the world",
  map_panel,
  title_panel,
  dimmer_panel,
  info_panel,
  detail_panel,
  info_map_panel,
  info_detail_panel,
  header = headers,
  windowTitle = "Nutrition and Food Security around the world",
  fluid = FALSE,
  position = "fixed-top",
  lang = "en"
)
