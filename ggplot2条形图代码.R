library(ggplot2)
library(gcookbook)
setwd("C:\\Users\\Administrator\\Desktop")
data<-read.table("染色体.txt",header=T,sep = "\t") 
data <- read.delim("染色体.txt", head=TRUE,stringsAsFactors=F)
p1 <- ggplot(data, aes(x=order,y=numberoflincRNAs))
p1 <- p1 + geom_bar(stat="identity",position=position_dodge(0.7),width=0.5,fill="#6699CC")
p1 + scale_x_continuous(breaks=data$order, labels=data$chromosome)+ylab("amount of lincRNAs")+xlab("chromosome")+
  theme(axis.text.x=element_text(angle=46.8,size=8,vjust=0.5,color = "black"),axis.title.x=element_text(size=10),axis.text.y=element_text(size=8,color = "black"),axis.title.y=element_text(size=10))+
  geom_text(aes(label =data$numberoflincRNAs ),position=position_dodge(width = 0.45),size = 3.5,vjust = -0.25)

