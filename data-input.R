
### This is placeholder for what arguments user will have available in package

library(sf)


# 1. Select polygons---------

# Load bundle saved from supported-polygons.R script
load("supported_polygons.rdata")


#base_map(base_polygons = 'counties_NY')
base_polygons <- counties_NY




# 2. Joining user polygon fill to selected polygons----
load("userdata.rdata")

#user sets
#my_dfs(df1 = all, df2 = birds, df3 = amphibians)
df1 <- all
df2 <- birds
df3 <- amphibians


##### TODO -> check all DF have a "NAME" column to join to base-Polygons, otherwise throw error



df1 <- base_polygons %>%
  left_join(df1, by = 'NAME')

#max_val_pal3_all <- as.numeric(max(all_poly_fill@data$Abundance))
#min_val_pal3_all <- as.numeric(min(all_poly_fill@data$Abundance)) # Changed for visual - can be removed/commented out


df2 <- base_polygons %>%
  left_join(df2, by = 'NAME')

#max_val_pal3_birds <- as.numeric(max(birds_poly_fill@data$Abundance))
#min_val_pal3_birds <- as.numeric(min(birds_poly_fill@data$Abundance))


df3 <- base_polygons %>%
  left_join(df3, by = 'NAME')

# max_val_pal3_amphibians <- as.numeric(max(amphibians_poly_fill@data$Abundance))
# min_val_pal3_amphibians <- as.numeric(min(amphibians_poly_fill@data$Abundance))


# 3. Set points------

#user sets
#my_points(pts1 = poitns_campgrounds, pts2 = points_parks, pts3 = points_watchsites)
pts1 <- points_campgrounds
pts2 <- points_parks
pts3 <- points_watchsites

##### TODO -> check all DF have a "NAME" column and lat/long, otherwise throw error




# 4. Assigning theme #1------

#theme_1(name = "All", points = c(pts1, pts3), poly_fill = df1)

theme1_name <- "All Species"

theme1_pts_1 <- pts1
theme1_pts_2 <- pts3

theme1_poly_fill_1 <- as_Spatial(df1)

# theme1_max_val <- as.numeric(max(theme1_poly_fill_1@data$Abundance))
# theme1_min_val <- as.numeric(min(theme1_poly_fill_1@data$Abundance))
# pal3_all <- colorNumeric(c("RdYlGn"), theme1_min_val:theme1_max_val)


#theme_2(name = "Birds", points = c(pts2, pts3), poly_fill = df2)

theme2_name <- "Birds"

theme2_pts_1 <- pts2

theme2_pts_2 <- pts3

theme2_poly_fill_1 <- as_Spatial(df2)

theme2_max_val <- as.numeric(max(theme2_poly_fill_1@data$Abundance))
theme2_min_val <- as.numeric(min(theme2_poly_fill_1@data$Abundance))
pal3_birds <- colorNumeric(c("RdYlGn"), theme2_min_val:theme2_max_val)




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



# color palette for any data set (needs work)
# pal3 <- colorNumeric(c("RdYlGn"), min(df@data$Abundance):max(df@data$Abundance)) # Staten Island is 126





# Saving data and variables ------

save(base_polygons, map_base_theme, center_lat, center_long, min_zoom,
     theme1_name, theme1_pts_1, theme1_pts_2, theme1_poly_fill_1,
     theme2_name, theme2_pts_1, theme2_pts_2, theme2_poly_fill_1,
     theme2_max_val, theme2_min_val, theme1_max_val, theme1_min_val,
     file = "final_data.rdata")

