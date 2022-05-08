
library(tigris)
library(dplyr)

## Base polygons -----

counties_NY <- tigris::counties() %>% 
  filter(STATEFP == "36") %>% 
  dplyr::select(STATEFP, NAME, INTPTLAT, INTPTLON, ALAND, AWATER, geometry)



#### saving all files created above in an .rdata file, add as we go
save(counties_NY,
     file = "counties_NY.rdata")



## Base polylines -----


c(counties_NY$NAME)

?tigris::rails()
roads_NY <- tigris::roads("New York", county = c(counties_NY$NAME)) # Takes a long time
roads_NY_1_10 <- tigris::roads("New York", county = c(counties_NY$NAME[1:10]))
roads_NY_11_20 <- tigris::roads("New York", county = c(counties_NY$NAME[11:20]))
roads_NY_21_30 <- tigris::roads("New York", county = c(counties_NY$NAME[21:30]))
roads_NY_31_40 <- tigris::roads("New York", county = c(counties_NY$NAME[31:40]))
roads_NY_41_50 <- tigris::roads("New York", county = c(counties_NY$NAME[41:50]))
roads_NY_51_62 <- tigris::roads("New York", county = c(counties_NY$NAME[51:62]))

#try just interstate ny roads
roads_ny_interstate <- roads_NY %>%
  filter(RTTYP == "I")

save(roads_ny_interstate,
     file = 'roads_ny_interstate.rdata')

# colnames(roads_NY_1_10)
# tail(roads_NY_1_10)
# dim(na.omit(roads_NY_1_10))
# 
# sample110 <- dplyr::sample_n(na.omit(roads_NY_1_10), 1000)
# sample1120 <- dplyr::sample_n(na.omit(roads_NY_11_20), 1000)
# sample2130 <- dplyr::sample_n(na.omit(roads_NY_21_30), 1000)
# sample3140 <- dplyr::sample_n(na.omit(roads_NY_31_40), 1000)
# sample4150 <- dplyr::sample_n(na.omit(roads_NY_41_50), 1000)
# sample5162 <- dplyr::sample_n(na.omit(roads_NY_51_62), 1000)

#sample_ny_roads <- rbind(sample110, sample1120, sample2130, sample3140, sample4150, sample5162)

# save(sample_ny_roads, roads_NY_1_10, roads_NY_11_20, roads_NY_21_30, 
#      roads_NY_31_40, roads_NY_41_50, roads_NY_51_62, file = 'ny_roads.rdata')


#length(counties_NY$NAME)












