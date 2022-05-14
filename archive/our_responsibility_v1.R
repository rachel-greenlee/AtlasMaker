

map_UI <- function(id) {
  ns <- NS(id)
  leafletOutput(ns("mymap"), height = 700)
}


#set variables that may come in with each module, with some defaults if missing
map_server <- function(id, 
                       polygons = NULL, 
                       points = NULL, 
                       polylines = NULL,
                       pal = NULL, 
                       center = NULL, 
                       min_zoom = 7,
                       map_base_theme = 'Stamen.Terrain') {
  moduleServer(id, function(input, output, session){
    
    
    ####base leaflet map construction-------------
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
        
        # add 
        for(i in 1:length(polygons)) {
          map <- map %>% addPolygons(data = polygons[[i]]$data,
                                     layerId = ~polygons,
                                     weight = 1,
                                     fillOpacity = 0.7,
                                     # To adjust color by selection
                                     # Select polygon_names[[i]] then filter?
                                     # (colorNumeric(c("RdYlGn"), 
                                     #               min(polygons[[i]]$data$fill_value):max(polygons[[i]]$data$fill_value)))
                                     color = ~pal(polygons[[i]]$data$fill_value), 
                                     label = ~paste(polygons[[i]]$data$NAME, polygons[[i]]$data$fill_value),
                                     highlight = highlightOptions(weight = 1,
                                                                  color = "black"),
                                     group = polygon_names[[i]]) %>%
            
            
            addLegend(position = "bottomright", 
                      pal = pal, values = polygons[[i]]$data$fill_value)
          
          
        }
      }
      
      
      ####points-------------
      point_names <- list()
      if(length(points) > 0) {
        if(!is.list(points[[1]])) {
          points <- list(points)
        }
        
        
        
        for(i in 1:length(points)){
          output <- points[[i]]$name
          point_names[[i]] <- output} 
        
        
        
        
        for(i in 1:length(points)) {
          map <- map %>% addCircleMarkers(data = points[[i]]$data,
                                          lng = points[[i]]$data$long,
                                          lat = points[[i]]$data$lat,
                                          popup = points[[i]]$data$label,
                                          color = "purple",
                                          radius = 2,
                                          group = point_names) 
          
        } }
      
      
      
      ####polylines------
      polyline_names <- list()
      
      
      if(length(polylines) > 0) {
        if(!is.list(polylines[[1]])) {
          polylines <- list(polylines)
        }
        
        
        
        for(i in length(polylines)){
          output <- polylines[[i]]$name
          polyline_names[[i]] <- output} 
        
        
        
        
        for(i in 1:length(polylines)) {
          map <- map %>% addPolylines(data = polylines[[i]]$data,
                                     group = polyline_names) 
          
        } }
      
      
      ####interactivity-------------
      map <- map %>% addLayersControl(baseGroups = polygon_names,
                                      overlayGroups = c(point_names, polyline_names),
                                      options = layersControlOptions(collapsed = F),
                                      data = getMapData(map))
      
      return(map)
      
      
    })}
  )}

