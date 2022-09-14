################################################################################
# GEOM90007 Assignment 2                                                       #
# Semester 2, 2022                                                             #
# @author Johnson Zhou zhoujj@student.unimelb.edu.au                           #
################################################################################


# App dependencies-------------------------------------------------------------
source("./src/libraries.R")

# Data-------------------------------------------------------------------------
source("./src/data.R")

test <- data_provider("./data/malnutrition.xlsx",
                      type = "EXCEL",
                      sheet = "Stunting Proportion (Model)")

# Mapping----------------------------------------------------------------------
source("./src/map.R")
