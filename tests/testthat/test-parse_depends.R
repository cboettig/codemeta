test_that("Test the various cases for dependencies", {
  skip_on_cran()
  skip_if_offline()

  expect_error(format_depend(NULL))
  a <- format_depend(package = "a4",
                     version = "*",
                     remote_provider = "")  # Bioconductor provider
  expect_equal(a$sameAs, "https://bioconductor.org/packages/release/bioc/html/a4.html")


  expect_equal(a$provider$`@id`, "https://www.bioconductor.org")

  a <- format_depend(package = "httr",
                     version = "*",
                     remote_provider = "") # CRAN provider
  expect_equal(a$sameAs, "https://CRAN.R-project.org/package=httr")

  a <- format_depend(package = "desc",
                     version = "*",
                     remote_provider = "r-lib/desc") # CRAN provider
  expect_equal(a$sameAs, "https://github.com/r-lib/desc")

  desc_path <- test_path("test_examples", "DESCRIPTION_twomaintainers")
  descr <- codemeta_description(desc_path)
  expect_equal(descr$softwareRequirements[[3]]$sameAs,
                         "https://github.com/lala/jsonld")

  expect_equal(a$provider$`@id`, "https://cran.r-project.org")
  a <- format_depend(package = "R",
                     version = ">= 3.0.0",
                     remote_provider = "")
  expect_equal(a$name, "R")

})

test_that("get_sameAs() works as expected", {
  skip_on_cran()
  skip_if_offline()

  expect_null(get_sameAs(NULL, "", "my_package"))

  expect_error(get_sameAs("unknown", "", "my_package"))

  expect_null(get_sameAs(list(name = "unknown"), "", "my_package"))

  provider_1 <- list(name = "Comprehensive R Archive Network (CRAN)")
  provider_2 <- list(name = "Bioconductor")

  url_1 <- "https://CRAN.R-project.org/package=my_package"
  url_2 <- "https://bioconductor.org/packages/release/bioc/html/my_package.html"
  url_3 <- "https://github.com/my_remote_package"

  expect_equal(url_1, get_sameAs(provider_1, "", "my_package"))
  expect_equal(url_2, get_sameAs(provider_2, "", "my_package"))

  expect_equal(url_3, get_sameAs(NULL, "my_remote_package"))
  expect_equal(url_3, get_sameAs("does_not_matter", "my_remote_package"))
  expect_equal(url_3, get_sameAs(NULL, "my_remote_package", "does_not_matter"))
  expect_equal(url_3, get_sameAs(NULL, "github::my_remote_package"))
})

test_that("Sys requirements", {
  skip_on_cran()
  skip_if_offline()

  desc_path <- test_path("test_examples", "DESCRIPTION_twomaintainers")
  descr <- codemeta_description(desc_path)
  expect_equal(
    descr$softwareRequirements$SystemRequirements,
    "ImageMagick++: ImageMagick-c++-devel (rpm) or libmagick++-dev (deb)")
})
