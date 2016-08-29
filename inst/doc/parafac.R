## ------------------------------------------------------------------------
library(ggplot2)
library(eemR)

# Mat file containing the PARAFAC model
f <- system.file("extdata/parafac_model.mat", package = "eemR")

# Read the PARAFAC model that contains "mymodel". We also specify that we want the model with 4 components
m <- eem_read_parafac(f, object = "mymodel", ncomp = 4)

## ---- fig.width = 8, fig.height = 4, fig.align = "center"----------------
p <- plot(m, ncol = 2, nrow = 2)
p

