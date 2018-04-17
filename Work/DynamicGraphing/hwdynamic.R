#interactive graphics exercise
library(tidyverse)
library(ggvis)

##motion graphs##
#using the disease data: perhaps not best suited since not enough continuous covariates... so end up reusing x axis as the time and y axis as the cases.
#a bit redundant, the size of the dot moves left to right and shrinks in size, falling down (both of those representing the same thing)
datraw=readr::read_csv("https://bbolker.github.io/stat744/data/vaccine_data_online.csv") #see references for sourced article
vac=datraw[,2:5]  

motionex <- gvisMotionChart(vac, 
                           idvar="disease",
                           timevar="year",
                           xvar="year",
                           yvar="cases",
                           sizevar = "cases",
                           colorvar = "disease")
                           #options=list(colors="['#fff000', '#123456','#cbb69d']"))
plot(motionex)
#if we had more continuous variables, we could mix and match as desired like in the example presented in fruits (where we put revenue/cost on the y/x axes and let time show the number of fruits sold)



##ggvis with the mtcars data##

y=mtcars
y=y%>% mutate(car=rownames(mtcars))
#oddly the rownames aren't column 1, so we mutate that in
#suppose we only want energy efficient brands
y=y%>% filter(mpg>25)

x=data.frame(car=y[,12],
             hp=y[,4],
             wt=y[,6])
bar1 <- gvisBarChart(x)
plot(bar1)
column1 <- gvisColumnChart(x)
plot(column1)

#clearly putting these on a common scale doesn't achieve much, but it's possible, if we just want to see raw values
#perhaps we standardize it first then plot
y=mtcars
y=y%>% mutate(car=rownames(mtcars),
              hp1=(hp-mean(hp))/sd(hp),
              wt1=(wt-mean(wt))/sd(wt))

#let's do it in a neater way without creating a new data frame
bar1 <- gvisBarChart(data=y,xvar='car',yvar=c('hp1','wt1'))
plot(bar1)
column1 <- gvisColumnChart(data=y,xvar='car',yvar=c('hp1','wt1'))
plot(column1)

#column char looks nicer, let's filter out the inefficient cars and rerun it
y=y%>% filter(mpg>25)
bar1 <- gvisBarChart(data=y,xvar='car',yvar=c('hp1','wt1'))
plot(bar1)
column1 <- gvisColumnChart(data=y,xvar='car',yvar=c('hp1','wt1'))
plot(column1)
#as expected, lower weight, but also a trade off of horsepower. c'est la vie.