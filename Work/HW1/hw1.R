### Homework 1. Tues Jan 16. Aleksandar Jovic ###

## Headers ##
rm(list = ls())
library(tidyverse) #loads magritter, dplyr, readr, tidyr, purr, tibble, stringr, forcats
library(ggplot2)
library(GGally) #trusty sidekick
theme_set(theme_bw()) #override basic ggplot, can edit further later

## Dataset ##
wined=read_csv('Data/Wine.csv')
#citation: http://archive.ics.uci.edu/ml/datasets/Wine, column 1 is the class.
#This dataset is a multivariate dataset which could be used for classification analysis of three wine types: {1,2,3}
names(wined)=c('class','alc','malic','ash','alcalin','mg','phenol','flavan','nonflav','proanth','col.int','hue','diluted','prol')

wined= wined %>% mutate(class=as.factor(class)) #wine classes are originally coded as {1,2,3} numerics

#ggpairs(wined, aes(colour=class, alpha=.5)) #EXTREMELY slow with this dataset, but good to check for a quick overview to estimate important variables for discriminating wine types
#ggsave("Work/HW1/pairs.pdf") #the pairs plot is in the HW1 directory

## Plot 1 ~ Can wine be distinguished by its colour intensity and hue (referring to the variable in the dataset)? ##
# This dataset lends itself nicely to classification, so let's do some "visual" clustering (eyeballing).
# According to Gestalt Pyschology, your brain already has k-means clustering (or whichever more advanced method) built into it, and just by taking a glance, "Emergence" can quickly form regions of interest.
# Hence we can assign each class a different a different uniform. Our options are Hue, and Shape (angle). While hue ranks low generally, it is appropriate to use in this case since the colours are able to form a starker contrast against each other in the case of a scatterplot (I would argue).

plot1=(ggplot(
  data=wined,aes(x=col.int,y=hue,color=class))
    +geom_point(size=2,alpha=.6)
    +labs(title="Hue vs Colour Intensity Scatterplot", caption="Can wine conoisseurs tell a wine by looking at it?",x="Colour Intensity", y="Hue")
)
print(plot1)
#ggsave("Work/HW1/Plot1.pdf")

## Plot 2 ~ Examining importance of Proline content ##
# Here we will try and use the violin plot, and put a thinner boxplot within. While this does stuff a lot of info into one piece


#what if we took a continuous, factored it (pipes) and then took another two variables other than class

# continuous on y, factor on x, facet it, vs scatterplots, vs .... maybevilin/box for the side see the pairs

## Plot 3.1415 ~ The Coveted Pie Chart -- King of Uselessness, and Number 1 spot in "Top 10 Graphs I'd Eat" ##
# Here we can visualize the number of wines contained in each class in this dataset... largely useless, as pie-charts in general are.
temp=wined %>% 
  group_by(class) %>%
  summarise(count = length(class))

Pi= (ggplot(temp, aes(x="", y=count, fill=class))
  +geom_bar(width=1,stat="identity")
  #+geom_text(...)        #adding numbers to the graphic defeats the purpose, does it not? Why not just use a simple table then...
)
Pi+ coord_polar("y",start=0)
#the pi chart must be built out of the bar graph... interesting, too bad I'll never use it.
#Of course, that table given by "temp" is really all that's needed to convey this exact piece of information clearly, as the pie chart is impossible to distinguish.
#I won't be printing this to the repo for obvious reasons, but this stupid "joke" graph took me way longer than I anticipated, so I'm leaving it (it shows off some tidyverse piping).

## Citations ##
citation()
citation('tidyverse')
citation('ggplot2')
#Rauser, John. "How Humans See Data". Velocity Amsterdam 2016.