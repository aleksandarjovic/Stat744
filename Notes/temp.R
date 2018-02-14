## need read_table2() for 'irregular' data
dd <- read_table2("../data/wei_tab5.5.txt")
head(dd)

dd2 <- (dd
        %>% gather(key=model,value=val,-c(dataset,r,type))
        %>% separate(model,into=c("model","stat"),sep="\\.")
        %>% spread(key=type,value=val) ## est + sd in a single row
)
head(dd2)

simtab <- read.table(header=TRUE,text="
dataset distribution covstruc separation
sim1 MGHD VEE well-separated
sim2 MGHD VEE overlapping
sim3 MST VEI well-separated
sim4 MST VEI overlapping
sim5 GMM VEE well-separated
sim6 GMM VEE overlapping
")
dd3 <- dd2 %>% merge(simtab,by="dataset")

gg1 <- (ggplot(dd3,aes(factor(r),est,colour=model)) 
        + geom_point()+geom_line(aes(group=model))   ## points and lines
        ## transparent ribbons, +/- 1 SD:
        + geom_ribbon(aes(ymin=est-sd,ymax=est+sd,group=model,fill=model),
                      colour=NA,alpha=0.3)
        + scale_y_continuous(limits=c(0,1),oob=scales::squish)
        + facet_grid(stat~distribution+covstruc+separation)
        + labs(x="r (proportion missing)",y="")
        + scale_colour_brewer(palette="Dark2") + scale_fill_brewer(palette="Dark2"))

print(gg1)

