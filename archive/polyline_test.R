
# Testing Polylines 

# 

require(leaflet)
require(RColorBrewer)
require(sf)

df <- Routes %>% 
  dplyr::select(the_geom.coordinates, shape_leng)

df$shape_leng <- as.numeric(df$shape_leng)


?st_cast()
st_cast(df, "MULTIPOLYGON")
as_Spatial(df$the_geom.coordinates)
c(df$the_geom.coordinates)
print(df$the_geom.coordinates)
sf::as_Spatial()

min_val_pal3 <- as.numeric(min(df$shape_leng))
max_val_pal3 <- as.numeric(max(df$shape_leng))

sf::as_Spatial(df$the_geom.coordinates)

as.Spatial(df$the_geom.coordinates)

pal3 <- colorNumeric(c("RdYlGn"), min_val_pal3:max_val_pal3) # Staten Island is 126

leaflet(df, options = 
          leafletOptions()) %>% 
  addTiles() %>%
  addProviderTiles(provider = "CartoDB") %>%
  # setView(lng = center_long, lat = center_lat, zoom = min_zoom) %>%
  addPolylines(weight = 1, fillOpacity = 0.7, 
               color = ~pal(df$shape_leng), 
               label = df$shape_leng)


  addPolygons(weight = 1,
              fillOpacity = 0.7,
              color = ~pal(),
              label = ~paste(df@data$NAME, signif(df@data$fill_value, digits = 6)),
              highlight = highlightOptions(weight = 1,
                                           color = "black",
                                           bringToFront = TRUE))