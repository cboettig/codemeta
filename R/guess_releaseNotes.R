# guess_releaseNotes -----------------------------------------------------------
guess_releaseNotes <- function(root = ".", cm) {

  ## First look for a local NEWS.md or NEWS
  news_files <- c("NEWS.md", "NEWS")

  ## Do the news files exist?
  file_exists <- file.exists(file.path(root, news_files))

  ## Give up if there is no news file or if Git is not used
  if (! any(file_exists) || ! uses_git(root)) {

    return(NULL)
  }

  ## Point to the first file that was found: NEWS.md or NEWS on the GitHub page
  github_path(root, news_files[file_exists][1], cm)

  ## Consider pointing to CRAN NEWS, BIOC NEWS?
}
