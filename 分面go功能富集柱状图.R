library(ggplot2)
setwd("E:\\Desktop")
pathway<-read.table("glu-timediff-go_cluster1-4.txt",header=T,sep="\t",quote="")
#x=factor(as.integer(rownames(pathway)),labels=pathway$Description)
#COLS <- c("blue","brown","turquoise")
p=ggplot(data=pathway, aes(x=x,y=reorder(Description,x),fill=cluster)) + geom_bar(stat="identity", width=0.7,position='dodge')+
  scale_fill_manual(values = c("#33CC00","#FF9999","#33FFFF", "#CC99FF")) + theme_bw()  +
  xlab("-1*log10(pvalue)") + ylab("Term")+theme(axis.text.x=element_text(color="black",angle = 360,vjust = 1, hjust = 1,size = 10),axis.text.y=element_text(color="black",size = 10))
#  facet_grid ??ҳ guides(fill=FALSE)?ı???????
p1=p+facet_grid(cluster ~ .,scales="free")+guides(fill=FALSE)+ theme(strip.text.x = element_text(size=10, angle=360))
p1
p

