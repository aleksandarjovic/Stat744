### Homework 2: Why do we let doctors give our kids vaccines? Aleksandar Jovic. Jan 24, 2018 ###


#~Preamble~#
library(tidyverse) #loads magrittr, dplyr, readr, tidyr, purr, tibble, stringr, forcats, ggplot2
library(GGally)
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


theme_set(theme_bw())  #for my own plots
#~Time series~#
# We are looking at how numbers change with respect to time, while a time series may appear as a banal option to graphics high-society, it is certainly effective. In its simplicity and intuitive presentation, it can clealry deliver the data at a glance.
# Quick note on all these lines before we get started. I considered faceting the lines, but faceting 9 lines, keeping them all on the same line (for common y axis), ends up very squished.
# Looking at 9 lines on the same graph may look like one of those cereal box puzzles, but blowing the graph up on a larger screen alleviates a lot of the duress. So depends on time/place, but I left it unfaceted since I like looking at the multicoloured lines overlapping (even though I don't dislike 9 black and white graphs).

# Linear scale are simple, but natural for something like this.
ts=(ggplot()+
      geom_line(data=vac, aes(x=year,y=cases,colour=disease),pch=1.6)+ #size>1 makes the line look too fat? even 1.001.... Instead pch works much more efficiently?? What's the difference
      scale_x_continuous(breaks = seq(from=1945, to=2015, by = 5))+
      labs(title="Reported Cases of 9 Diseases from 1945-2015 with their Vaccine Implementation",x="Year",y="Cases",colour="Disease", shape="Disease")+ #to avoid two separate legend boxes
      geom_point(data=vac1, aes(x=year,y=cases,shape=disease,pch=5),colour='black')+ #same problem.. I can't altar size at all? So I use pch
      scale_shape_manual(values=c(15,16,17,18,3,4,11,13,8))+ #since ggplot wont do more than 6 automatically
      guides(size = FALSE)
)
print(ts)
#ggsave("Work/HW2/FullTimeSeries.pdf")
# Different shapes are used instead of just "dots" since some of the lines seem to overlap and it can get confusing which vaccine was implemented when.
# The colour is left default... 9 colours, ggplot evenly spaces the colours from the rainbow... perhaps this could be contrasted better?

# Measles was EXTREMELY contagious apparently, hence, it stretches the y-axis so it can fit, making the other lines harder to see
# Like I said earlier, 9 faceted graphs aleviates the issues of stretched graph, but let's see it without measles
nomeas= vac %>% filter(disease!='Measles')
nomeas1= nomeas %>% filter(vaccine!=FALSE)

ts1=(ggplot()+
      geom_line(data=nomeas, aes(x=year,y=cases,colour=disease),pch=1.6)+ 
      scale_x_continuous(breaks = seq(from=1945, to=2015, by = 5))+
      labs(title="Measles Omitted",caption="For clearer view at the other lines",x="Year",y="Cases",colour="Disease", shape="Disease")+ 
      geom_point(data=nomeas1, aes(x=year,y=cases,shape=disease,pch=5),colour='black')+ 
      scale_shape_manual(values=c(15,16,17,18,3,4,11,13))+ 
      guides(size = FALSE)
)
print(ts1)
#ggsave("Work/HW2/NoMeaslesTS.pdf")

# Let's see it faceted. It is very hard to see unless you have a big projector or monitor, but is helpful in viewing trends uncluttered.
#facts=(
#  ggplot()+
#      geom_line(data=vac, aes(x=year,y=cases,colour=disease),pch=1.6)+ 
#      scale_x_continuous(breaks = seq(from=1945, to=2015, by = 5))+
#      labs(title="Faceted look",x="Year",y="Cases")+
#      geom_point(data=vac1, aes(x=year,y=cases),colour='black')
#      #+facet_wrap(~disease,nrow=1)   #pick to sort by row or by col
#      #+facet_wrap(~disease,ncol=1)
#)
#print(facts)

#How about a log scale, since we're looking at the change of proportions over time.
tlog=(ggplot()+
      geom_line(data=vac, aes(x=year,y=log(cases),colour=disease),pch=1.6)+ #size>1 makes the line look too fat? even 1.001.... Instead pch works much more efficiently?? What's the difference
      scale_x_continuous(breaks = seq(from=1945, to=2015, by = 5))+
      labs(title="Log-Cases of 9 Diseases from 1945-2015 with their Vaccine Implementation",x="Year",y="Log Cases",colour="Disease", shape="Disease")+ #to avoid two separate legend boxes
      geom_point(data=vac1, aes(x=year,y=log(cases),shape=disease,pch=5),colour='black')+ #same problem.. I can't altar size at all? So I use pch
      scale_shape_manual(values=c(15,16,17,18,3,4,11,13,8))+ #since ggplot wont do more than 6 automatically
      guides(size = FALSE)
)
print(tlog)
#ggsave("Work/HW2/logTS.pdf")


#Could also compare each graph proportionally by looking at the data as a percentage of the maximum number of cases recorded. This scaling method would be tedious, but I'll show how I would pipe it to make this possible:

vac2=vac #for use later in my for loop since I can't do this with pipes

#First, find the max... let's say of chickenpox:
vac %>%
  filter (disease=="Chickenpox") %>%
  summarize (maxCP=max(cases))->maxCP;maxCP
#Now make chickenpox cases go on a scale from 0 to 1... repeat for the rest and we can compare percentage of cases
#!!! Here is where I need help. I tried many ways to do this in a pipe !!!
# data %>% filter (condition) "WITHOUT LOSING MY OTHER DATA" %>% mutate (something specific)
#example: vac%>% filter (disease=="Chickenpox") %>% mutate (cases=cases/maxCP)
#instead, a for loop:

for(i in 1:length(vac$cases)) {
  if (vac$disease[i]=="Chickenpox") (vac2$cases[i]=vac$cases[i]/maxCP)
}
#now let's do the rest
vac %>%
  filter (disease=="Diphtheria") %>%
  summarize (temp=max(cases))->temp
for(i in 1:length(vac$cases)) {
  if (vac$disease[i]=="Diphtheria") (vac2$cases[i]=vac$cases[i]/temp)
}
vac %>%
  filter (disease=="Pertussis") %>%
  summarize (temp=max(cases))->temp
for(i in 1:length(vac$cases)) {
  if (vac$disease[i]=="Pertussis") (vac2$cases[i]=vac$cases[i]/temp)
}
vac %>%
  filter (disease=="Polio") %>%
  summarize (temp=max(cases))->temp
for(i in 1:length(vac$cases)) {
  if (vac$disease[i]=="Polio") (vac2$cases[i]=vac$cases[i]/temp)
}
vac %>%
  filter (disease=="Measles") %>%
  summarize (temp=max(cases))->temp
for(i in 1:length(vac$cases)) {
  if (vac$disease[i]=="Measles") (vac2$cases[i]=vac$cases[i]/temp)
}
vac %>%
  filter (disease=="Mumps") %>%
  summarize (temp=max(cases))->temp
for(i in 1:length(vac$cases)) {
  if (vac$disease[i]=="Mumps") (vac2$cases[i]=vac$cases[i]/temp)
}
vac %>%
  filter (disease=="Rubella") %>%
  summarize (temp=max(cases))->temp
for(i in 1:length(vac$cases)) {
  if (vac$disease[i]=="Rubella") (vac2$cases[i]=vac$cases[i]/temp)
}
vac %>%
  filter (disease=="Hepatitis B") %>%
  summarize (temp=max(cases))->temp
for(i in 1:length(vac$cases)) {
  if (vac$disease[i]=="Hepatitis B") (vac2$cases[i]=vac$cases[i]/temp)
}
vac %>%
  filter (disease=="Hepatitis A") %>%
  summarize (temp=max(cases))->temp
for(i in 1:length(vac$cases)) {
  if (vac$disease[i]=="Hepatitis A") (vac2$cases[i]=vac$cases[i]/temp)
}
vac2support= (vac2 %>%
         filter(vaccine!=FALSE)
)
# WHY DO I NEED TO UNLIST() MY Y VARIABLE "cases" NOWW!??!??!! #https://stackoverflow.com/questions/29459866/ggplot2-error-geom-point-requires-the-following-missing-aesthetics-y
# Hello 4am, my old friend...
prov=(ggplot()+
           geom_line(data=vac2, aes(x=year, y=unlist(cases), colour=disease),pch=1.6)+ #size>1 makes the line look too fat? even 1.001.... Instead pch works much more efficiently?? What's the difference
           scale_x_continuous(breaks = seq(from=1945, to=2015, by = 5))+
           scale_y_continuous(limits=c(0,1))+
           labs(title="Proportional Cases of 9 Diseases from 1945-2015 with their Vaccine Implementation",x="Year",y="Proportion of Max Cases",colour="Disease", shape="Disease")+ #to avoid two separate legend boxes
           geom_point(data=vac2support, aes(x=year, y=unlist(cases), shape=disease,pch=5),colour='black')+ #same problem.. I can't altar size at all? So I use pch
           scale_shape_manual(values=c(15,16,17,18,3,4,11,13,8))+ #since ggplot wont do more than 6 automatically
           guides(size = FALSE)
)
print(prov)
#ggsave("Work/HW2/ProportionalTS.pdf")
# EXTREMELY hard to see due to all the lines there. This is where modern technology of hiding/showing particular lines at will would be nice... Let's just facet this, a fair trade off to get a clearer picture.
print(prov+facet_wrap(~disease))
#ggsave("Work/HW2/facetedPropTS.pdf")
# Note, this is similar to the previous facet which we didn't print, it'll be the same thing however, just with all the cases on a 0 to 1 scale (show's the same picture)


##Time series with vaccine shown as center. Let's see how "Years since first vaccine implemented" makes things look.
cent=vac
for(i in 1:length(vac$cases)) {
  if (vac$disease[i]=="Diphtheria") (cent$year[i]=vac$year[i]-1947) #value just read from vac1 (crude)
}
for(i in 1:length(vac$cases)) {
  if (vac$disease[i]=="Pertussis") (cent$year[i]=vac$year[i]-1949) #value just read from vac1 (crude)
}
for(i in 1:length(vac$cases)) {
  if (vac$disease[i]=="Polio") (cent$year[i]=vac$year[i]-1955) #value just read from vac1 (crude)
}
for(i in 1:length(vac$cases)) {
  if (vac$disease[i]=="Measles") (cent$year[i]=vac$year[i]-1963) #value just read from vac1 (crude)
}
for(i in 1:length(vac$cases)) {
  if (vac$disease[i]=="Mumps") (cent$year[i]=vac$year[i]-1967) #value just read from vac1 (crude)
}
for(i in 1:length(vac$cases)) {
  if (vac$disease[i]=="Rubella") (cent$year[i]=vac$year[i]-1969) #value just read from vac1 (crude)
}
for(i in 1:length(vac$cases)) {
  if (vac$disease[i]=="Hepatitis B") (cent$year[i]=vac$year[i]-1981) #value just read from vac1 (crude)
}
for(i in 1:length(vac$cases)) {
  if (vac$disease[i]=="Hepatitis A") (cent$year[i]=vac$year[i]-1995) #value just read from vac1 (crude)
}
for(i in 1:length(vac$cases)) {
  if (vac$disease[i]=="Chickenpox") (cent$year[i]=vac$year[i]-1995) #value just read from vac1 (crude)
}
# With all of our data centered now around year since first vaccine implemented, we could repeat the whole process. (but won't)
# Let's see the plain graph, note, no extra points required this time, but we the information of the year itself (are newer vaccines better?)
cents=(
  ggplot(data=cent)+
    geom_line(aes(x=year,y=cases,colour=disease))+
    geom_vline(xintercept=0, colour='black',alpha=0.3)+
    labs(title="Time Series Centred around First Respective Vaccine",x="Years since First Vaccine",y="Cases")
)
print(cents) #Again, we suffer from some clutter (9 lines are the main issue, and stretch of Measles... perhaps try this with 0 to 1 scale?)
#ggsave("Work/HW2/BasicCentred.pdf")

#Once again, let's see this with log, a good scale for proportional change
logcents=(
  ggplot(data=cent)+
    geom_line(aes(x=year,y=log(cases),colour=disease))+
    geom_vline(xintercept=0, colour='black',alpha=0.3)+
    labs(title="Time Series Centred around First Respective Vaccine (Log)",x="Years since First Vaccine",y="Log Cases")
)
print(logcents)
#ggsave("Work/HW2/LogCentred.pdf")





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