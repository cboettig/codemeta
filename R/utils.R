# drop_null --------------------------------------------------------------------
drop_null <- function(x) {

  x[lengths(x) != 0]
}

# get_root_path ----------------------------------------------------------------
get_root_path <- function(pkg) {

  if (is_installed(pkg)) {

    find.package(pkg)

  } else if (is_package(file.path(pkg))) {

    pkg

  } else if (is.character(pkg)) {

    pkg # use pkg as guess anyway

# } else {
#
#   "." # stick with default
  }
}

# package_file -----------------------------------------------------------------
# Just a shortcut to system.file(..., package = pkg)
package_file <- function(pkg, ...) {

  system.file(..., package = pkg)
}

# is_installed: is the package installed -------------------------
is_installed <- function(pkg) {

  length(
    find.package(
      package = pkg,
      quiet = TRUE
      )
    ) > 0
}

# get_file ---------------------------------------------------------------------
## Like system.file, but pkg can instead be path to package root directory
get_file <- function(FILE, pkg = ".") {

  path <- file.path(pkg, FILE)

  if (file.exists(path)) {

    path

  } else {

    package_file(pkg, FILE)
  }
}

# is_IRI -----------------------------------------------------------------------
is_IRI <- function(string) {

  ## FIXME IRI can be many other things too,
  #see https://github.com/dgerber/rfc3987 for more formal implementation
  grepl("^http[s]?://", string)
}



# whether_provider_badge -------------------------------------------------------
whether_provider_badge <- function(badges, provider_name) {

  ! is.null(provider_name) && (
    (
      provider_name == "Comprehensive R Archive Network (CRAN)" &&
        any(grepl("CRAN", badges$text))
    ) || (
      provider_name == "BioConductor" &&
        any(grepl("bioconductor", badges$link))
    )
  )
}

# is_package: helper to find whether a path is a package project ---------------
is_package <- function(path) {

  all(c("DESCRIPTION", "NAMESPACE", "man", "R") %in% dir(path))
}

# set_element ----------------------------------------------
set_element <- function(x, element, value) {

  stopifnot(is.list(x))

  x[[element]] <- value

  x

}


# fails ------------------------------------------------------------------------
#' Does the Evaluation of an Expression Fail?
#'
#' @param expr expression to be evaluated within `try(\dots)`
#' @param silent passed to [try()], see there.
#' @return `TRUE` if evaluating `expr` failed and `FALSE` if
#'   the evalutation of `expr` succeeded.
#' @noRd
fails <- function(expr, silent = TRUE) {

  inherits(try(expr, silent = silent), "try-error")
}

# example_file -----------------------------------------------------------------
example_file <- function(...) {

  package_file("codemetar", "examples", ...)
}


#' Check for Class "json" or Character
#'
#' @param x object to be checked for its class and mode
#' @return `TRUE` if `x` inherits from "json" or is of mode character,
#'   otherwise `FALSE`
#' @noRd
is_json_or_character <- function(x) {

  is(x, "json") || is.character(x)
}


# call_if ----------------------------------------------------------------------

#' Call Function if Condition is Met
#'
#' @param condition expression to be evaluated
#' @param FUN function to be called if `condition` is met
#' @param x first argument to be passed to `FUN` or not
#' @param \dots further arguments passed to `FUN`
#' @noRd
call_if <- function(condition, x, FUN, ...) {

  if (condition) {

    FUN(x, ...)

  } else {

    x
  }
}

# bind df -----------------------
bind_df <- function(dfs) {
  do.call("rbind", dfs)
}
