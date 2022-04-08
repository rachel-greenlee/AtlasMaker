# Testing 

leaflet(datalist2$tab1$ShapeData@polygons, options = 
            leafletOptions(minZoom = min_zoom)) %>% #don't let them zoom out too much
    addTiles() %>%
    addProviderTiles(provider = map_base_theme) %>%
    setView(lng = center_long, lat = center_lat, zoom = min_zoom)
  
  # addCircleMarkers(lng = datalist$tab1$fills@data$INTPTLON, 
  #               lat = datalist$tab1$fills@data$INTPTLAT, 
  #               popup = datalist$tab1$fills@data$fill_value,
  #                color = "purple", radius = 2)
  
  addPolygons(weight = 1,
              fillOpacity = 0.7,
              color = ~pal(datalist2$tab1$ShapeData@data$fill_value),
              label = ~paste(datalist2$tab1$ShapeData@data$fill_value),
              highlight = highlightOptions(weight = 1, color = "black", bringToFront = TRUE))
  
  addMarkers(lng = datalist2$tab1$ShapeData@data$INTPTLON,
             lat = datalist2$tab1$ShapeData@data$INTPTLAT)