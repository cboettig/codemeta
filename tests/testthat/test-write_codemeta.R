
test_that("write_codemeta", {

  # Safer version
  path <- find.package("codemeta")
  codemeta.json <- tempfile(fileext =".json")
  write_codemeta(path, file = codemeta.json)

  expect_true(file.exists(codemeta.json ))

})
