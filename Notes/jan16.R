#jan16
#lecture file is: stat744/lectures/principles_1.rmd
#information at the time of need refers to use legend when absolutely needed
#tufte boxplot may be going overload, dont always need so minimalist that it's too unclear
##ie. use gridlines maybe (feint) if it could help judge where things are
##dynamic graphics (where you can mouseover and read numbers) can replace gridlines

## DIRECT LABELS DOCUMENTATION FOR LABELLING GRAPHS IN NOTES ###

#figure out what is most imortant so it goes on the x

#Speed up large scatterplots by specifying
pch="." #using dots rather than circles is way faster

#once again, graph A is horrible b/c using bars when scale is achored and using log scale
#end of lecture notes, next practice

#banana example (see doebius link at end to his github)
library(readr)
library(dplyr)
library(ggplot2)

dd= (read_csv('data/banana.csv')
     %>% select(-c(Domain,Element,Item))
)

(ggplot(dd,aes(x=Year,y=Value,colour=Country)) #without colour specified get useless
  +geom_line()
  #+scale_y_continuous(breaks)
) #not very good yet

(ggplot(dd,aes(x=Year,y=Value,colour=Country))
  +geom_line()
  +scale_x_continuous(breaks=seq(1995,2005,by=2))
)

#what if we make year a factor? (not useful, but let's see)
dd= (read_csv('data/banana.csv')
     %>% select(-c(Domain,Element,Item))
     %>% mutate(fYear=factor(Year))
)
(ggplot(dd,aes(x=fYear,y=Value,colour=Country)) 
  +geom_line()
  #+scale_x_continuous(breaks=seq(1995,2005,by=2))
)
#here, country and year is also a factor, so every year,country combination is in its own group, each line only has one point, so nothing is drawn at all, the error message gives us a message to fix
#"geom_path: Each group consists of only one observation. Do you need to adjust the group aesthetic?"
#so we need to override this default
(ggplot(dd,aes(x=fYear,y=Value,
               colour=Country,
               group=Country))
  +geom_line()
  #+scale_x_continuous(breaks=seq(1995,2005,by=2))
) #about same as before

#back to what we were doing
library(directlabels) #wiil let us avoid legend and put labels directly on it
gg1= (ggplot(dd,aes(x=Year,y=Value,
               colour=Country,
               group=Country))
  +geom_line()
  +scale_x_continuous(breaks=seq(1995,2005,by=2))
)

direct.label(gg1+expand_limits(x=2010)) #names are crowded without using +expand limits
#x axis nice now, how about y? Let's try a log transformation
gg2= (ggplot(dd,aes(x=Year,y=Value,
                    colour=Country,
                    group=Country))
      +geom_line()
      +scale_x_continuous(breaks=seq(1995,2005,by=2))
      +scale_y_log10()
)
direct.label(gg2) #why are labels onthe left now???
#remember, if grey background is distracting, use different themes, such as:
#theme_bw #for example, or #theme_classic to get rid of grid lines
gg2+theme_bw() #this will print it with the respective theme

#going to fix y axis units so it's not 1e+04 (hard for some ppl apparently)
dd= (read_csv('data/banana.csv')
     %>% select(-c(Domain,Element,Item))
     %>% mutate(fYear=factor(Year),value_ktons=Value/1e3)
)
gg2= (ggplot(dd,aes(x=Year,y=value_ktons,
                    colour=Country,
                    group=Country))
      +geom_line()
      +scale_x_continuous(breaks=seq(1995,2005,by=2))
      +scale_y_log10()
      +labs(y="Kilotons of Bananas")
)
gg2+theme_bw()

#reordering labels, so it's not alphabetical
dd= (read_csv('data/banana.csv')
     %>% select(-c(Domain,Element,Item))
     %>% mutate(fYear=factor(Year),
                value_ktons=Value/1e3,
                Country=reorder(Country,-Value)) #reorder is a fn that defaults to using mean (read up), could order by max
)
#-Value since legend would be upside down then
gg2= (ggplot(dd,aes(x=Year,y=value_ktons,
                    colour=Country,
                    group=Country))
      +geom_line()
      +scale_x_continuous(breaks=seq(1995,2005,by=2))
      +scale_y_log10()
      +labs(y="Kilotons of Bananas")
)
gg2+theme_bw()

#class rushed at end, check posted notes for colour pallette change
#basically just add   +scale_colour_brewer(Palette="Dark2") into the ggplot object... for example
#check colour warnings sometimes may need library(RColourBrewer) for example