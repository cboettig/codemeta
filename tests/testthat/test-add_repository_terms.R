test_that("add_repository_terms works", {
  skip_on_cran()
  skip_if_offline()

  # Provide testdata
  cm <- new_codemeta()
  cm$package <- "abc"
  desc_path <- test_path("test_examples", "DESCRIPTION_twomaintainers")
  descr <- desc::desc(desc_path)

  expect_error(add_repository_terms())
  cm <- add_repository_terms(cm, descr = descr)
  expect_true(all(c("codeRepository", "relatedLink") %in% names(cm)))
  expect_equal(cm$codeRepository, "https://github.com/ropensci/codemetar")
  expect_true("https://ropensci.github.io/codemetar" %in% cm$relatedLink)
})

test_that("add_repository_terms updates the codeRepository URL", {
  skip_on_cran()
  skip_if_offline()
  cm <- new_codemeta()
  cm$codeRepository <- "lalala"
  desc_path <- test_path("test_examples", "DESCRIPTION_twomaintainers")
  descr <- desc::desc(desc_path)

  cm <- add_repository_terms(cm, descr = descr)
  expect_equal(cm$codeRepository, "https://github.com/ropensci/codemetar")
  expect_true("https://ropensci.github.io/codemetar" %in% cm$relatedLink)
})

test_that("add_repository_terms works with non-GitHub-repository", {
  skip_on_cran()
  skip_if_offline()

  # gitlab.com
  desc_path <- test_path("test_examples", "hrbraddins", "DESCRIPTION")
  cm <-
    add_repository_terms(
      codemeta = new_codemeta(),
      descr = desc::desc(desc_path)
    )
  expect_equal(cm$codeRepository, "https://gitlab.com/hrbrmstr/hrbraddins")

  # bitbucket.org
  desc_path <- test_path("test_examples", "llama", "DESCRIPTION")
  cm <-
    add_repository_terms(
      codemeta = new_codemeta(),
      descr = desc::desc(desc_path)
    )
  expect_equal(cm$codeRepository, "https://bitbucket.org/lkotthoff/llama")

  # custom URL
  desc_path <- test_path("test_examples", "hrbragg", "DESCRIPTION")
  cm <-
    add_repository_terms(
      codemeta = new_codemeta(),
      descr = desc::desc(desc_path)
    )
  expect_equal(cm$codeRepository, "https://git.rud.is/hrbrmstr/hrbragg")
})
