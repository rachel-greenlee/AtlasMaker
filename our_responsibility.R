

##### TO DO LIST ######
# <- put initials in front when done

#if polygons >1, create interactive dropdown menu
#all points, create interactive checkbox
#add code for adding polylines (good time to test this code with new data Zach found) 
# ^^^ copy app.R and update to new data? ^^^
#add an about page
#explore other leaflet features we want to default and/or let user set


#### COMPLETED TO DO :) :) 
#RLG - get Jason's code to work with our biodiversity data
#RLG - get color palettes working
#RLG - get popups/labels working on polygons and points
#RLG - legend back in action



map_UI <- function(id) {
	ns <- NS(id)
	leafletOutput(ns("mymap"), height = 700)
}


map_server <- function(id, 
					   polygons = NULL, 
					   points = NULL, 
					   polylines = NULL,
					   pal = NULL, 
					   center = NULL, 
					   min_zoom = 7,
					   map_base_theme = 'Stamen.Terrain') {
	moduleServer(id, function(input, output, session){
	  
	  
	  ####base map construction-------------
		output$mymap <- renderLeaflet({
			map <-  leaflet(options = 
			                  leafletOptions(minZoom = min_zoom)) %>% 
				addTiles(group = polygons[[1]]) %>%
				addProviderTiles(provider = map_base_theme)
			  
			
				if(!is.null(center)) {
					map <- map %>% setView(lng = center[1], lat = center[2], zoom = zoom)
				}	
			
			
			
			


			####polygons-------------
			polygon_names <- list()
			if(length(polygons) > 0) {
				if(!is.list(polygons[[1]])) {
					polygons <- list(polygons)
				}
			  
			  
			  
			  for(i in length(polygons)){
			    output <- polygons[[i]]$name
			    polygon_names[[i]] <- output} 


				for(i in 1:length(polygons)) {
					map <- map %>% addPolygons(data = polygons[[i]]$data,
											   weight = 1,
											   fillOpacity = 0.7,
											   color = ~pal(polygons[[i]]$data$fill_value),
											   label = ~paste(polygons[[i]]$data$NAME, polygons[[i]]$data$fill_value),
											   highlight = highlightOptions(weight = 1,
											                                color = "black"),
											   group = polygon_names) %>%
					  
					  
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
			  
			  
			  
			  for(i in length(points)){
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
			
			
			
			####draft of polyline code to try?------
			polyline_names <- list()
			
			
			if(length(polylines) > 0) {
			  if(!is.list(polylines[[1]])) {
			    polylines <- list(polylines)
			  }
			  
			  
			  
			  for(i in length(polylines)){
			    output <- polylines[[i]]$name
			    polyline_names[[i]] <- output} 
			  
			  
			  
			  
			  for(i in 1:length(polylines)) {
			    map <- map %>% addPolygons(data = polylines[[i]]$data,
			                                    group = polyline_names) 
			    
			  } }
			
			
			####interactivity-------------
			map <- map %>% addLayersControl(baseGroups = polygon_names,
			                 overlayGroups = c(point_names, polyline_names),
			                 options = layersControlOptions(collapsed = F))
			
			return(map)
			
			
		})}
)}

