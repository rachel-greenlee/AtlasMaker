
### This is placeholder for what arguments user will have available in package

library(sf)


# 1. Select polygons---------

# Load bundle saved from supported-polygons.R script
load("supported_polygons.rdata")


### EXAMPLE PACKAGE CALL ----base_map(base_polygons = 'counties_NY')
base_polygons <- counties_NY




# 2. Joining user polygon fill to selected polygons----
load("userdata.rdata")

#user sets
### EXAMPLE PACKAGE CALL ----my_dfs(df1 = all, df2 = birds, df3 = amphibians)
df1 <- flowering_plants
df2 <- birds
df3 <- amphibians
df4 <- reptiles

##### TODO -> check all DF have a "NAME" column to join to base-Polygons, otherwise throw error



df1 <- base_polygons %>%
  left_join(df1, by = 'NAME')


df2 <- base_polygons %>%
  left_join(df2, by = 'NAME')


df3 <- base_polygons %>%
  left_join(df3, by = 'NAME')

df4 <- base_polygons %>%
  left_join(df4, by = 'NAME')



# 3. Set points------

#user sets
### EXAMPLE PACKAGE CALL ----my_points(pts1 = poitns_campgrounds, pts2 = points_parks, pts3 = points_watchsites)
pts1 <- points_campgrounds
pts2 <- points_parks
pts3 <- points_watchsites

##### TODO -> check all DF have a "NAME" column and lat/long, otherwise throw error




# 4. Assigning theme #1------

### EXAMPLE PACKAGE CALL ---- theme_1(name = "Flowering Plants", points = c(pts1, pts3), poly_fill = df1)

theme1_name <- "Flowering Plants"

theme1_pts_1 <- pts1

theme1_pts_2 <- pts3

theme1_poly_fill_1 <- as_Spatial(df1)

theme1_max_val <- as.numeric(max(theme1_poly_fill_1@data$fill_value))
theme1_min_val <- as.numeric(min(theme1_poly_fill_1@data$fill_value))
theme1_pal <- colorNumeric(c("RdYlGn"), theme1_min_val:theme1_max_val)


### EXAMPLE PACKAGE CALL ---- theme_2(name = "Birds", points = c(pts2, pts3), poly_fill = df2)

theme2_name <- "Birds"

theme2_pts_1 <- pts2

theme2_pts_2 <- pts3

theme2_poly_fill_1 <- as_Spatial(df2)

theme2_max_val <- as.numeric(max(theme2_poly_fill_1@data$fill_value))
theme2_min_val <- as.numeric(min(theme2_poly_fill_1@data$fill_value))
theme2_pal <- colorNumeric(c("RdYlGn"), theme2_min_val:theme2_max_val)


### EXAMPLE PACKAGE CALL ---- theme_3(name = "Birds", points = c(pts2, pts3), poly_fill = df2)

theme3_name <- "Amphibians"

theme3_pts_1 <- pts1

theme3_pts_2 <- pts2

theme3_poly_fill_1 <- as_Spatial(df3)

theme3_max_val <- as.numeric(max(theme3_poly_fill_1@data$fill_value))
theme3_min_val <- as.numeric(min(theme3_poly_fill_1@data$fill_value))
theme3_pal <- colorNumeric(c("RdYlGn"), theme3_min_val:theme3_max_val)


### EXAMPLE PACKAGE CALL ---- theme_3(name = "Fish", points = c(pts2, pts3), poly_fill = df2)

theme4_name <- "Reptiles"

theme4_pts_1 <- pts2

theme4_pts_2 <- pts3

theme4_poly_fill_1 <- as_Spatial(df4)

theme4_max_val <- as.numeric(max(theme4_poly_fill_1@data$fill_value))
theme4_min_val <- as.numeric(min(theme4_poly_fill_1@data$fill_value))
theme4_pal <- colorNumeric(c("RdYlGn"), theme4_min_val:theme4_max_val)





# 5. Select map defaults--------

#variable for user picks base map, nice way to preview them all here:
#https://leaflet-extras.github.io/leaflet-providers/preview/
map_base_theme <- "Stamen.Terrain"


#setting center point for map default, will want package user to set this or
#a way to code a midpoint based on data they load? maybe a wishlist thing for later
center_lat <- "42.8"
center_long <- "-75.2327"

#user sets zoom
min_zoom <- 7.2



# Saving data and variables ------

save(base_polygons, map_base_theme, center_lat, center_long, min_zoom,
     theme1_name, theme1_pts_1, theme1_pts_2, theme1_poly_fill_1,
     theme2_name, theme2_pts_1, theme2_pts_2, theme2_poly_fill_1,
     theme3_name, theme3_pts_1, theme3_pts_2, theme3_poly_fill_1,
     theme4_name, theme4_pts_1, theme4_pts_2, theme4_poly_fill_1,
     theme1_pal, theme1_max_val, theme1_min_val,
     theme2_pal, theme2_max_val, theme2_min_val, 
     theme3_pal, theme3_max_val, theme3_min_val, 
     theme4_pal, theme4_max_val, theme4_min_val,
     file = "final_data.rdata")

