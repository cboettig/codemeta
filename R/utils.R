# drop_null --------------------------------------------------------------------
drop_null <- function(x) {

  x[lengths(x) != 0]
}

# is_IRI -----------------------------------------------------------------------
is_IRI <- function(string) {

  ## FIXME IRI can be many other things too,
  #see https://github.com/dgerber/rfc3987 for more formal implementation
  grepl("^http[s]?://", string)
}

# clean_str -----------------------
clean_str <- function(str) {
  # Collapse to single char
  str <- paste(str, collapse = " ")
  if (length(str) == 0 || is.null(str) || is.na(str) ||
      str == "NA") {
    return(NULL)
  }

  clean <- gsub("[\n\r]", " ", str)
  clean <- gsub("\\s+", " ", clean)
  clean <- gsub("\\s+", " ", clean)
  clean <- gsub("\\{", "", clean)
  clean <- gsub("\\}", "", clean)
  # Collapse to single char
  clean <- paste(clean, collapse = " ")

  if (clean == "") {
    return(NULL)
  }

  clean
}
