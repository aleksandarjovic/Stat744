### Homework 1. Tues Jan 16. Aleksandar Jovic ###
rm(list = ls())

library(tidyverse) #loads magritter, dplyr, readr, tidyr, purr, tibble, stringr, forcats
library(ggplot2)
library(GGally) #trusty sidekick

theme_set(theme_bw()) #override basic ggplot, can edit further later

wined=read_csv('Data/Wine.csv') #credited to: http://archive.ics.uci.edu/ml/datasets/Wine
names(wined)=c('class','alc','malic','ash','alcalin','mg','phenol','flavan','nonflav','proanth','col.int','hue','diluted','prol')

wined= wined %>% mutate(class=as.factor(class)) #the three wine classes are coded as {1,2,3} numerics originally

#ggpairs(wined, aes(colour=class, alpha=.5)) #EXTREMELY slow with this dataset, but good to check for a quick diagnostic
