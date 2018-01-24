### Homework 2: Why do we let doctors give our kids vaccines? Aleksandar Jovic. Jan 24, 2018 ###


#~Preamble~#
library(tidyverse) #loads magrittr, dplyr, readr, tidyr, purr, tibble, stringr, forcats, ggplot2
library(GGally)
#theme_set(theme_bw())  #??? we'll see how things look
# Comments justifications will be posted in this document, and the .Rmd


#~Dataset~#
datraw=readr::read_csv("https://bbolker.github.io/stat744/data/vaccine_data_online.csv") #see references for sourced article
vac=datraw[,2:5]   #filtering out what I don't need

#Some oddities with the data:
#1. Mumps had 0 recorded cases at the inception of the vaccine. Were they just not recording it before the creation of the vaccine? Unlikely. We could impute this by setting the value to some value based on the expected growth from the next 5 years (regression backwards).
#2. Hepatitis' A and B, and Polio have two vaccine inceptions. (Again going with the idea that we're comparing vaccine effectiveness, while not every vaccine is made the same, nor is it for the same disease -- however the overall idea is fine)
#3. Pertussis seems to have a resurgence after the mid-80s (perhaps vaccine was distributed less, perhaps it became less effective).
#4. As stated on the website: "*Chickenpox data were not reported by all states between 1981 and 2003."

vac1= (vac %>%
         filter(vaccine!=FALSE)
) #creates new mini version of data which will let me easily plot specifically the vaccine implementations
# I thought about putting it in the vac as it's own column, but vac2= vac %>% mutate(vacd= ) wasn't sure how to use the vaccine!=FALSE condition there


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
# ggsave("Work/HW2/Replicate.pdf")  #Saved to the /HW2 directory already

# Using AREA rather than RADIUS (since radius grows by a squared factor -- misleading)
# Diseases are arranged alphabetically, because why not in this case. Each disease is vastly different, as is its respective vaccine. I'll be getting into this later however for a better comparison.
# Rather than specifying a new column which contains that data, then adding a new layer which recolours that specific point with the orange, is there a way to have the data chosen conditionally? some sort of 'if' statement. Perhaps something like this geom_point(data= x$vaccine!=FALSE ...) ... unsure where to take this.

# Note, I piped vac1 after I wrote the spaghetti version of my replica. I used it to add the layer with the black dots, but couldn't use it to create the blue and orange separately -- see the below commented out code.
# When I tried to add separate layers (to avoid the blue parts getting too overlapped and hard to see, so I could only make the orange part more opaque), I got very weird colours... Like not at all the same???
#failedreplica=(ggplot()+ 
#           geom_point(data=vac,aes(x=disease,y=year,size=cases,colour="skyblue"),alpha=0.25)+
#           geom_point(data=vac1,aes(x=disease,y=year,size=cases,colour="goldenrod"),alpha=.9)+ #NEW LINE HERE, THE LINE UNDERNEAT HIS COMMENTED OUT
#           #scale_color_manual(values = c(rep("goldenrod", 5),"skyblue3",rep("goldenrod", 7)))+ 
#           labs(title="Replication of Jia You's Vaccine Graph",x="Disease", y="Year")+
#           guides(colour = FALSE)+ # removes from legend
#           labs(size='Cases Recorded')+
#           theme(legend.position = "bottom")+
#           scale_y_reverse(breaks = seq(from=2015, to=1945, by = -5))+ #traditionally, I feel that climbing indicates years advancing (arbitrary cultural convention), but set this up to match author
#           scale_size_area(max_size = 20)+ #scaling by size AREA, but adding a bit of meat to the max size so the dots are easier to distinguish (much like the), this also ensures values of 0 take an area of 0.
#           geom_point(data=vac1,aes(x=disease,y=year,size=5),colour='black') #for whatever reason, this final layer, warped my legend, making the circles full black... which is fine since thelegend just helps with understanding how area represents number of cases... id say this is acceptable.
#)
#print(failedreplica)


#~Time series~#
# We are looking at how numbers change with respect to time, while a time series may appear as a banal option to graphics high-society, it is certainly effective. In its simplicity and intuitive presentation, it can clealry deliver the data at a glance.
ts=(ggplot()+
      geom_line(data=vac, aes(x=year,y=cases,colour=disease),pch=1.3)+ #size>1 makes the line look too fat? even 1.001.... Instead pch works much more efficiently?? What's the difference
      scale_x_continuous(breaks = seq(from=1945, to=2015, by = 5))+
      labs(title="Reported Cases of 9 Diseases from 1945-2015 with their Vaccine Implementation",x="Year",y="Cases",colour="Disease", shape="Disease")+ #to avoid two separate legend boxes
      geom_point(data=vac1, aes(x=year,y=cases,shape=disease,pch=5),colour='black')+ #same problem.. I can't altar size at all? So I use pch
      scale_shape_manual(values=c(15,16,17,18,3,4,11,13,8))+ #since ggplot wont do more than 6 automatically
      guides(size = FALSE)
)
print(ts)
#ggsave("Work/HW2/FullTimeSeries.pdf")
#Different shapes are used instead of just "dots" since some of the lines seem to overlap and it can get confusing which vaccine was implemented when.

#Measles was EXTREMELY contagious apparently, hence, it stretches the y-axis so it can fit, making the other lines harder to see
nomeas= vac %>% filter(disease!='Measles')
nomeas1= nomeas %>% filter(vaccine!=FALSE)

ts1=(ggplot()+
      geom_line(data=nomeas, aes(x=year,y=cases,colour=disease),pch=1.3)+ #size>1 makes the line look too fat? even 1.001.... Instead pch works much more efficiently?? What's the difference
      scale_x_continuous(breaks = seq(from=1945, to=2015, by = 5))+
      labs(title="Measles Omitted",caption="For clearer view at the other lines",x="Year",y="Cases",colour="Disease", shape="Disease")+ #to avoid two separate legend boxes
      geom_point(data=nomeas1, aes(x=year,y=cases,shape=disease,pch=5),colour='black')+ #same problem.. I can't altar size at all? So I use pch
      scale_shape_manual(values=c(15,16,17,18,3,4,11,13))+ #since ggplot wont do more than 6 automatically
      guides(size = FALSE)
)
print(ts1)
#ggsave("Work/HW2/NoMeaslesTS.pdf")

##Time series with vaccine shown as center

##How effective are vaccines? graphing rate of change (cut off until start of vaccine?) faster decrease is better.
#if we're looking at effectiveness, is the "before" really as important?
#mutate with diff()


#~Discussion~#
#pros and cons of graph. Area gives quick overview really easily, but is it misleading? The overlap of the bubbles can fool the eye.
#The time series often shows downward trends before the vaccine's implementation... One might argue the decrease of the disease due to concentrated effort by physicians to combat disease, and vaccine being implemented during that downhill slope is spurious information.


#?????????????????????????extra credit hypothetical... i.e. creation of chart, and how to use data


## Citations ##
citation()
citation('tidyverse') #et al. {magrittr, dplyr, readr, tidyr, purr, tibble, stringr, forcats, ggplot2}
citation('GGally')
#You, Jia. "Here’s the visual proof of why vaccines do more good than harm". www.sciencemag.org. April 27, 2017.


# To answer the title (which was intentionally flippant towards anti-vaxxers), we use vaccines because they work (as seen in the selected data above).