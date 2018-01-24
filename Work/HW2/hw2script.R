### Homework 2: So why do we let doctors give our kids vaccines? Aleksandar Jovic. Jan 24, 2018 ###

library(tidyverse) #loads magrittr, dplyr, readr, tidyr, purr, tibble, stringr, forcats, ggplot2
library(GGally)
#theme_set(theme_bw())  #??? we'll see how things look

datraw=readr::read_csv("https://bbolker.github.io/stat744/data/vaccine_data_online.csv")
vac=datraw[,2:5]   #filtering out what I don't need

vac1= (vac %>%
         filter(vaccine!=FALSE)
) #creates new mini version of data which will let me easily plot specifically the vaccine implementations

# Comments justifications will be posted below, and into the .Rmd

#~ Reproducing original graph, for exercise, not that I'm feeling particularly uncreative. ~#
replica=(ggplot()+ 
         geom_point(data=vac,aes(x=disease,y=year,size=cases,colour=vaccine),alpha=0.35)+
         scale_color_manual(values = c(rep("goldenrod", 5),"skyblue3",rep("goldenrod", 7)))+ #checking table(x$vaccine) shows the non-vaccine dates are 6th inthe list, see below for what I tried to get working, as I recognize this is a bit spaghetti-code-ish in its current iteration
         labs(title="Replication of Jia You's Vaccine Graph",x="Disease", y="Year")+
         guides(colour = FALSE)+ # removes uselss part from legend
         labs(size='Cases Recorded')+ #more informative
         #theme(legend.position = "bottom")+ #less squish horizontally, however, I opted to leave this back as default, less squish vertically makes it easier to differentiate the circle (less overlap), and the horizontal wasnt in trouble ever anyway
         scale_y_reverse(breaks = seq(from=2015, to=1945, by = -5))+ #traditionally, I feel that climbing indicates years advancing (arbitrary cultural convention), but set this up to match author
         scale_size_area(max_size = 20)+ #scaling by size AREA, but adding a bit of meat to the max size so the dots are easier to distinguish (much like the), this also ensures values of 0 take an area of 0.
         geom_point(data=vac1,aes(x=disease,y=year,size=5),colour='black')+ #for whatever reason, this final layer, warped my legend, making the circles full black... which is fine since thelegend just helps with understanding how area represents number of cases... id say this is acceptable.
         theme(axis.text.x = element_text(size=6.2)) #so the labels donotverlap ... very confusing and ugly
)
print(replica)
#ggsave("Work/HW2/Replicate.pdf")

# note, I piped vac1 after I wrote the spaghetti version of my replica. It helped me add the dots
# Using AREA rather than RADIUS (since radius grows by a squared factor -- misleading)
# Diseases are arranged alphabetically, because why not in this case. Each disease is vastly different, as is its respective vaccine. I'll be getting into this later however for a better comparison.
# I tried passing the following argument to pinpoint the vaccine dates and colour them differently data= x$vaccine!=FALSE ... I deleted what I was trying, but it was also a mess.
# Rather than specifying a new column which contains that data, then adding a new layer which recolours that specific point with the orange, is there a way to have the data chosen conditionally? some sort of 'if' statement seems like it could do the trick?

#Note, when I tried to add separate layers (to avoid the blue parts getting too overlapped and hard to see, so I could only make the orange part more opaque), I got very weird colours... Like not at all the same???
#replica=(ggplot()+ 
#           geom_point(data=vac,aes(x=disease,y=year,size=cases,colour="skyblue"),alpha=0.25)+
#           geom_point(data=vac1,aes(x=disease,y=year,size=cases,colour="goldenrod"),alpha=.9)+ #NEW LINE HERE, THE LINE UNDERNEAT HIS COMMENTED OUT
#           #scale_color_manual(values = c(rep("goldenrod", 5),"skyblue3",rep("goldenrod", 7)))+ #checking table(x$vaccine) shows the non-vaccine dates are 6th inthe list, see below for what I tried to get working, as I recognize this is a bit spaghetti-code-ish in its current iteration
#           labs(title="Replication of Jia You's Vaccine Graph",x="Disease", y="Year")+
#           guides(colour = FALSE)+ # removes from legend
#           labs(size='Cases Recorded')+
#           theme(legend.position = "bottom")+
#           scale_y_reverse(breaks = seq(from=2015, to=1945, by = -5))+ #traditionally, I feel that climbing indicates years advancing (arbitrary cultural convention), but set this up to match author
#           scale_size_area(max_size = 20)+ #scaling by size AREA, but adding a bit of meat to the max size so the dots are easier to distinguish (much like the), this also ensures values of 0 take an area of 0.
#           geom_point(data=vac1,aes(x=disease,y=year,size=5),colour='black') #for whatever reason, this final layer, warped my legend, making the circles full black... which is fine since thelegend just helps with understanding how area represents number of cases... id say this is acceptable.
#)
#print(replica)



##Time series (simple but most natural, no reason to overcomplicate)

##Time series with vaccine shown as center

##How effective are vaccines? graphing rate of change (cut off until start of vaccine?) faster decrease is better.
#if we're looking at effectiveness, is the "before" really as important?
#mutate with diff()


#extra credit hypothetical... i.e. creation of chart, and how to use data


## Citations ##
citation()
citation('tidyverse') #et al. {magrittr, dplyr, readr, tidyr, purr, tibble, stringr, forcats, ggplot2}
citation('GGally')
#You, Jia. "Here’s the visual proof of why vaccines do more good than harm". www.sciencemag.org. April 27, 2017.

# To answer the title (which was purposely mocking anti-vaxxers), we use vaccines because they work.