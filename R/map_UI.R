#' The user interface for AtlasMaker.
#'
#' This is the core ui  function for AtlasMaker.
#'
#' @export
#' @importFrom leaflet leafletOutput
#'
#' @param  id identifier for the map. This must match the id used in [map_server()].
#'
#' @return a [leaflet::leafletOutput()] object.
#' @examples
#' map_UI('flowering_plants')
#' map_UI('map1')
#' map_UI('map2')
#'

map_UI <- function(id) {
  ns <- NS(id)
  leaflet::leafletOutput(ns("mymap"), height = 700)
}
