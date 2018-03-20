##ggmap temp
library(ggmap); citation('ggmap') #david kahle & hadley wickham
library(ggplot2)
library(tidyverse)
library(forcats)
library(labeling) #needs to be installed for ggmap to work

#ggmap easily gets raster map tiles from Google Maps, OpenStreetMap, Stamen Maps (raster data: simplest form, a raster consists of a matrix of cells (or pixels) organized into rows and columns (or a grid) where each cell contains a value representing information, such as temperature. Rasters are digital aerial photographs, imagery from satellites, digital pictures, or even scanned map), then plots using the ggplot2 framework
#It includes tools common to those tasks, including functions for geolocation and routing.


#==============MAP RETRIEVAL=============#

#retrieving stamenmap
mapzone = c(left = -135, bottom = 25.75, right = -62, top = 75) #you specify the box
map = get_stamenmap(mapzone, zoom = 5, maptype = "toner-lite") #maptype, see different ones
#careful, large ggmaps can grow massively in size (150MB)
ggmap(map)

#retrieving googlemap, here we only need to center it
map1 = get_googlemap(center=c(lon=-79.91, lat=43.26),zoom=13, size=c(640,640),scale=2,maptype='terrain') #'satellite','roadmap'
ggmap(map1) #hamilton for example, lon,lat very sensitive, so need to convert hours/minutes into a decimal, zoom must be whole number, so a bit finnicky

#mcmaster satellite map
mcmastermap = get_googlemap(center=c(lon=-79.9192, lat=43.2609), zoom=15, maptype = 'satellite'); ggmap(mcmastermap)
fireball = get_googlemap(center=c(lon=-79.92, lat=43.2609), zoom=19, maptype = 'satellite'); ggmap(fireball)

#can also just type city (for american cities:
ggmap(get_googlemap("london england", zoom = 12))

#with piping
get_googlemap("newyork newyork", zoom = 12) %>% ggmap() #gives me las vegas?
get_googlemap('toronto canada', zoom=12,maptype='satellite') %>% ggmap() #certain zoomes won't 12 does, 13 doesnt 14 doesnt, 15 does
get_googlemap('toronto canada', zoom=15, maptype='hybrid') %>% ggmap() #hybrid gives names of landmarks/streets with the satellite


#``````````````````````````````````````````````````````````````````````````````


#=======Utility: geocode, mapdist, and routing ===============#
#suppose you need to collect data (for a plot or just in general)

geocode("mcmaster university", output="more")

coordinates = geocode("mcmaster university")%>%as.numeric()
revgeocode(coordinates)

mapdist(from="toronto",to="hamilton") #observe, won't work

x=c('toronto','boston'); y=c('hamilton, canada','cleveland')
mapdist(x,y)

routeplan= route(
  'mcmaster university',
  'guelph university',
  alternatives= TRUE
)
qmap('puslinch, canada', zoom = 10, maptype = 'roadmap',
     base_layer=ggplot(aes(x=startLon,y=startLat),data=routeplan))+
  geom_leg(
    aes(x=startLon,y=startLat,xend=endLon,yend=endLat,
           colour=route),
alpha=.7, size=2, data=routeplan) +
  labs(x="longitude",y="latitude",colour="Route")+
  facet_wrap(~route,ncol=2)+
  theme(legend.position='bottom')


#``````````````````````````````````#


#==========qmplot===========#   # "qmplot is that the best way vs not, is it quick and dirty"
#qmplot ggmaps version of ggplot's qplot; that is "quick and easy" way to get graphs built
#Use qmplot() the same way you’d use qplot(), but with a map automatically added in the background.

#i.e. qmap is a "wrapper" for ggmap and get_map: qmap(location = "houston", ...)
#example below of qplot vs ggplot (user kohske on stackoverflow)
#qplot(x,y, geom="line") # I will use this
#ggplot(data.frame(x,y), aes(x,y)) + geom_line() # verbose
#
#d <- data.frame(x, y)
#
#qplot(x, y, data=d, geom="line") 
#ggplot(d, aes(x,y)) + geom_line() # I will use this



#suppose we are interested in specific crimes, we can isolate certain types from our dataset#

#define helper function within tidy (dplyr) #this is similr to defining custom class methods... in essence making special pipes
`%notin%` = function(setA, setB) !(setA %in% setB) #credit to kahle, checks that setA is not in setB

#crime data found in ggplot for practice: houston jan2010 to aug2010
#identify important variables so ppl know what they 'll need to do this with other data

# reduce crime to violent crimes in downtown houston
violent_crimes = crime %>% 
  filter(
    offense %notin% c("auto theft", "theft", "burglary"),
    -95.39681 <= lon & lon <= -95.34188,
    29.73631 <= lat & lat <=  29.78400
  ) %>% 
  mutate(
    offense = fct_drop(offense), #drops unused levels, does not drop NA levels that have values
    offense = fct_relevel(offense,  #reorders factor levels by hand
                          c("robbery", "aggravated assault", "rape", "murder")
    )
  )
## If that is too advanced, here is a more straightforward/traditional way to code it:
#
# qmplot(lon, lat, data = crime)
# 
# 
# # only violent crimes
# violent_crimes <- subset(crime,
#   offense != "auto theft" &
#   offense != "theft" &
#   offense != "burglary"
# )
# 
# # rank violent crimes
# violent_crimes$offense <- factor(
#   violent_crimes$offense,
#   levels = c("robbery", "aggravated assault", "rape", "murder")
# )
# 
# # restrict to downtown
# violent_crimes <- subset(violent_crimes,
#   -95.39681 <= lon & lon <= -95.34188 &
#    29.73631 <= lat & lat <=  29.78400
# )
# 
# theme_set(theme_bw())
# 
# qmplot(lon, lat, data = violent_crimes, colour = offense,
#   size = I(3.5), alpha = I(.6), legend = "topleft")
# 
# qmplot(lon, lat, data = violent_crimes, geom = c("point","density2d"))
# qmplot(lon, lat, data = violent_crimes) + facet_wrap(~ offense)
# qmplot(lon, lat, data = violent_crimes, extent = "panel") + facet_wrap(~ offense)
# qmplot(lon, lat, data = violent_crimes, extent = "panel", colour = offense, darken = .4) +
#   facet_wrap(~ month)

# to see all crimes
qmplot(lon, lat, data = crime, maptype = "toner-lite", colour = I("red"),size = I(0.9),alpha=.3) + theme(legend.position="none")

# use qmplot to make a scatterplot on a map
qmplot(lon, lat, data = violent_crimes, maptype = "toner-lite", colour = I("red"),size = I(0.9),alpha=.3)

#ggplots geoms are all available
#contour example
qmplot(x=lon, y=lat, data = violent_crimes, maptype = "toner-2011", geom = "density2d", colour = I("red"),size=I(1))

#however we can use all the usual ggplot2 stuff (specifying geoms, polishing)

robberies = violent_crimes %>% filter(offense=='robbery')

qmplot(lon, lat, data = violent_crimes, geom = "blank", 
       zoom = 15, maptype = "toner-background", legend = "bottomright"
) +
  stat_density_2d(aes(fill = ..level..), geom = "polygon", alpha = .35, color = NA) +
  scale_fill_gradient2("Robbery\nHeatmap", low = "white", mid = "yellow", high = "red", midpoint = 650)
# add points to the heatmap

#faceting by crime
(
qmplot(lon, lat, data = violent_crimes, maptype = "toner-background", color = offense) + 
  facet_wrap(~ offense)
)

#faceting by day

houston = get_googlemap('houston texas', zoom=15, maptype='roadmap')
ggmap(houston)

HoustonMap <- ggmap(houston, base_layer = ggplot(aes(x = lon, y = lat),
                                                 data = violent_crimes))
HoustonMap +
  stat_density2d(aes(x = lon, y = lat, fill = ..level.., alpha = ..level..),
                 bins = 5, geom = "polygon",
                 data = violent_crimes) +
  scale_fill_gradient(low = "black", high = "red") +
  facet_wrap(~ day)

#changing image of crimes
theme_set(theme_bw())
houmap = qmap("houston",zoom=13, colour='bw', legend ='topleft')

#QUERY LIMIT ISSUES... ??????

(houmap+
    geom_point(data=violent_crimes, aes(x=lon,y=lat,colour=offense,size=offense))
)

(
houmap+
    stat_bin2d(
      data=violent_crimes,
      aes(x=lon,y=lat,colour=offense,fill=offense),
      size=0.6, bins= 90, alpha=.4
    )
)
#compare to closer, we can use less bins
houmap = qmap("houston",zoom=14, colour='bw', legend ='topleft')

(houmap+
    geom_point(data=violent_crimes, aes(x=lon,y=lat,colour=offense,size=offense))
)

(
  houmap+
    stat_bin2d(
      data=violent_crimes,
      aes(x=lon,y=lat,colour=offense,fill=offense),
      size=0.6, bins= 30, alpha=.4
    )
)
