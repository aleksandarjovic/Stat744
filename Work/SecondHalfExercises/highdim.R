library(tidyverse)
library(rggobi)
library(pgmm)

library(tourr)
library(TeachingDemos)
library(colorspace)
library(skimr)
library(geozoo) #high dim shapes, and codes to generate them
library(randomForest)
library(ochRe)#install_github("ropenscilabs/ochRe")
library(rlang)
library(clusterfly)
library(reshape)
library(aplpack)

data(olive)
x=olive
##had significant trouble installing this, used: source("http://www.ggobi.org/downloads/install.r")
## 
g <- ggobi(x)
clustering <- hclust(dist(x[,3:10]),
                     method="average")
glyph_colour(g[3]) <- cutree(clustering, k=3)
#it doesn't work anymore after I restarted R..... now I'm missing some key file from my directory.... I'll leave this here as a basic framework
## BMB: I get Error in UseMethod("glyph_colour<-", x) : 
##   no applicable method for 'glyph_colour<-' applied to an object of class "NULL"

##grand tour
data(coffee)
y=coffee[,-1]
## BMB: shouldn't we drop both columns 1 and 2 (region, Country)?
## these will be useful as labels but not as numeric variables ...

animate(y[,2:4],tour_path=grand_tour(),display=display_xy())
#looking at water, weight, yield, but could pick whatever
## BMB: I feel like part of the point of "high-dimensional visualization"
##  is lost when you restrict yourself to 3 variables/dimensions ...

##faces... perhaps one of the most useless graphs? but here it is.
#perhaps could be useful, or at least funny in fringe cases
faces(y[1:3,2:4])
