################################################################################
# Libraries required for the app                                               #
# @author Johnson Zhou zhoujj@student.unimelb.edu.au                           #
################################################################################

#' Attempts to load packages and install them if required
#' @param dependencies - a vector of dependency names
load_dependencies <- function(dependencies) {
  for (package in dependencies) {
    tryCatch({
      library(package, character.only = TRUE)
    }, error = function(e) {
      install.packages(package, repos = "https://cloud.r-project.org")
      library(package, character.only = TRUE)
    })
  }
}
