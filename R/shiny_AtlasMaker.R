#' Run a the AtlasMaker Shiny Demo
#'
#' @param app defaults to demo1
#'
#' @export
#' @importFrom shiny runApp
shiny_AtlasMaker <- function(
		app = c('demo1')
) {
	pkg_dir <- find.package('AtlasMaker')
	if(!app %in% list.dirs(pkg_dir, full.names = FALSE)) {
		stop('Invalid application name.')
	}
	app_dir <- paste0(pkg_dir, '/', app[1])
	shiny::runApp(appDir = app_dir)
}
