#' @keywords internal
"_PACKAGE"

#' points_campgrounds
#'
#' Data on campgrounds in and outside of the Adirondacks in New York.
#' For this package demo two data files were combined and only three columns were retained.
#'
#' @format A data frame with 116 rows and 3 variables:
#' \describe{
#'   \item{label}{name of the campground}
#'   \item{long}{longitude value}
#'   \item{lat}{latitude value}
#'   ...
#' }
#' @source \url{https://data.ny.gov/Recreation/Campgrounds-by-County-Within-Adirondack-Catskill-F/tnqf-vydw}
#' @source \url{https://data.ny.gov/Recreation/Campgrounds-by-County-Outside-Adirondack-Catskill-/5zxz-z3ci}
#' @docType data
#' @name points_campgrounds
NA

#' points
#'
#' Takes user defined data for points in demo1
#' Default is NULL or empty
#'
#' @format A function with arguments x, ...:
#' \describe{
#'   \item{x}{user data}
#'   ...
#' }
#' @source \url{none}
#' @docType data
#' @name points
NA


#' points_parks
#'
#' Data on state parks in New  York. For this package demo only three columns were retained.
#'
#' @format A data frame with 254 rows and 3 variables:
#' \describe{
#'   \item{label}{name of state park}
#'   \item{long}{longitude value}
#'   \item{lat}{latitude value}
#'   ...
#' }
#' @source \url{https://data.ny.gov/Recreation/Watchable-Wildlife-Sites/hg7a-5ssi}
#' @docType data
#' @name points_parks
NA

#' points_watchsites
#'
#' Data originally from data.ny.gov, for this package demo only three columns were retained.
#'
#' @format A data frame with 76 rows and 3 variables:
#' \describe{
#'   \item{label}{name of watchsite location}
#'   \item{long}{longitude value}
#'   \item{lat}{latitude value}
#'   ...
#' }
#' @source \url{https://data.ny.gov/Recreation/Watchable-Wildlife-Sites/hg7a-5ssi}
#' @docType data
#' @name points_watchsites
NA

#' counties_NY
#'
#' US Census polygon data for New York state counties accessed through the `tigris` R Package.
#'
#' @format A spatial data frame with 62 rows and 7 variables:
#' \describe{
#'   \item{STATEP}{state's code}
#'   \item{NAME}{county name}
#'   \item{INTPLAT}{latitude}
#'   \item{INTPTLON}{longitude}
#'   \item{ALAND}{area of land, in square meters}
#'   \item{AWATER}{area of water, in square meters}
#'   \item{geometry}{polygon information}
#'   ...
#' }
#' @source \url{https://www.census.gov/geographies/mapping-files/time-series/geo/tiger-line-file.html}
#' @docType data
#' @name counties_NY
NA

#' roads_ny_interstate
#'
#' US Census polyline data for New York state interstates accessed through the `tigris` R Package.
#'
#' @format A data frame with 245 rows and 5 variables:
#' \describe{
#'   \item{LINEARID}{unique identifier}
#'   \item{FULLNAME}{interstate name}
#'   \item{RTTYP}{route type}
#'   \item{MTFCC}{US Census feature class code}
#'   \item{geometry}{polyline information}
#'   ...
#' }
#' @source \url{}
#' @docType data
#' @name roads_ny_interstate
NA

#' amphibians
#'
#' Derived from data.ny.gov biodiversity data by county, filtered for amphibians
#' only and combined with counties_NY Census-sourced data.
#'
#' @format A spatial data frame with 62 county entries:
#' \describe{
#'   \item{STATEP}{state's code}
#'   \item{NAME}{county name}
#'   \item{INTPLAT}{latitude}
#'   \item{INTPTLON}{longitude}
#'   \item{ALAND}{area of land, in square meters}
#'   \item{AWATER}{area of water, in square meters}
#'   \item{Taxonomic.Group}{For animals and plants, the taxonomic phylum, class, or order to which the species belongs.}
#'   \item{fill_value}{count of species from amphibians taxonomic group, by county  ????????ZACH HOW DID YOU DO THIS?}
#'   ...
#' }
#' @source \url{https://data.ny.gov/Energy-Environment/Biodiversity-by-County-Distribution-of-Animals-Pla/tk82-7km5}
#' @docType data
#' @name amphibians
NA

#' reptiles
#'
#' Derived from data.ny.gov biodiversity data by county, filtered for reptiles only.
#'
#'
#' @format A spatial data frame with 62 county entries:
#' \describe{
#'   \item{STATEP}{state's code}
#'   \item{NAME}{county name}
#'   \item{INTPLAT}{latitude}
#'   \item{INTPTLON}{longitude}
#'   \item{ALAND}{area of land, in square meters}
#'   \item{AWATER}{area of water, in square meters}
#'   \item{Taxonomic.Group}{For animals and plants, the taxonomic phylum, class, or order to which the species belongs.}
#'   \item{fill_value}{count of species from reptiles taxonomic group, by county  ????????ZACH HOW DID YOU DO THIS?}
#'   ...
#' }
#' @source \url{https://data.ny.gov/Energy-Environment/Biodiversity-by-County-Distribution-of-Animals-Pla/tk82-7km5}
#' @docType data
#' @name reptiles
NA

#' flowering_plants
#'
#' Derived from data.ny.gov biodiversity data by county, filtered for flowering plants only.
#'
#'
#' @format A spatial data frame with 62 county entries:
#' \describe{
#'   \item{STATEP}{state's code}
#'   \item{NAME}{county name}
#'   \item{INTPLAT}{latitude}
#'   \item{INTPTLON}{longitude}
#'   \item{ALAND}{area of land, in square meters}
#'   \item{AWATER}{area of water, in square meters}
#'   \item{Taxonomic.Group}{For animals and plants, the taxonomic phylum, class, or order to which the species belongs.}
#'   \item{fill_value}{count of species from flowering plants taxonomic group, by county  ????????ZACH HOW DID YOU DO THIS?}
#'   ...
#' }
#' @source \url{https://data.ny.gov/Energy-Environment/Biodiversity-by-County-Distribution-of-Animals-Pla/tk82-7km5}
#' @docType data
#' @name flowering_plants
NA

#' birds
#'
#' Derived from data.ny.gov biodiversity data by county, filtered for birds only.
#'
#'
#' @format A spatial data frame with 62 county entries:
#' \describe{
#'   \item{STATEP}{state's code}
#'   \item{NAME}{county name}
#'   \item{INTPLAT}{latitude}
#'   \item{INTPTLON}{longitude}
#'   \item{ALAND}{area of land, in square meters}
#'   \item{AWATER}{area of water, in square meters}
#'   \item{Taxonomic.Group}{For animals and plants, the taxonomic phylum, class, or order to which the species belongs.}
#'   \item{fill_value}{count of species from birds taxonomic group, by county  ????????ZACH HOW DID YOU DO THIS?}
#'   ...
#' }
#' @source \urlhttps://data.ny.gov/Energy-Environment/Biodiversity-by-County-Distribution-of-Animals-Pla/tk82-7km5{}
#' @docType data
#' @name birds
NA


## usethis namespace: start
## usethis namespace: end
NULL

