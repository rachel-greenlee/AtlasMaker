
library(tigris)


## Base polygons -----

counties_NY <- tigris::counties() %>% 
  filter(STATEFP == "36") %>% 
  dplyr::select(STATEFP, NAME, INTPTLAT, INTPTLON, ALAND, AWATER, geometry)









# Save base polygons data----

#### saving all files created above in an .rdata file, add as we go
save(counties_NY,
     file = "supported_polygons.rdata")