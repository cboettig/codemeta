test_that("spdx_license", {
  a <- spdx_license("GPL (>= 2) | file LICENCE")
  expect_equal(a, "https://spdx.org/licenses/GPL-2.0")
  b <- spdx_license("not-a-license")
  expect_equal(b, "not-a-license")
})
