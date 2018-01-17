### Homework 1. Tues Jan 16. Aleksandar Jovic ###

## Headers ##
rm(list = ls())
library(tidyverse) #loads magritter, dplyr, readr, tidyr, purr, tibble, stringr, forcats
library(ggplot2)
library(GGally) #trusty sidekick
theme_set(theme_bw()) #override basic ggplot, can edit further later if req'd

## Dataset ##
wined=read_csv('Data/Wine.csv')
#citation: http://archive.ics.uci.edu/ml/datasets/Wine, column 1 is the class.
#This dataset is a multivariate dataset which could be used for classification analysis of three wine types: {1,2,3}
names(wined)=c('class','alc','malic','ash','alcalin','mg','phenol','flavan','nonflav','proanth','col.int','hue','diluted','prol')

wined= wined %>% mutate(class=as.factor(class)) #wine classes are originally coded as {1,2,3} numerics

#ggpairs(wined, aes(colour=class, alpha=.5)) #EXTREMELY slow with this dataset, but good to check for a quick overview to estimate important variables for discriminating wine types
#ggsave("Work/HW1/pairs.pdf") #Pairs plot suggests some good graphs, but is more of a guideline (and does things automatically), so I'm excluding it.


## Plot 1 ~ Can wine be distinguished by its colour intensity and hue (referring to the variable in the dataset)? ##
# This dataset lends itself nicely to classification, so let's do some "visual" clustering (eyeballing).
# According to Gestalt Pyschology, your brain already has k-means clustering (or whichever more advanced method) built into it, and just by taking a glance, "Emergence" can quickly form regions of interest.
# Hence we can assign each class a different a different uniform. Our options are Hue, and Shape (angle). While hue ranks low generally, it is appropriate to use in this case since the colours are able to form a starker contrast against each other in the case of a scatterplot (I would argue).
# Some transparency is added to allow dense areas to appear "darker", since alpha=1 removes any potential of "colour saturation" gradient (should points overlap) which is natural and immediately understood.
# Rather than facet, putting them on the same graphs gives us an idea of how easily we can discriminate the wines with these variables (the equivalent to "position along same scale")

plot1=(ggplot(data=wined,aes(x=col.int,y=hue,colour=class))+
    geom_point(size=2,alpha=.6)+
    labs(title="Hue vs Colour Intensity Scatterplot", caption="Can wine conoisseurs tell a wine by looking at it?",x="Colour Intensity", y="Hue")
)
print(plot1)
#ggsave("Work/HW1/Plot1.pdf")   #I'll be saving it once myself to the directory, but leaving it in the code for completion.

plot1a=(ggplot(data=wined,aes(x=col.int,y=hue, shape=class))+
  geom_point(size=2,alpha=.6)+
  scale_shape_manual(values = c(0,3,25))+
  labs(title="Hue vs Colour Intensity Scatterplot", caption="Can wine conoisseurs tell a wine by looking at it?",x="Colour Intensity", y="Hue")
)
print(plot1a)
#ggsave("Work/HW1/Plot1a.pdf")

#for comparison, here is the scatterplot with hue removed and instead we give each class a shape. I would argue this is harder to look at.
#using shape and hue seems redundant, since if you're already using hue, the extra shape change won't really help, and adds "empty" information (i.e. green triangle VS green), since the choices themselves are mostly arbitrary
#Open, and simple shapes were chosen on purpose, building up from lowest number of lines (the line +), then triangle, then square. Choosing Heptagon, Octagon, Nonagon would have been objectively harder to tell apart.

#It's a bit hard to see, but we could facet it to see. Here we let hue be our common aligned scale (in this case, I can't argue that it's better, but that should always be a consideration when more obvious)
plot1ai=(ggplot(data=wined,aes(x=col.int,y=hue, shape=class))+
  geom_point(size=2,alpha=.6)+
  scale_shape_manual(values = c(0,3,25))+
  facet_wrap(~class, labeller=label_both)+
  labs(title="Hue vs Colour Intensity Scatterplot", caption="Can wine conoisseurs tell a wine by looking at it?",x="Colour Intensity", y="Hue")
)
print(plot1ai)
#ggsave("Work/HW1/Plot1ai.pdf")


## Plot 2 ~ Examining importance of Proline content ##
# Here we will try and use the violin plot (being classically trained, this plot makes me happy). A violin plot is fine with 177 observations.
# No need to anchor scale to 0. Magnitude isn't what's important, but position.
#I place them along a common scale. The area and angles within the plot help convey the probability of having a certain type of wine at a given proline level.
#The angles naturally follow the area showing increase/decrease in probability (obvious, but stating it since it's in the list).
#From these plots, one would ascertain that type1 wine has the highest P content, and differentiating 2 from 3 would be more difficult.
plot2=  (ggplot(wined, aes(x=class, y=prol, fill=class))+
  geom_violin(trim=T,scale="area",alpha=.6)+ #Trim specified to TRUE (default anyway), since this isn't sampled from RNG, but datapoints taken. The extra tail would be misleading.
  theme_minimal()+
  labs(title="Proline Content", x="Wine Type",y="Proline content")+
  scale_fill_manual(values=c("red", "darkred", "maroon"))+
  theme(legend.position="none")
)
print(plot2)
#ggsave("Work/HW1/Plot2.pdf")
#Red violins appropriately... More seriously, the colours are simply aesthetic here as the plots being separated is really all that's required
#I will comment on red perhaps not being the best choice in general, since red-green colourblindness is relatively common in the (male) population
#The default legend is completely pointless, since the three classes are clearly labelled, and even understood without looking at the x axis (it would be my first assumption).

# Stuffing a boxplot within the violin plot doesn't add new information really, but adds clarity. Boxplot clearly shows quartiles, and Violinplot gives a better idea of the density.
plot2a=  (ggplot(wined, aes(x=class, y=prol, fill=class))+
          geom_boxplot(width=0.3, fill="black",alpha=1)+
          geom_violin(trim=T,scale="area",alpha=.6)+ #Trim specified to TRUE (default anyway), since this isn't sampled from RNG, but datapoints taken. The extra tail would be misleading.
          theme_minimal()+
          labs(title="Proline Content", x="Wine Type",y="Proline content")+
          scale_fill_manual(values=c("red", "darkred", "maroon"))+
          theme(legend.position="none")
)
print(plot2a)
#ggsave("Work/HW1/Plot2a.pdf")


## Plot 3 ~ Combining ideas from parts 1 and 2 ##
#As to not repeat ideas, I'll try something more esoteric. Suppose one was interested in seeing if they could classify "high vs low proline" given hue and colour intensity.
#Splitting proline into greater and less than the mean is a hypothetical choice.
#Similar rational is used for my choice of hue in the graph and transparency. Once again, a legend is necessary since there is no natural ordering to colour -- despite this, it is a small concession.

wined1=wined #!!!!!could not get conditional piping to work, will add appropriate method later
wined1$fprol="temp" #allocating memory for loop
for (i in 1:177){
if (wined1[i,14]>=mean(wined$prol)) wined1[i,15]="high"
else wined1[i,15]="low"
}
rm(i) #memory cleanup

plot3=(ggplot(data=wined1,aes(x=col.int,y=hue,colour=fprol))+
         geom_point(size=1.5,alpha=0.5)+
         labs(title="Hue vs Colour Intensity when Comparing High vs Low Proline", x="Colour Intensity", y="Hue", colour = "Proline level\n")+
         scale_color_manual(labels = c("above average", "below average"), values = c("red", "blue"))
)
print(plot3)
#ggsave("Work/HW1/Plot3.pdf")

#I'll now investigate how adding layers of information to a density plot can change the story being told by the data.
#We'll start with most basic, and add layers of depth, which will in turn make the data more interesting, but also more accurate (honest? << One could purposely hide information by omitting certain factors)
plot3a=(ggplot(data=wined1,aes(x=col.int,y=hue))+
  geom_density2d(size=1.1)+
  labs(title="Density plot of Hue and Colour Intensity",caption="It appears as if there are 2 clusters without separating by category",x="Colour Intensity",y="Hue")
)
print(plot3a)
#ggsave("Work/HW1/Plot3a.pdf")

#Now let's add the high/low proline division. This is the most directly comparable to the initial scatterplot, and add the most support to that particular graph.
plot3b=(ggplot(data=wined1,aes(x=col.int,y=hue,colour=fprol))+
          geom_density2d(size=1.1)+
          labs(title="Density plot of Hue and Colour Intensity",caption="With more info, we can see that there are likely more than 2 overall classes",x="Colour Intensity",y="Hue")
)
print(plot3b)
#ggsave("Work/HW1/Plot3b.pdf")

#Since this wasn't the ideal way to divide the information, let's see the density plot when using the 3 classes shown.
#As a side note, the Gestalt formed when viewing a scatterplot is often reasonably close to what the density plot reveals (at least to me).
plot3c=(ggplot(data=wined1,aes(x=col.int,y=hue,colour=class))+
          geom_density2d(size=1.1)+
          labs(title="Density plot of Hue and Colour Intensity",caption="The mess in the middle is somewhat resolved, but of course, more investigation would be meritted",x="Colour Intensity",y="Hue")
)
print(plot3c)
#ggsave("Work/HW1/Plot3c.pdf")


## Plot 3.1415 ~ The Coveted Pie Chart -- King of Uselessness, and Number 1 spot in "Top 10 Graphs I'd Eat" ##
# Here we can visualize the number of wines contained in each class in this dataset... largely useless, as pie-charts in general are.
temp=wined %>% 
  group_by(class) %>%
  summarise(count = length(class))

Pi= (ggplot(temp, aes(x="", y=count, fill=class))
  +geom_bar(width=1,stat="identity")
  #+geom_text(...)        #adding numbers to the graphic defeats the purpose, does it not? Why not just use a simple table then...
)
Pi+ coord_polar("y",start=0)
#the pi chart must be built out of the bar graph... interesting, too bad I'll never use it.
#Of course, that table given by "temp" is really all that's needed to convey this exact piece of information clearly, as the pie chart is impossible to distinguish.
#I won't be printing this to the repo for obvious reasons, but this stupid "joke" graph took me way longer than I anticipated, so I'm leaving it (it shows off some tidyverse piping).
#side note, "Pi" is poorly named on purpose (since "pi" is a default object in R)


## Citations ##
citation()
citation('tidyverse')
citation('ggplot2')
#Rauser, John. "How Humans See Data". Velocity Amsterdam 2016.