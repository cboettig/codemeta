test_that("We can use a preset id", {
  skip_on_cran()
  skip_if_offline()

  desc_path <- test_path("test_examples", "codemeta", "DESCRIPTION")
  id <- "https://doi.org/10.looks.like/doi"
  cm <- codemeta_description(desc_path, id = id)
  expect_equal(cm$`@id`, id)
})

test_that("We can parse additional terms", {
  skip_on_cran()
  skip_if_offline()

  desc_path <- test_path("test_examples", "codemeta", "DESCRIPTION")
  cm <- codemeta_description(desc_path)
  expect_length(cm$keywords, 6)
  expect_equal(cm$isPartOf, "https://ropensci.org")
})

test_that("We can parse plain Authors: & Maintainers: entries", {
  skip_on_cran()
  skip_if_offline()

  desc_path <- test_path("test_examples", "codemeta", "DESCRIPTION")
  authors <- codemeta_description(desc_path)
  expect_equal(authors$maintainer[[1]]$familyName, "Boettiger")
  expect_length(authors$author, 2)

  desc_path <- test_path("test_examples", "DESCRIPTION_plainauthors")
  authors <- codemeta_description(desc_path)
  expect_equal(authors$maintainer[[1]]$familyName, "Ok")
  expect_length(authors$author, 2)

  desc_path <- test_path("test_examples", "DESCRIPTION_twomaintainers")
  authors <- codemeta_description(desc_path)
  expect_length(authors$author, 1)
  expect_length(authors$maintainer, 2)
})

test_that("Helper functions work correctly", {
  skip_on_cran()
  skip_if_offline()

  # Provide testdata
  codemeta <- new_codemeta()
  codemeta$package <- "abc"
  descr <- desc::desc(test_path("test_examples", "codemeta", "DESCRIPTION"))

  # test add_language_terms()
  expect_error(add_language_terms())
  result <- add_language_terms(codemeta)
  expect_true(
    all(c("programmingLanguage", "runtimePlatform") %in% names(result))
  )

  # test add_person_terms()
  expect_error(add_person_terms())
  result <- add_person_terms(codemeta, descr)
  expect_true(
    all(
      c("author", "contributor", "copyrightHolder", "funder", "maintainer") %in%
      names(result)
    )
  )

  # test add_software_terms
  expect_error(add_software_terms())
  result <- add_software_terms(codemeta, descr)
  expect_true(all(
    c("softwareSuggestions", "softwareRequirements") %in% names(result)
  ))

  # test add_remote_provider()
  expect_error(add_remote_provider())
  expect_error(add_remote_provider(codemeta))
  remotes <- sprintf("provider%d/abc", 1:2)
  result <- add_remote_provider(codemeta, remotes)
  expect_identical(result$remote_provider, remotes)

  # test add_additional_terms()
  expect_error(add_additional_terms())
  result <- add_additional_terms(codemeta, descr)
  expect_true(all(c("isPartOf", "keywords") %in% names(result)))
})

test_that("Clean line control on description", {
  skip_on_cran()
  skip_if_offline()

  desc_path <- test_path("test_examples", "codemeta", "DESCRIPTION")

  # Pure description
  raw <- desc::desc(desc_path)

  # Should have several lines
  expect_length(unlist(strsplit(raw$get("Description"), "\n")), 4)

  cm <- codemeta_description(desc_path)
  # We should expect a single line
  expect_length(unlist(strsplit(cm$description, "\n")), 1)

  # It should be the same
  expect_identical(
    clean_str(raw$get("Description")),
    cm$description
  )

  # Snapshot
  expect_snapshot_output(cm$description)
})

test_that("Can get repo URL from BugReports if appropriate", {
  desc_path <- test_path("test_examples", "DESCRIPTION_github_link_as_issuetracker")
  cm <- add_repository_terms(list(), desc::desc(file = desc_path))
  expect_equal(cm[["codeRepository"]], "https://github.com/r-lib/commonmark")
})
