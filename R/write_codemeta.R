
#' write_codemeta
#'
#' @param path path to the package root
#' @param id identifier for the package (e.g. a DOI, as URL)
#' @param file output file location, should be called `codemeta.json`. Set to NULL to supress writing file.
#' @return a codemeta list object (invisbly) and write out the codemeta.json file
#' @export
#' @examples
#' \dontrun{
#' write_codemeta()
#' }
#' @importFrom jsonlite read_json
write_codemeta <- function(path = ".", id = NULL, file = "codemeta.json"){

  ## get information from DESCRIPTION
  descr <- file.path(path, "DESCRIPTION")
  cm <- codemeta_description(descr, id = id)
  cm$fileSize <- guess_fileSize(path)
  cm$citation <- guess_citation(path)

  cm <- drop_null(cm)

  if(!is.null(file))
    jsonlite::write_json(cm, file, pretty = TRUE, auto_unbox = TRUE)

  invisible(cm)
}
