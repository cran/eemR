## ---- include = FALSE----------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ---- comment=""---------------------------------------------------------
file <- system.file("extdata/custom_cary.csv", package = "eemR")

cat(readLines(file, n = 25), sep = "\n")

## ---- message=FALSE------------------------------------------------------

library(dplyr)
library(tidyr)
library(eemR)

import_cary <- function(file) {
  dat <- read.csv(file, nrows = 102, skip = 1)

  ex <- na.omit(dat[, 1])
  em <- seq(50, 330, by = 5)

  em <- outer(ex, em, "+")
  em <- as.vector(em)
  ex <- rep(ex, 57)

  x <- dat[, -1]
  x <- x[-1, ]
  x <- matrix(as.numeric(unlist(x, use.names = FALSE)), ncol = 101, byrow = FALSE)

  res <- tibble(ex, em, x = as.vector(x)) %>%
    arrange(ex, em) %>%
    complete(ex, em, fill = list(x = NA))

  ex <- sort(unique(ex))
  em <- sort(unique(em))
  x <- matrix(res$x, ncol = length(ex), byrow = TRUE)

  # We need to interpolate because you do not have a regular grid (i.e. asynchronous)
  r <- MBA::mba.surf(res %>% drop_na(), no.X = 200, no.Y = 200, extend = FALSE)

  l <- list(
    file = file,
    x = t(r$xyz.est$z),
    ex = r$xyz.est$x,
    em = r$xyz.est$y
  )

  return(l)
}

## ------------------------------------------------------------------------
str(import_cary(file))

## ------------------------------------------------------------------------
eem <- eem_read(file, import_function = import_cary)

eem

## ---- fig.width=8, fig.height=6------------------------------------------
plot(eem)

## ---- fig.width=8, fig.height=6------------------------------------------
# Remove second order Rayleigh scattering
plot(eem_remove_scattering(eem, "rayleigh", order = 2, width = 15))

# Extract Coble' peaks
eem_coble_peaks(eem)

