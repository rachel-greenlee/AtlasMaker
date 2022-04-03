# The Function 
# Script to Combine Spatial Data into Geometries for Mapping 

# Step by Step Testing of Components 
# User provides clean data but we need to combine the elements into lists
# For example: 
Points <- list(
  # List of Point as 
  c(# Lat, # Lon, # Value)
  # Requires cleaned data from user
)

Polylines <- list(
  # List of Polyline Geometries 
  # Requires cleaned data from user
)

Polygons <- list(
  # List of Polygon Geometries 
  # Requires cleaned data from user
)

# Combine into a Spatial DataFrame
df <- as_Spatial(rbind(Points, Polylines, Polygons)) # This would work if the user passed the data into
                                                      # the function as a spatial data frame

# Accessing the user data as a spatial data frame would look different that individual lists
# For example: 
# User provides all geometries/data as a Spatial DataFrame

# Option 1 Using loop over df geometries
MapIt <- function(df) {
  for(i in 1:length(df)) {
    mod <- 
      # Fill in Module with Module function containing
      # generic values of df under specific pattern of naming
    mod # Display map module
  }
}

# Option 2 using individual lists of points, polylines, polygons
MapIt <- function(points, polylines, polygons) {
  module <- as_Spatial(rbind(points, polylines, polygons))  # call the lists with geoms
  print(module) 
}