
<!-- README.md is generated from README.Rmd. Please edit that file -->

# minimeta

<!-- badges: start -->

[![R build
status](https://github.com/cboettig/minimeta/workflows/R-CMD-check/badge.svg)](https://github.com/cboettig/minimeta/actions)
[![Codecov test
coverage](https://codecov.io/gh/cboettig/minimeta/branch/master/graph/badge.svg)](https://codecov.io/gh/cboettig/minimeta?branch=master)
<!-- badges: end -->

`minimeta` is a smaller, simpler `codemetar`.

## Installation

You can install the released version of minimeta from
[CRAN](https://CRAN.R-project.org) with:

``` r
install.packages("minimeta")
```

And the development version from [GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("cboettig/minimeta")
```

## Example

``` r
minimeta::write_codemeta()
```

## Dependencies

``` r
# remotes::install_github("crsh/depgraph")
# remotes::install_github("jimhester/itdepends")
depgraph::plot_dependency_graph(".", suggests = FALSE)
```

<img src="man/figures/README-unnamed-chunk-2-1.png" width="100%" />

``` r
depgraph::plot_dependency_graph("../../ropensci/codemetar", suggests = FALSE)
```

<img src="man/figures/README-unnamed-chunk-3-1.png" width="100%" />
