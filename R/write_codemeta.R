
#' write_codemeta
#'
#' @param path path to the package root
#' @param id identifier for the package (e.g. a DOI, as URL)
#' @param file output file location, should be called `codemeta.json`.
#' @param verbose Whether to print messages indicating the progress of internet
#'   downloads.
#' @return a codemeta list object (invisbly) and write out the codemeta.json file
#' @export
#' @examples
#' \donttest{
#'
#'  # 'path' and 'out' here are for illustrative use only.
#'  # typical use in a package is simply `wite_codemeta()` with no arguments
#'
#'  path <- system.file("", package="codemeta")
#'  out <- tempfile(fileext =".json")
#'  write_codemeta(path, file = out)
#' }
#' @importFrom jsonlite write_json
write_codemeta <- function(
  path = ".",
  id = NULL,
  file = "codemeta.json",
  verbose = getOption("verbose", FALSE)
){

  ## get information from DESCRIPTION
  descr <- file.path(path, "DESCRIPTION")
  cm <- codemeta_description(descr, id = id, verbose = verbose)
  cm$fileSize <- guess_fileSize(path)
  cm$citation <- guess_citation(path)

  cm <- drop_null(cm)

  if(!is.null(file))
    jsonlite::write_json(cm, file, pretty = TRUE, auto_unbox = TRUE)

  invisible(cm)
}
