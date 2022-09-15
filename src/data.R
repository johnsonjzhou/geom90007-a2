################################################################################
# Data provider for the app                                                    #
# @author Johnson Zhou zhoujj@student.unimelb.edu.au                           #
################################################################################
library(dplyr)
library(tidyr)
library(janitor)

data_provider <- function(filename, type = "EXCEL", ...) {
  df <- switch(
    type,
    "CSV" = read.csv(filename, ...),
    "EXCEL" = readxl::read_excel(filename, ...)
  )
  return(df)
}

df_malnutrition <- data_provider("./data/malnutrition.xlsx",
                                  type = "EXCEL",
                                  sheet = "Stunting Proportion (Model)")

malnutrition_point <- df_malnutrition %>%
  clean_names() %>%
  rename(., "x2020" = "x2020_1") %>%
  filter(
    .$x2020 != "-",
    .$estimate == "Point Estimate"
  ) %>%
  mutate(across("x2000":"x2020", as.numeric))
