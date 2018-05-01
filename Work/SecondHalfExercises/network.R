#network graph simulation
library(tidyverse)
library(igraph)

g = erdos.renyi.game(10, 1/10)
plot(g)
g <- erdos.renyi.game(20, 1/5)
plot(g)
#visualizing the simulation of linkages

#creating my own
g = graph(c(1,3, 3,4, 2,3, 3,5,5,1),n =7) #this comma notation is confusing unless you space it , even though the whitespace is not important to the program
plot(g)

#This was the "homework" in the notes, the application part was a bit confusing
#I couldn't really follow their examples like the other presentations, as the packages weren't identified (for one thing)

#for future reference, here is an excellent link with a lot of really fantastic examples: http://kateto.net/network-visualization
#Here's an example for network of businesses

## JD: Thanks and sorry for inconvenience ☺

##Dynamic example##
library(ndtv)
library(networkDynamic)

data(short.stergm.sim)
short.stergm.sim
head(as.data.frame(short.stergm.sim))

#simulated data of renaissance florentine family business conections

plot(short.stergm.sim) #this plots network without any time (combines all nodes that were meant to combine)
plot(network.extract(short.stergm.sim, at=5)) #this shows the network at time=5

#this next part uses the d3 from the java presentation
# JD: Again, your script should run start-finish. 
render.d3movie(short.stergm.sim,displaylabels=TRUE)

#pretty neat stuff, check out the link for tons more
# JD: Yes, we will look at this for next year
