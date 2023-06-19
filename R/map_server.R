#' The Shiny server module for AtlasMaker.
#'
#' This is the core ui and server function for AtlasMaker where users pass in the spatial-data
#' based lists and aesthetic choices for each map tab.
#'
#' @param  id identifier for the map. This must match the id used in [map_UI()].
#' @param  polygons polygon data in geospatial format.
#' @param  polygon_legend_title title to display on legend for polygon shading
#' @param  points point data with label, lat, and long variables.
#' @param  polylines polyline data in geospatial format.
#' @param  center lat/long of where to center the default map.
#' @param  min_zoom minimum zoom level users can see, default 7.
#' @param  map_base_theme Leaflet-compatible theme for base map.
#' @param  poly_palette Leaflet-compatible color palette for polygon shading.
#' @param  point_color Leaflet-compatible single color for point colors.
#' @param  polyline_color Leaflet-compatible single color for polyline colors.
#'
#' @export
#' @import shiny
#' @import leaflet
#'
#' @returns a list of parameters, including spatial data, that are passed into the AtlasMaker module that builds a single map tab.
#' @examples
#' map_server(id = map2,
#'             polygons = watersheds,
#'             polygon_legend_title = "Watershed",
#'             points = farms,
#'             polylines = rivers,
#'             point_color = 'red',
#'             polyline_color = 'black')
#'
#'
#'
#'
map_server <- function(id,
                       polygons = NULL,
					   polygon_legend_title = NULL,
                       points = NULL,
                       polylines = NULL,
                       center = NULL,
                       min_zoom = 7,
                       map_base_theme = 'Stamen.Terrain',
                       poly_palette = 'BuPu',
                       point_color = 'black',
                       polyline_color = 'gray') {
  moduleServer(id, function(input, output, session){

    ####base Leaflet map construction-------------
    output$mymap <- renderLeaflet({
      map <-  leaflet(options =
                        leafletOptions(minZoom = min_zoom)) %>%
        addTiles(group = polygons[[1]]) %>%
        addProviderTiles(provider = map_base_theme)

      #zoom and centering
      if(!is.null(center)) {
        map <- map %>% leaflet::setView(lng = center[1],
        								lat = center[2],
        								min_zoom = min_zoom)
      }



      ####polygons-------------
      # create list of names
      polygon_names <- list()
      if(length(polygons) > 0) {
        if(!is.list(polygons[[1]])) {
          polygons <- list(polygons)
        }

        for(i in 1:length(polygons)){
          output <- polygons[[i]]$name
          polygon_names[[i]] <- output}

        # add one set of polygons with fill data per number of
      	# polygon lists passed through to this module
        for(i in 1:length(polygons)) {
          #fantastic way to get reactive color palette per polygon group
          mn <- as.numeric(min(polygons[[i]]$data$fill_value))
          mx <-as.numeric(max(polygons[[i]]$data$fill_value))
          pal_x <- colorNumeric(c(poly_palette), mn:mx)
          map <- map %>% addPolygons(data = polygons[[i]]$data,
                                     layerId = ~polygons,
                                     weight = 1,
                                     fillOpacity = 0.7,
                                     color = ~pal_x(polygons[[i]]$data$fill_value),
                                     label = ~paste(polygons[[i]]$data$NAME,
                                     			   polygons[[i]]$data$fill_value),
                                     highlightOptions = highlightOptions(weight = 1,
                                                                  color = "black"),
                                     group = polygon_names[[i]]) %>%

            # add legend (this won't trigger if there are no polygons in the module)
            addLegend(position = "bottomright",
                      pal = pal_x, values = polygons[[i]]$data$fill_value,
            		  title = polygon_legend_title)
        }
      }

      ####points-------------
      # create list of names
      point_names <- list()
      if(length(points) > 0) {
        if(!is.list(points[[1]])) {
          points <- list(points)
        }

        for(i in 1:length(points)){
          output <- points[[i]]$name
          point_names[[i]] <- output}

        # add one set of points per number of
      	# points lists passed through to this module
        for(i in 1:length(points)) {
          map <- map %>% addCircleMarkers(data = points[[i]]$data,
                                          lng = points[[i]]$data$long,
                                          lat = points[[i]]$data$lat,
                                          popup = points[[i]]$data$label,
                                          color = point_color,
                                          radius = 2,
                                          group = point_names)

        }
      }

      ####polylines------
      # create list of names
      polyline_names <- list()
      if(length(polylines) > 0) {
        if(!is.list(polylines[[1]])) {
          polylines <- list(polylines)
        }

        for(i in length(polylines)){
          output <- polylines[[i]]$name
          polyline_names[[i]] <- output}

        # add one set of polylines per number of polyline lists passed through to this module
        for(i in 1:length(polylines)) {
          map <- map %>% addPolylines(data = polylines[[i]]$data,
                                      color = polyline_color,
                                      group = polyline_names)

          }
        }


      ####interactivity-------------
      # references the above group = calls in the above 3 sections,
      # polygons are toggle buttons and polylines/points are checkboxes
      map <- map %>%
      	addLayersControl(baseGroups = polygon_names,
      					 overlayGroups = c(point_names, polyline_names),
      					 options = layersControlOptions(collapsed = F),
      					 data = getMapData(map))

      return(map)

    })}
  )}

