

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
					   pal = NULL, 
					   center = NULL, 
					   min_zoom = 7,
					   map_base_theme = 'Stamen.Terrain') {
	moduleServer(id, function(input, output, session){
		
		output$mymap <- renderLeaflet({
			map <-  leaflet(options = 
			                  leafletOptions(minZoom = min_zoom)) %>% 
				addTiles() %>%
				addProviderTiles(provider = map_base_theme)
			
				if(!is.null(center)) {
					map <- map %>% setView(lng = center[1], lat = center[2], zoom = zoom)
				}	



			if(length(polygons) > 0) {
				if(!is.list(polygons[[1]])) {
					polygons <- list(polygons)
				}
				
				for(i in 1:length(polygons)) {
					map <- map %>% addPolygons(data = polygons[[i]]$data,
											   weight = 1,
											   fillOpacity = 0.7,
											   color = ~pal(polygons[[i]]$data$fill_value),
											   label = ~paste(polygons[[i]]$data$NAME, polygons[[i]]$data$fill_value),
											   highlight = highlightOptions(weight = 1,
											                                color = "black")) %>%
					  addLegend(position = "bottomright", 
					            pal = pal, values = polygons[[i]]$data$fill_value)
				}
			}
			
			if(length(points) > 0) {
			  if(!is.list(points[[1]])) {
			    points <- list(points)
			  }
			  
			  for(i in 1:length(points)) {
			    map <- map %>% addCircleMarkers(data = points[[i]]$data,
			                               lng = points[[i]]$data$long,
			                               lat = points[[i]]$data$lat,
			                               popup = points[[i]]$data$label,
			                               color = "purple",
			                               radius = 2)
			  
				
			  } }
			
	
			
			return(map)
			
			
		})}
)}

