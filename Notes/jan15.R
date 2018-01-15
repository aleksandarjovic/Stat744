#Jan 15
#reviewing Rauser's video "how humans see data" (amsterdam, 2016)
# http://bbolker.github.io/stat744/scales.handouts.pdf notes note yet posted
# 'fun book' -> "how to lie with statistics"

## discussion on when to use 0 as an anchor
# when talking about global temperature, 10 degrees c is not necessarily double 5 degrees (temperature)
#however, 10mil sales is double 5mil sales... so 0 scale more important here

#bar graph bad in the sales since comparing area/length, since bars are reinforcing that something is doubling
#rather than using a line to show trend... the bars emphasize strongly physical quantities (debatable)
#using the anchor could be more accurate/ethical

#the steel picure, if the picture is 40% taller, then the picture's area is SQUARED, misleading
#however, the 2d pictures also represent some 3d object

##log vs linear scales 1 is to 10, as 10 is to ...... (19? linear vs 100? log)
#log scale good for physical quantities
# bar chart on log scale is very bad, since it conveys physicality which log scales are absolutely not
# ** Bar charts should be used sparingly and not for logs **

# (see comparison to the left and right) - without the bars, much cleaner
# with all the space, can show trend in the data
# or just show all the points (since there are so few) AND show CI (not too cluttered)
# boxplot is ok, but too few points makes violin plot not as useful (not enough for good density)

# linear scale cares about aritmetic differences, log scales care about ratios (neither intrinsically better, both have some explicit assumption)
# logs not physical, so do not attack them to area type graphs

## PROBABILITIES
# 1% is to 2% as 50% is to ...
#51% too small, 100 too large
# Natural distance to use on a probability scale is LOG ODDS
#50% is to 67% ... 2% is to 4%  .... 98% is to 99%

#see odds, extreme values in notes