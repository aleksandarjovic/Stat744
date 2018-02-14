### Homework 2: Why do we let doctors give our kids vaccines? Aleksandar Jovic. Jan 24, 2018 ### I'm still working on R markdowns, so I'll put all comments in here for now.


#~Preamble~#
library(tidyverse) #loads magrittr, dplyr, readr, tidyr, purr, tibble, stringr, forcats
library(ggplot2)  ## BMB: my version of tidyverse also loads ggplot2
library(GGally) #trusty sidekick
theme_set(theme_bw()) #override basic ggplot, can edit further later if req'd


#~Dataset~#
temp=read_csv('Data/POCIS_Raw_McCallum.csv')
x=temp[#,2:5]   #filtering out what I don't need
  

  
  
  #ggsave("Work/HW3/asljflqweqwew.pdf") 