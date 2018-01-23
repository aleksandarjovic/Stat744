### HW2 ###

library(tidyverse) #loads magrittr, dplyr, readr, tidyr, purr, tibble, stringr, forcats, ggplot2
library(GGally)
#theme_set(theme_bw())  #??? we'll see how things look

x=readr::read_csv("https://bbolker.github.io/stat744/data/vaccine_data_online.csv")

#Reproducing original graph, for exercise, not that I'm feeling particularly uncreative.
plot1=(ggplot(data=x,aes(x=disease,y=year,size=cases))+
         geom_point(colour='skyblue3',alpha=0.5)+
         scale_y_reverse()+ #just to match, traditionally, I feel that climbing indicates years advancing (arbitrary cultural convention)scale_y_reverse()+
         #scale_size_area()+ #this thins it out? what is this??
         labs(title="Replication of Jia You's Vaccine",x="Disease", y="Year")#+
         #add in specific events?? remove colour and colour the event
         #legend needs fixing
)
print(plot1)
#ggsave("Work/HW2/Replicate.pdf")
# Using AREA rather than RADIUS (since radius grows by a squared factor -- misleading)


##Time series (simple but most natural, no reason to overcomplicate)

##Time series with vaccine shown as center

##How effective are vaccines? graphing rate of change (cut off until start of vaccine?) faster decrease is better.


#extra credit hypothetical... i.e. creation of chart, and how to use data


## Citations ##
citation()
citation('tidyverse') #et al. {magrittr, dplyr, readr, tidyr, purr, tibble, stringr, forcats, ggplot2}
citation('GGally')
#You, Jia. "Here’s the visual proof of why vaccines do more good than harm". www.sciencemag.org. April 27, 2017.