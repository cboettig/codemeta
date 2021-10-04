test_that("fileSize", {
  skip_on_cran()
  skip_if_offline()

  ## should be NULL if root == NULL
  expect_null(guess_fileSize(NULL))

  ## this should just work fine
  expect_type(guess_fileSize("."), "character")

  ## test argument .ignore
  expect_type(guess_fileSize(".", .ignore = " "), "character")

})
