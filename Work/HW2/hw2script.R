### Homework 2: Why do we let doctors give our kids vaccines? Aleksandar Jovic. Jan 24, 2018 ### I'm still working on R markdowns, so I'll put all comments in here for now.


#~Preamble~#
library(tidyverse) #loads magrittr, dplyr, readr, tidyr, purr, tibble, stringr, forcats, ggplot2
library(GGally)


#~Discussion~# Since this is lengthy, I'll put this at the top.
# + vs - of Jia's graph:
# At a glance, it looks great. Everyone can see the bubbles shrinking into nothingness as the years advance, at SOME point after the orange dot (vaccine).
# Her graph is relatively uncluttered, but I have some issues with it:
# There is no x-axis, year (independent variable typically), is listed DOWN the y-axis (opposite of convention), typically when something advances forward (like time) it is culturally associated as going up.
# The bubbles rely on area, and while she doesn't use radius (correctly), the bubbles still overlap, and it becomes hard to differentiate. This is especially bad, since it appears to mask the fact that the bubbles beging to shrink BEFORE the first orange circle is present (cases decreasing BEFORE vaccine implemented??).
# Her diseases seem to be spread sporadically (again, no intuitive x-axis), but it is nice that everything fits on a common y-axis (year).

# My suggestions:
# We have a physical number changing over time... This lends itself PERFECTLY to a time series (line graph with time on x).
# In this case, lines (angles) are better on the gestalt heirarchy (Rauser). To remedy that there are 9 different diseases, we can plot everything on the same plot using hue (separating wavelength evenly), or alternatively use facets.
# Keeping everything on one graph gives aligned and common axes, which is a huge plus.
# One issue was measles had a huge number of cases, causing the y-axis to be stretched (making it hard to differentiate the other lines: 45 degree rule). I tried seeing how transforming cases into a (0,1) would look (Percentage of cases, compared to the max). This loses magnitude, but allows us to compare vaccine effectiveness by looking at proportional change over time as well.
# The lines also make trends easier to see. I plotted the vaccine implementation onto the graphs to see how the line changes after the vaccine.
# Log scale for the number of cases also help to see how things change proportionally over time, so I showed that to compare.
# I was then curious to see what would happen if we put ALL the diseases centred around their first vaccine. Since we're looking to see how vaccines affect disease growth, it would be good to compare them like that (since we're already comparing apples and oranges figuratively: Different diseases AND vaccines are very different).
# While this does lose the information of when the vaccine was created, it keeps things on a common axis, and let's us see things from a new perspective.
# Finally, I was interested in seeing how the RATE OF CHANGE graph would look, since that was implied by the goal of the original document.


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
           geom_line(data=vac2, aes(x=year, y=unlist(cases), colour=disease),pch=1.6)+
           scale_x_continuous(breaks = seq(from=1945, to=2015, by = 5))+
           scale_y_continuous(limits=c(0,1))+
           labs(title="Proportional Cases of 9 Diseases from 1945-2015 with their Vaccine Implementation",x="Year",y="Proportion of Max Cases",colour="Disease", shape="Disease")+ 
           geom_point(data=vac2support, aes(x=year, y=unlist(cases), shape=disease,pch=5),colour='black')+ 
           scale_shape_manual(values=c(15,16,17,18,3,4,11,13,8))+ 
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
  if (vac$disease[i]=="Pertussis") (cent$year[i]=vac$year[i]-1949) 
}
for(i in 1:length(vac$cases)) {
  if (vac$disease[i]=="Polio") (cent$year[i]=vac$year[i]-1955) 
}
for(i in 1:length(vac$cases)) {
  if (vac$disease[i]=="Measles") (cent$year[i]=vac$year[i]-1963)
}
for(i in 1:length(vac$cases)) {
  if (vac$disease[i]=="Mumps") (cent$year[i]=vac$year[i]-1967) 
}
for(i in 1:length(vac$cases)) {
  if (vac$disease[i]=="Rubella") (cent$year[i]=vac$year[i]-1969)
}
for(i in 1:length(vac$cases)) {
  if (vac$disease[i]=="Hepatitis B") (cent$year[i]=vac$year[i]-1981) 
}
for(i in 1:length(vac$cases)) {
  if (vac$disease[i]=="Hepatitis A") (cent$year[i]=vac$year[i]-1995) 
}
for(i in 1:length(vac$cases)) {
  if (vac$disease[i]=="Chickenpox") (cent$year[i]=vac$year[i]-1995)
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
#This graph appeals to me. Similar to Jia You's graph, the cluttered mess appears to be down-trending as a whole, which is the desired impression we're looking to give. (I say that, because although I agree vaccines work, we can play around with the data all sorts of ways to get an effect). That being said, Using a log scale is an honest choice, and centering the information at the first year of the vaccine is also an honest choice to see if things change (before/after comparison).


#~Rate of Change~#   ***Disclaimer: I have no idea if this worked out the way I wanted it to. Without a smooth curve, derivatives may be a futile idea, but I think it worked to an extent... let me know ***
# The final thing I'd like to look at is the rate of change. Since we're looking to see if vaccines are effective, growth (or negative growth in this case) is important, so taking the derivative (or difference in R's case) and plotting this directly could be of interest.
# As inspired by Rauser's segment on population growth of continents:
# We can get our derivative using the following piping (using R's difference function to estimate the derivative... is there a better way built in?)
deriv = vac %>%
  group_by(disease) %>%
  arrange(year) %>%
  mutate(change=c(NA,diff(cases)))

#Let's plot our rate of change time series
ratets=ggplot(deriv, aes(year, change/cases, group=disease, colour=disease))+
  geom_line()+labs(title="Rate of change of vaccines",y="dy/dx")
print(ratets)
#I won't be printing this one because:
#1. It looks like quite the mess, however, values are generally negative, implying vaccines work... BUT
#2. Where is the reference point of the vaccines start? Is it just a placebo, or do they work. Let's do the same thing, but with our centered data:

deriv = cent %>%
  group_by(disease) %>%
  arrange(year) %>%
  mutate(change=c(NA,diff(cases)))

ratets=ggplot(deriv, aes(year, change/cases, group=disease, colour=disease))+
  geom_line()+labs(title="Rate of change of Cases from the First Year of Vaccine",y="dy/dx",x="years from first vaccine")+geom_vline(xintercept=0, colour='black',alpha=0.3)
print(ratets)
#ggsave("Work/HW2/Derivative.pdf")
#And now we have a noisy mess, but with a frame of reference. We see that generally vaccines appear to cause a downward trend in cases. The noise seems to bounce strongly off the line into the negative direction when compared with the years BEFORE the vaccine. Interestingly, not a single increase.
#Not a single increase.... even before the vaccine was implemented.... While we know vaccines work (according to science), did Jia You pick the most honest way to portray her data? Based on her conclusion, I would say there are some points of contention.
# I would have expected the noise to be spiking in the positive direction BEFORE vaccines, and back into the negative direction AFTER.


#Extra credit: Sadly, I couldn't find this information. I specifically looked for Pertussis since it is the disease that appeared to make a resurgence.
#I was curious to see if I could plot the levels of Pertussis against the coverage (as coverage dipped, Pertussis would increase)... but for another time perhaps.


## Citations ##
citation()
citation('tidyverse') #et al. {magrittr, dplyr, readr, tidyr, purr, tibble, stringr, forcats, ggplot2}
citation('GGally')
#You, Jia. "Here’s the visual proof of why vaccines do more good than harm". www.sciencemag.org. April 27, 2017.

# To answer the title (which was intentionally flippant towards anti-vaxxers), we use vaccines because they work. While this data doesn't show the whole picture, it does show most of it, and we can use this data to create effective graphs which demonstrate the original thesis.