
test_that("write_codemeta", {

  path <- system.file("", package="minimeta")
  codemeta.json <- tempfile(fileext =".json")
  write_codemeta(path, file = codemeta.json)

  expect_true(file.exists(codemeta.json ))

})
