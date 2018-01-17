### Homework 1. Tues Jan 16. Aleksandar Jovic ###

## Headers ##
rm(list = ls())
library(tidyverse) #loads magritter, dplyr, readr, tidyr, purr, tibble, stringr, forcats
library(ggplot2)
library(GGally) #trusty sidekick
theme_set(theme_bw()) #override basic ggplot, can edit further later

## Dataset ##
wined=read_csv('Data/Wine.csv')
#citation: http://archive.ics.uci.edu/ml/datasets/Wine, column 1 is the class
#This dataset is a multivariate dataset which could be used for classification analysis.
names(wined)=c('class','alc','malic','ash','alcalin','mg','phenol','flavan','nonflav','proanth','col.int','hue','diluted','prol')

wined= wined %>% mutate(class=as.factor(class)) #wine classes are originally coded as {1,2,3} numerics

#ggpairs(wined, aes(colour=class, alpha=.5)) #EXTREMELY slow with this dataset, but good to check for a quick overview to estimate important variables for discriminating wine types
#ggsave("Work/HW1/pairs.pdf") #the pairs plot is in the HW1 directory

## Plot 1 ##
# Classification by alcohol content and hue

plot1=(ggplot(
  data=wined,aes(x=alc,y=hue,color=class))
    +geom_point()
)
print(plot1)
#ggsave("Work/HW1/Plot1.pdf")

# continuous on y, factor on x, facet it, vs scatterplots, vs .... maybevilin/box for the side see the pairs
#maybe do another dataset showing time series plot, and time series scatterplot (need multidimensional perhaps predator prey)
## Citations ##
citation()
citation('tidyverse')
citation('ggplot2')