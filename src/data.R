################################################################################
# Data provider for the app                                                    #
# @author Johnson Zhou zhoujj@student.unimelb.edu.au                           #
################################################################################


data_provider <- function(filename, type = "EXCEL", ...) {
  df <- switch(
    type,
    "CSV" = read.csv(filename, ...),
    "EXCEL" = readxl::read_excel(filename, ...)
  )
  return(df)
}
