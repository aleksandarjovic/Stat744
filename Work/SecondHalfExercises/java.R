library(tidyverse)
library(sunburstR)
library(pgmm)

data(coffee)
x=coffee[,-1]

sunburst(x)
#coffee's by state, although, I don't think this is the best form of data, since need a sequence data to avoid just making a glorified pie chart

library(d3heatmap)
d3heatmap(x[,-1], 
          scale = "column",
          colors = "YlGnBu",
          #dendrogram = "none",
          #Rowv = FALSE,
          #Colv = FALSE
          dendrogram = "row", 
          k_row = 3,
          xaxis_font_size = "6pt"
)
#Here the beans are identified by number, but that could be later looked up in a table. Country column needed to be omitted

y=mtcars
d3heatmap(y, 
          scale = "column",
          colors = "YlGnBu",
          #dendrogram = "none",
          #Rowv = FALSE,
          #Colv = FALSE
          dendrogram = "row", 
          k_row = 3,
          xaxis_font_size = "6pt"
)
#The mtcars dataset for comparison (since having numbers for ID is a bit confusing (looks like a numeric))