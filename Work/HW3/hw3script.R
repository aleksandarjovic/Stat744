### Homework 2: Why do we let doctors give our kids vaccines? Aleksandar Jovic. Jan 24, 2018 ### I'm still working on R markdowns, so I'll put all comments in here for now.


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
#we don't need the ID nor the sampler type (All are polar organic chemical integrative samplers)
x1=x1[,-c(1,2)]
x2=read_csv('Data/POCIS_support.csv') #to get some more informative column names
  #temp[#,2:5]   #filtering out what I don't need
  

head(x1)
#ggsave("Work/HW3/asljfl.pdf") 


#~Citations~#
#McCallum, Erin S., Sherry N. N. Du, Maryam Vaseghi-Shanjani, Jasmine A. Choi, Theresa R. Warriner, Tamanna Sultana, Graham R. Scott, and Sigal Balshine. 2017. “In Situ Exposure to Wastewater Effluent Reduces Survival but Has Little Effect on the Behaviour or Physiology of an Invasive Great Lakes Fish.” Aquatic Toxicology 184 (March): 37–48. doi:10.1016/j.aquatox.2016.12.017