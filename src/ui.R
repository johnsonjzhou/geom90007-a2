################################################################################
# UI components for the dashboard                                              #
# @author Johnson Zhou zhoujj@student.unimelb.edu.au                           #
################################################################################
library(shiny)

# main <- mainPanel(
#   tabsetPanel(
#     tabPanel()
#   )
# )

nav_menu <- navbarMenu(
  "Info", tabPanel("Info"),
  "----",
  "Another", tabPanel("Map")
)

ui <- navbarPage(
  title = "Food security and nutrition around the world",
  nav_menu
)
