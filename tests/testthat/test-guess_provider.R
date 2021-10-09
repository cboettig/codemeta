test_that("guess_provider() works",{
  skip_on_cran()
  skip_if_offline()

  expect_null(guess_provider(NULL))

  ## A Bioconductor package
  expect_equal(guess_provider("a4")$name, "Bioconductor")
  ## A CRAN package
  expect_equal(
    guess_provider("jsonlite")$name,
    "Comprehensive R Archive Network (CRAN)"
  )
})

test_that("available_source_packages() uses cache", {
  skip_on_cran()
  skip_if_offline()

  # available_source_packages have been added to cache by calls above
  expect_false(is.null(codemeta_cache_env$CRAN))
  expect_false(is.null(codemeta_cache_env$Bioconductor))
})

test_that("guess_provider() can be verbose", {
  skip_on_cran()
  skip_if_offline()

  # First delete cache so metadata needs to be loaded again
  codemeta_cache_env$CRAN <- NULL

  # There are two messages which we need to capture
  expect_message(
    expect_message(
      guess_provider("jsonlite", verbose = TRUE),
      "Getting CRAN" # First message before fetching data
    ),
    "Got CRAN" # Second message when data arrived
  )

  # Now the same with Bioconductor, delete cache and capture two messages
  codemeta_cache_env$Bioconductor <- NULL
  expect_message(
    expect_message(
      guess_provider("a4", verbose = TRUE),
      "Getting Bioconductor" # First message before fetching data
    ),
    "Got Bioconductor" # Second message when data arrived
  )
})
