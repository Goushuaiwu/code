library(ggplot2)
library(gcookbook)
setwd("C:\\Users\\Administrator\\Desktop")
data<-read.table("PAS距离结果.txt",header=T,sep = "\t") 
p1 <- ggplot(data, aes(x=order,y=frequency))
p1 <- p1 + geom_bar(stat="identity",width=1.0,fill="#FF6600")# dodge控制他们组合型柱状图同一组内柱子之间的间隔
p2 <- p1+ ylab("Frequency(%)")+xlab("Distance between two adjacent PASs")+
  theme(axis.text.x=element_text(angle=0,size=8,vjust=0.5,color = "black"),axis.title.x=element_text(size=10),axis.text.y=element_text(size=8,color = "black"),axis.title.y=element_text(size=10))
p3<-p2 +scale_x_continuous(breaks=c(0,20,40,60,80,100),labels=c('0','2000','4000','6000','8000','10000'))+ggtitle("bin size 100bp")+
  theme(title=element_text(size=8,color="black"))
p3

