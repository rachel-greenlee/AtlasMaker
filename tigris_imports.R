
library(tigris)


## Base polygons -----

counties_NY <- tigris::counties() %>% 
  filter(STATEFP == "36") %>% 
  dplyr::select(STATEFP, NAME, INTPTLAT, INTPTLON, ALAND, AWATER, geometry)



#### saving all files created above in an .rdata file, add as we go
save(counties_NY,
     file = "counties_NY.rdata")


clinton_county_roads <- tigris::roads("36", "Clinton")

save(clinton_county_roads,
     file = "clinton_county_roads.rdata")



us_road <- tigris::primary_roads()
us_rails <- tigris::rails()
states <- tigris::states(cb = TRUE)





#### saving all files created above in an .rdata file, add as we go
save(us_road, us_rails, states,
     file = "app3.rdata")