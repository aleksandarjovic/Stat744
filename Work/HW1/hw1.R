### Homework 1. Tues Jan 16. Aleksandar Jovic ###
rm(list = ls())

#######Look up violin plots later, boxplots with probability density
library(tidyverse) #loads magritter, dplyr, readr, tidyr, purr, tibble, stringr, forcats
library(ggplot2)
library(GGally)
#library(pgmm) #contains datasets: {coffee, olive, wine}
#library(help="datasets") #suggested to find datasets *your data set should have >100 obs and 4 var, at least one categorical, one continuous variable

theme_set(theme_bw())

wine.dat=read_csv("Data/Wine.csv") #DIFFERENT wine set from the pgmm one
names(wine.dat)=c('','','','') #14 columns
