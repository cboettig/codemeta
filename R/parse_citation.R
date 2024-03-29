## map a "citation" or "bibentry" R object into schema.org
# bib <- citation(pkg)

parse_citation <- function(bib) {

  type <- bibentry_to_schema_field(tools::toTitleCase(bib$bibtype))
  author <- parse_people(bib$author, new_codemeta())$author
  doi <- bib$doi

  ## determine "@id" / "sameAs" from doi, converting doi to string representing
  # URL of doi.org or NULL if doi is NULL
  id <- to_url_doi_or_null(doi)

  citation <- init_citation(type, author, doi, id, bib)

  # Extend by journal fields if bibentry is of type journal
  # parse_journal() returns NULL otherwise -> nothing happens to citation
  citation <- c(citation, parse_journal(bib))

  citation
}

# bibentry_to_schema_field -----------------------------------------------------

## All recognized bibentry types:
## N.B. none of these types are in the 2.0 context,
## so would need to include schema.org context

bibentry_to_schema_field <- function(bibtype) {
  switch(
    bibtype,
    "Article" = "ScholarlyArticle",
    "Book" = "Book",
    "Booklet" = "Book",
    "Inbook" = "Chapter",
    "Incollection" = "CreativeWork",
    "Inproceedings" = "ScholarlyArticle",
    "Manual" = "SoftwareSourceCode",
    "Mastersthesis" ="Thesis",
    "Misc" = "CreativeWork",
    "Phdthesis" = "Thesis",
    "Proceedings" = "ScholarlyArticle",
    "Techreport" = "ScholarlyArticle",
    "Unpublished" = "CreativeWork"
  )
}

# init_citation ----------------------------------------------------------------
init_citation <- function(type, author, doi, id, bib)
{
  drop_null(list(
    "@type" = type,
    "datePublished" = bib$year,
    "author" = author,
    "name" = bib$title,
    "identifier" = doi,
    "url" = bib$url,
    "description" = bib$note,
    "pagination" = bib$pages,
    "@id" = id,   # may be NULL and will be removed by drop_null()
    "sameAs" = id # same same
  ))
}

# to_url_doi_or_null -----------------------------------------------------------

to_url_doi_or_null <- function(doi) {

  # Return NULL if doi is NULL itself
  if (is.null(doi)) {

    return(NULL)
  }

  # Return doi if it already looks like an URL of doi.org
  if (grepl(paste0("^", get_url_doi()), doi)) {

    return(doi)
  }

  # If doi looks like the doi number without doi.org, create a valid URL
  if (grepl("^10.", doi)) {

    return(get_url_doi(doi))
  }

  # else return NULL invisibly
}

# parse_journal ----------------------------------------------------------------
parse_journal <- function(bib) {

  if (is.null(bib$journal)) {

    return(NULL)
  }

  list(
    "isPartOf" = drop_null(list(
      "@type" = "PublicationIssue",
      "issueNumber" = bib$number,
      "datePublished" = bib$year,
      "isPartOf" = drop_null(list(
        "@type" = c("PublicationVolume", "Periodical"),
        "volumeNumber" = bib$volume,
        "name" = bib$journal
      ))
    ))
  )
}

# guess_citation ---------------------------------------------------------------

## guessCitation referencePublication or citation?
## Handle source and installed pkgs by path (inst/CITATION or CITATION)

#' @importFrom utils readCitationFile
guess_citation <- function(path) {

  citation_path <- file.path(path, "inst/CITATION")

  citation_exists <- file.exists(citation_path)

  # try CITATION if inst/CITATION does not exist
  if (! citation_exists) {
    citation_path <- file.path(path, "CITATION")

    citation_exists <- file.exists(citation_path)
  }

  # return NULL if CITATION does not exist either
  if (! citation_exists) return(NULL)

  # Read DESCRIPTION to determine meta
  meta <- parse_package_meta(file.path(path, "DESCRIPTION"))

  # Read and parse CITATION
  bib <- utils::readCitationFile(citation_path, meta)

  lapply(bib, parse_citation)

  ## drop self-citation file?
}

#' Parse and clean data from DESCRIPTION to create metadata
#' @noRd
parse_package_meta <- function(desc_path) {
  pkg <- desc::desc(desc_path)
  pkg$coerce_authors_at_r()
  # Extract package data
  meta <- pkg$get(desc::cran_valid_fields)

  # Clean missing and drop empty fields
  meta <- drop_null(lapply(meta, clean_str))

  # Check encoding
  if (!is.null(meta$Encoding)) {
    meta <- lapply(meta, iconv, from = meta$Encoding, to = "UTF-8")
  } else {
    meta$Encoding <- "UTF-8"
  }

  meta
}
