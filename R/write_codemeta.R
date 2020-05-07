
#' create_codemeta
#'
#' create a codemeta list object in R for further manipulation. Similar
#' to [write_codemeta()], but returns an R list object rather
#' than writing directly to a file.  See examples.
#'
#' @inheritParams write_codemeta
#' @return a codemeta list object
#' @export
#' @examples
#' \donttest{
#' create_codemeta(".")
#' }
#' @importFrom jsonlite read_json
write_codemeta <- function(path = ".", id = NULL, file = "codemeta.json", verbose = TRUE){

  ## get information from DESCRIPTION
  cm <- codemeta_description(file.path(path, "DESCRIPTION"),
                             id = id,
                             verbose = verbose)


  cm$releaseNotes <- guess_releaseNotes(path, cm)
  cm$fileSize <- guess_fileSize(path)
  cm$citation <- guess_citation(path)

  jsonlite::write_json(cm, file, pretty = TRUE, auto_unbox = TRUE)
  invisible(cm)
}
