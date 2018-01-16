### Homework 1. Tues Jan 16. Aleksandar Jovic ###
rm(list = ls())

# continuous on y, factor on x, facet it, vs scatterplots, vs .... maybevilin/box for the side see the pairs

library(tidyverse) #loads magritter, dplyr, readr, tidyr, purr, tibble, stringr, forcats
library(ggplot2)
library(GGally) #trusty sidekick

theme_set(theme_bw()) #override basic ggplot, can edit further later

wined=read_csv('Data/Wine.csv') #credited to: http://archive.ics.uci.edu/ml/datasets/Wine, column 1 is the class
names(wined)=c('class','alc','malic','ash','alcalin','mg','phenol','flavan','nonflav','proanth','col.int','hue','diluted','prol')

wined= wined %>% mutate(class=as.factor(class)) #wine classes are originally coded as {1,2,3} numerics

#ggpairs(wined, aes(colour=class, alpha=.5)) #EXTREMELY slow with this dataset, but good to check for a quick diagnostic
#ggsave("Work/HW1/pairs.pdf")

#citation()
#citation('tidyverse')
#citation('ggplot2')