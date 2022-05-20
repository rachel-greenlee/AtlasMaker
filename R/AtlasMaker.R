#' The user interface for AtlasMaker.
#'
#' Describe here...
#'
#' @param id unique identifier for the map. This must match the id used in [map_server()].
#' @return a [leaflet::leafletOutput()] object.
#' @export
#' @importFrom leaflet leafletOutput
map_UI <- function(id) {
  ns <- NS(id)
  leaflet::leafletOutput(ns("mymap"), height = 700)
}

#' The Shiny server module for AtlasMaker.
#'
#' DESCRIBE HERE...
#'
#' @param  unique identifier for the map. This must match the id used in [map_UI()].
#'
#' @export
#' @import shiny
#' @import leaflet
map_server <- function(id,
                       polygons = NULL,
                       points = NULL,
                       polylines = NULL,
                       pal = NULL,
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
        map <- map %>% setView(lng = center[1], lat = center[2], zoom = zoom)
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

        # add one set of polygons with fill data per number of polygon lists passed through to this module
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
                                     label = ~paste(polygons[[i]]$data$NAME, polygons[[i]]$data$fill_value),
                                     highlight = highlightOptions(weight = 1,
                                                                  color = "black"),
                                     group = polygon_names[[i]]) %>%

            # add legend (this won't trigger if there are no polygons in the module)
            addLegend(position = "bottomright",
                      pal = pal_x, values = polygons[[i]]$data$fill_value)
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

        # add one set of points per number of points lists passed through to this module
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
      map <- map %>% addLayersControl(baseGroups = polygon_names,
                                      overlayGroups = c(point_names, polyline_names),
                                      options = layersControlOptions(collapsed = F),
                                      data = getMapData(map))

      return(map)

    })}
  )}

