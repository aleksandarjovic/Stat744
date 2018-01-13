#jan8
#outliers for boxplot may not be outliers statistically

#c2f some imaginary fn. here's traditional idea
x2=x[,x$temp>7]
x3=x2[,c('temp','precip')]
x4$temp=c2f(x$temp)

#vs tidyverse version
{
x
  %>% filter(temp>7)
  %>% select(temp,precip)
  %>% mutate(temp=c2f(temp)} -> newx
  
#tibbles

#ggplot2 grammar of graphcis
#find data directory for class
ggplot(data=d,aes(x=age,y=weigt)) +
  geo_point() #in gg plot, need to keep adding layers to it
#for example
gg0=ggplot(data=dd,aes(x=age,y=weigt))
gg0+geom_point()+geom_line()
gg0+geom_point()+geom_line()+geom_smooth()

