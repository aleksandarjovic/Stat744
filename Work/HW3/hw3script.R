### Homework 4 (3*): Finding a way to make a chart into a useful graph.  Aleksandar Jovic. Feb 15, 2018 ###
#One note, the graphs are best viewed on full screen, as the pdf they're currently uploaded as shows a bit of overlap/compression in the graphs.


#~Preamble~#    (taken complete from note)
## graphics
library(ggplot2)
theme_set(theme_bw())#+theme(panel.spacing=grid::unit(0,"lines")))
library(directlabels)
## modeling/coef plots
library(lme4)
library(broom)
library(dotwhisker)
library(ggstance) ## horizontal geoms
library(stargazer)
## manipulation
library(tidyr)
library(dplyr)
library(purrr)
library(readr)


#~Dataset~#
x1=read_csv('Data/POCIS_Raw_McCallum.csv') #McCallum et al (2017). Full citation below
x1=x1[,-c(1,2)] #we don't need the ID nor the sampler type (All are polar organic chemical integrative samplers)
x2=read_csv('Data/POCIS_support.csv') #to get some more informative column names


#I found that the way this dataset is currently set up doesn't really work well with the ggplot
#I put the drugs in their own column, rather than having 24 columns of different drugs (also, I have the respective drug categories added into the table) 

vert=(
  x1 %>%
    gather(drug,conc,CFN:PPN) %>%
    full_join(x2,by=c("drug"="abbr"))
)

#some pesky NA rows existing for sites, were these drugs never tested for? They have no concentration measurements.
vert=vert%>%filter(!is.na(Site))  #this takes care of a lot of problems (removing empty columns, and multiple empty charts)


#~General Discussion and Goal~#
#Looking at this dataset, it is clear the authors are trying to examine/compare various contamination levels of water.
#Naturally, starting the y-scale at 0 makes sense, so bar graphs could work, however, when each site has measurements taken in triplicate, I opted for boxplots/dotplots.
#While this seems relatively simple (no colours/shapes), the chart is itself not complicated, just large. This clean method clearly displays the levels of each drug on a common scale, comparing each of the 4 sites closely together.
#With such a low number of observations, boxplot isn't the best idea as showing quartiles is awkward. However, the spread is more for the visual effect.
#Dotplots have their own issues, especially when being viewed in comparison to other drugs (one drug will stretch the scale too far, so all the dots fall on the same spot, losing that information).
#Ideally, each drug would want its own plot, but that would get tedious, and really add nothing to do 24 graphs, so I only did one to show how it looks.
#After, I tried showing the drug categories, rather than the individual drugs as a point of interest. 
#Again, I showed (on a common scale) each drug category with the sites being the primary focus in each facet.
#The final stacked bar graph was more of a curiosity, and not my "preferred" graph. With 24 drugs, this came out quite hard to see (24 hues are very hard to distinguish).


#~Plots~#
#This first graph compares all drugs with respect to their location (3 locations and control)
g1=(ggplot(data=vert)+
      geom_boxplot(aes(x=Site,y=conc))+
      facet_wrap(~drug)+
      labs(title="Drug concentrations in each Site")
)
print(g1); #ggsave("Work/HW3/GeneralComparison.pdf") 

#boxplot not technically appropriate with such low, data points (triplicate), even though it helps visualize the general area
g1a=(ggplot(data=vert)+
      geom_dotplot(binaxis = "y", stackdir ="center", aes(x=Site,y=conc))+
      facet_wrap(~drug)+
       labs(title="Drug concentrations in each Site (dotplot)")
)
print(g1a); #ggsave("Work/HW3/GeneralComparisonDotplot.pdf") 

#However, with only 3 points, the dots themselves don't really show a good spread when the scales are not appropriate (same with the boxplots)
#Sucralose (SUC) skews the rest of the data (since we want to keep it on a common y axis if we want to compare magnitudes)

vert_noSUC=vert %>% filter(drug!='SUC')

g2=(ggplot(data=vert_noSUC)+
      geom_boxplot(aes(x=Site,y=conc))+
      facet_wrap(~drug)+
      labs(title="Drug concentrations in each Site -- Sucralose omitted")
)
print(g2); #ggsave("Work/HW3/SUComitted.pdf") 

#boxplot not technically appropriate with such low, data points (triplicate), even though it helps visualize the general area
g2a=(ggplot(data=vert_noSUC)+
       geom_dotplot(binaxis = "y", stackdir ="center", aes(x=Site,y=conc))+
       facet_wrap(~drug)+
       labs(title="Drug concentrations in each Site -- Sucralose omitted (dotplot)")
)
print(g2a); #ggsave("Work/HW3/SUComitteddotplot.pdf") 

#Question: How do I stop getting "pick better value with binwidth, when I alter bins from 30 I get very, very odd plots#

#Note, this is a temporary remedy. Ideally, I could just show 24 different graphs, one for each drug. This way, there could be an adequate comparison for each specific drug.
#I originally just had them faceted in case someone is interested in comparisons... however, since in biology, different drugs have different effects at various concentrations... i.e. High levels of sucralose, and high levels of testosterone need to be kept in context (each one have "high" defined differently).

#For example, here is testosterone on its own:
tes=vert%>%filter(drug=="TST")
g3=(ggplot(data=tes)+
      geom_boxplot(aes(x=Site,y=conc))+
      labs(title="Testosterone levels in the Water")
)
print(g3); #Won't be printing this one since it's a flatline at 0... however, it is interesting to note that the dotplot is quite a bad choices like these as it looks like there are 3 different values, when all are just "0".
#oops, bad example, didn't realize all values were 0 on the chart, I'll leave this in.
#let's instead try Naproxen
npx=vert%>%filter(drug=="NPX")
g3a=(ggplot(data=npx)+
      geom_boxplot(aes(x=Site,y=conc))+
       labs(title="Naproxen levels in the Water")
)
print(g3a); #ggsave("Work/HW3/Naproxenlevels.pdf")
#Much more informative. This way, each axis would be scaled respectively. 

#?????????  General Question  ?????????????????????#
#I considered standardizing all of the values, and plotting them faceted, to compare them, but I don't know an easy way for python to go through each class of drug, calculate its respective mean/sd then standardize.
#Even if I were to do it in some for loop, it seems like a task that would need to be done manually in R --> meaning, going through each section individually.
#Languages like python seem better at distinguishing between different strings of text, using an algorithm where I store the string of characters to a temp slot, then if the next row is the same class, to incorporate that value:
#When a new class is reached, the stored data would then be used to standardize the data into a new column, and the class would be changed to the new string. This would then repeat until the end of the dataset.
#Unless I'm mistaken, this is one of R's limitations as a language.
###################################################


#dmSRT and dmVLF are variations of their respective parents, and are also anti-depressants, as such, I'll impute that data into the tibble.
imput=vert
imput$drugcat[which(is.na(imput$drugcat))] <-'antidepressant'   #how would you tidyverse this nicely... the traditional method beckoned and I couldn't resist its call.

#now we can see how much each body of water is poluted with each respective drug category
g4=(ggplot(data=imput)+
      geom_boxplot(aes(x=Site,y=conc))+
      facet_wrap(~drugcat)+
      labs(title="Types of drugs found in Water")
)
print(g4); #ggsave("Work/HW3/drugcategories.pdf")

#similar to sucralose dominating the data when drug was in question, now food is dominating, so let's take it out.

nofood=imput%>%filter(drugcat!='food')
g4a=(ggplot(data=nofood)+
      geom_boxplot(aes(x=Site,y=conc))+
      facet_wrap(~drugcat)+
       labs(title="Types of drugs found in Water -- Food omitted")
)
print(g4a); #ggsave("Work/HW3/foodomitted.pdf")

#Once again, we could just do this individually for each graph for the best look if we're more interested in a detailed comparison within specific drug classes instead of a general comparison
#Quick note, boxplots are better to use here, since when we group by drug category, rather than individual drug, we can combine more measurements for a more appropriate box plot (If we think it's ok to lump all "beta-blocker" (etc) together)
#Let's have a look at beta-blockers with a dotplot:

beta=imput%>%filter(drugcat=='beta-blocker')
g4beta=(ggplot(data=beta)+
       geom_boxplot(aes(x=Site,y=conc))+
         labs(title="Beta-blocker levels found in Water")
)
print(g4beta); #ggsave("Work/HW3/betablockerlevels.pdf")
#dotplot comparison
g4beta1=(ggplot(data=beta)+
          geom_dotplot(stackdir="center", binaxis = 'y',aes(x=Site,y=conc))+
           labs(title="Beta-blocker levels found in Water (dotplot)")
)
print(g4beta1); #ggsave("Work/HW3/betadotplot.pdf")
#Perhaps a bit better representation, but in my opinion, not as "nice" as a boxplot.

#I know that stacking is generally not preferred, but I'm adding it in here just to show how something could be made to
#Also note, these plots ADD the triplicates, rather than average them. This is fine, because each one has the same amount of observations, so when they all take the same colour, they are in essence averaged, and proportionally compared to their counterparts
bars=(ggplot(imput, aes(x=Site, y=conc, fill=drug))+
        geom_bar(stat='identity')+
        labs(title="Stacked Bar graph visualization")
)
print(bars); #ggsave("Work/HW3/stacked.pdf")
#Quite hard to see with so many colours (24 hues is a nightmare admittedly -- I tried just alternating colours, but this might be confusing for some who would have to assume that the order of colours was indeed the order seen in the legend), we could also stagger it:
dodgebars=(ggplot(imput, aes(x=Site, y=conc, fill=drug))+
        geom_bar(stat='identity',position=position_dodge())+
          labs(title="Staggered Bar graph visualization")
)
print(dodgebars); #ggsave("Work/HW3/staggered.pdf")
#once again, we see the same issue's as before where Sucralose dominates, again, prompting the idea that perhaps they should just be investigated independently.


#~Citations~#
citation()
citation('tidyverse')
citation('ggplot2')
#McCallum, Erin S., Sherry N. N. Du, Maryam Vaseghi-Shanjani, Jasmine A. Choi, Theresa R. Warriner, Tamanna Sultana, Graham R. Scott, and Sigal Balshine. 2017. “In Situ Exposure to Wastewater Effluent Reduces Survival but Has Little Effect on the Behaviour or Physiology of an Invasive Great Lakes Fish.” Aquatic Toxicology 184 (March): 37–48. doi:10.1016/j.aquatox.2016.12.017