% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/map_server.R
\name{map_server}
\alias{map_server}
\title{The Shiny server module for AtlasMaker.}
\usage{
map_server(
  id,
  polygons = NULL,
  polygon_legend_title = NULL,
  points = NULL,
  polylines = NULL,
  center = NULL,
  min_zoom = 7,
  map_base_theme = "Stamen.Terrain",
  poly_palette = "BuPu",
  point_color = "black",
  polyline_color = "gray"
)
}
\arguments{
\item{id}{identifier for the map. This must match the id used in \code{\link[=map_UI]{map_UI()}}.}

\item{polygons}{polygon data in geospatial format.}

\item{polygon_legend_title}{title to display on legend for polygon shading}

\item{points}{point data with label, lat, and long variables.}

\item{polylines}{polyline data in geospatial format.}

\item{center}{lat/long of where to center the default map.}

\item{min_zoom}{minimum zoom level users can see, default 7.}

\item{map_base_theme}{Leaflet-compatible theme for base map.}

\item{poly_palette}{Leaflet-compatible color palette for polygon shading.}

\item{point_color}{Leaflet-compatible single color for point colors.}

\item{polyline_color}{Leaflet-compatible single color for polyline colors.}
}
\value{
a list of parameters, including spatial data, that are passed into the AtlasMaker module that builds a single map tab.
}
\description{
This is the core ui and server function for AtlasMaker where users pass in the spatial-data
based lists and aesthetic choices for each map tab.
}
\examples{
server <- function(input, output) {
map_server(id = map2,
            polygons = watersheds,
            polygon_legend_title = "Watershed",
            points = farms,
            polylines = rivers,
            point_color = 'red',
            polyline_color = 'black')
            }




}
