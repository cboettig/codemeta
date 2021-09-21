test_that("We can parse_citation",{

  f <- test_path("test_examples", "RNeXML", "CITATION_")
  bib <- readCitationFile(f)
  schema <- lapply(bib, parse_citation)
  expect_type(schema, "list")
  expect_equal(schema[[1]][["@type"]], "ScholarlyArticle")

})

test_that("We can parse citations", {
  # prep
  examples_path <- test_path("test_examples")
  tmpdir <- tempdir()
  pkg_name <- "RNeXML"
  pkg_tmp_path <- file.path(tmpdir, pkg_name)
  on.exit(unlink(pkg_tmp_path, recursive = TRUE), add = TRUE)
  file.copy(file.path(examples_path, pkg_name), tmpdir, recursive = TRUE)
  file.rename(file.path(pkg_tmp_path, "CITATION_"), file.path(pkg_tmp_path, "CITATION"))

  ## CITATION in pkg root
  gc_root <- guess_citation(pkg_tmp_path)
  expect_type(gc_root, "list")
  expect_equal(gc_root[[1]][["@type"]], "ScholarlyArticle")

  ## CITATION in `inst`, i.e. in-dev pkg
  # prep
  dir.create(file.path(pkg_tmp_path, "inst"))
  file.rename(file.path(pkg_tmp_path, "CITATION"), file.path(pkg_tmp_path, "inst", "CITATION"))
  # ensure files are where we expect them to be
  expect_false(file.exists(file.path(pkg_tmp_path, "CITATION")))
  expect_true(file.exists(file.path(pkg_tmp_path, "inst", "CITATION")))
  # test
  gc_inst <- guess_citation(pkg_tmp_path)
  expect_type(gc_inst, "list")
  expect_equal(gc_inst[[1]][["@type"]], "ScholarlyArticle")

  ## not a package path returns null and doesn't error
  gc_null <- guess_citation(file.path(examples_path, "not-a-package"))
  expect_null(gc_null)
})

test_that("We can parse meta tags", {
  c <- test_path("test_examples", "rmarkdown", "CITATION_")
  # Need that file to completely parse all the tags
  d <- test_path("test_examples", "rmarkdown", "DESCRIPTION_codemeta_from_cran_")

  # Read DESCRIPTION to determine meta
  meta <- parse_package_meta(d)

  # Read and parse CITATION
  bib <- utils::readCitationFile(c, meta)
  expect_s3_class(bib, "citation")

  bibs <- lapply(bib, parse_citation)
  expect_type(bibs, "list")
  expect_snapshot_output({
    print("rmarkdown citation parsed with codemeta DESCRIPTION")
    print(bibs[1])
  })
})


test_that("We can parse citations with citation(auto = meta)", {
  c <- test_path("test_examples", "citation_auto", "CITATION_")

  # Need that file to completely parse all the tags
  d <- test_path("test_examples", "rmarkdown", "DESCRIPTION_codemeta_from_cran_")

  # Read DESCRIPTION to determine meta
  meta <- parse_package_meta(d)
  bib <- utils::readCitationFile(c, meta)
  expect_true(length(bib) == 3)

  expect_s3_class(bib, "citation")

  bibs <- lapply(bib, parse_citation)
  expect_type(bibs, "list")
  expect_snapshot_output({
    print("citation with citation(auto = meta)")
    print(bibs)
  })
})
