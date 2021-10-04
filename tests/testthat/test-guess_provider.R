test_that("guess_provider() works",{
  skip_on_cran()
  skip_if_offline()

  expect_null(guess_provider(NULL))

  ## A BIOC package
  expect_equal(guess_provider("a4")$name, "BioConductor")
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
  expect_false(is.null(codemeta_cache_env$BIOC))
})
