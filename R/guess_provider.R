# guess_provider ---------------------------------------------------------------
guess_provider <- function(pkg, verbose = FALSE) {

  if (is.null(pkg)) return(NULL)

  ## Assumes a single provider
  if (is_cran_package(pkg, verbose)) {

    new_codemeta_organization(
      url = "https://cran.r-project.org",
      name = "Comprehensive R Archive Network (CRAN)"
    )

  } else if (is_bioconductor_package(pkg, verbose)) {

    new_codemeta_organization(
      url = "https://www.bioconductor.org",
      name = "BioConductor"
    )

  } else {

    NULL
  }
}

# available_source_packages ----------------------------------------------------
codemeta_cache_env <- new.env(parent = emptyenv())

available_source_packages <- function(repo = c("CRAN", "BIOC")) {

  url <-
    switch(
      repo,
      CRAN = "https://cloud.r-project.org",
      BIOC = "https://www.bioconductor.org/packages/release/bioc",
      stop("Only CRAN and BIOC repos are supported.")
    )

  contrib_url <- utils::contrib.url(url, "source")

  if (is.null(codemeta_cache_env[[repo]])) {
    codemeta_cache_env[[repo]] <- utils::available.packages(contrib_url)
  }

  suppressWarnings(codemeta_cache_env[[repo]])

}

# is_cran_package --------------------------------------------------------------
is_cran_package <- function(pkg, verbose = FALSE) {

  is_in_package_info(pkg, available_source_packages("CRAN"))
}

# is_bioconductor_package ------------------------------------------------------
is_bioconductor_package <- function(pkg, verbose = FALSE) {

  is_in_package_info(pkg, available_source_packages("BIOC"))
}

# is_in_package_info -----------------------------------------------------------
#' @param pkg package name
#' @param package_info data frame or matrix with column `Package`, eg.
#'   as returned by [utils::available.packages()]
#' @noRd
is_in_package_info <- function(pkg, package_info, verbose = FALSE) {

  pkg %in% package_info[, "Package"]
}

# new_codemeta_organization ----------------------------------------------------
new_codemeta_organization <- function(url, name) {

  list(
    "@id" = url,
    "@type" = "Organization",
    "name" = name,
    "url" = url
  )
}
