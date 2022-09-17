################################################################################
# UI components for the dashboard                                              #
# @author Johnson Zhou zhoujj@student.unimelb.edu.au                           #
################################################################################
library(shiny)




# Navigation bar---------------------------------------------------------------

nav_menu <- navbarMenu(
  "Info", tabPanel("Info"),
  "----",
  "Another", tabPanel("Map")
)

# UI element-------------------------------------------------------------------

ui <- navbarPage(
  title = "Food security and nutrition around the world",
  nav_menu
)
