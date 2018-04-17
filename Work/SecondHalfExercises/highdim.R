library(tidyverse)
library(rggobi)
library(pgmm)

g <- ggobi(iris)
clustering <- hclust(dist(iris[,1:4]),
                     method="average")
glyph_colour(g[1]) <- cutree(clustering, 3)

