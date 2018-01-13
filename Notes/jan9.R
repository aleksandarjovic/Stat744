#jan9
#library(readr)
#library(dplyr)
library(tidyverse)
library(ggplot2)
#theme_set(theme_bw()) can set theme to ggplot if you dont like their default colours, or find something that you like her
#setwd('~/Documents/stat744') #need to make this work
cdat=read_csv('data/Carbohydrate_diet.csv')
print(cdat,n=8) #to get top 8 rows , similar to head(cdat) ?

#now to create ggplot
gg0={
  ggplot(cdat,
             aes(weight,carboydrate))
      +geom_point()       #will not create graph if this line not added since no layers creatged
}
#print(gg0) without the +geom_point will just put up a graph since that object is created without the layers
print(gg0 + geom_smooth(method='loess')
          + geom_smooth(method='lm',col='red')) #adds that least squares regression thing?
cdat=mutate(cdat,f_age=cut_number(age,3)) #cut_number breaks continuous age into categorical variable by somewhat equally spaced bins

gg1={
  ggplot(cdat,aes(weight,carbohydrate,colour=f_age))
 + geom_point(aes(shape=f_age),size=4)
}
#print(gg1)   #will make a plot with 3 different points to visualize it by splitting the original set into bins

print(gg1+geom_smooth(method='lm', aes(group=1)))
print(gg1+geom_smooth(method='lm')+facet_wrap(~f_age))

gg2=(ggplot(cdat,
           aes(f_age,carbohydrate))
+geom_boxplot()
)

print(gg2+
        geom_point(alpha=0.3)) #alpha channel is transparency [0,1]

###opening new dataset now
library(mlmRev) #it's in this package, for contraception use in bangladesh 1988
gg0= (ggplot(Contraception,aes(age,use))
      + stat_sum(alpha=0.4))
print(gg0)
print(gg0+stat_sum())

(Contraception
  %>% group_by(age,urban)
  %>% summarise(
    prop=mean(as.numeric(use)-1), #turns use into 1s and 2s, then -1 so you get 0 and 1
  n=n(),
  se=sqrt(prop*(1-prop)/n))
  ) -> contr_sum

(ggplot(contr_sum, aes(age,prop,colour=urban))+
geom_point(aes(size=n))+
geom_linerange(aes(ymin=prop-se,ymax=prop+se))+
scale_colour_brewer(palette="Dark2"))