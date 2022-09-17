################################################################################
# Server components for the dashboard                                          #
# @author Johnson Zhou zhoujj@student.unimelb.edu.au                           #
################################################################################

# App dependencies-------------------------------------------------------------
source("./R/libraries.R")

# Data-------------------------------------------------------------------------
source("./R/data.R")

# Mapping----------------------------------------------------------------------
source("./R/map.R")

# Server code------------------------------------------------------------------
library(leaflet)

server <- function(input, output, session) {
  # main world map
  output$leaflet_map <- renderLeaflet(leaflet_map)
}