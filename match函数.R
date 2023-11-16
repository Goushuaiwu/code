setwd("E:\\Desktop")
data<-read.table("hub_linc-blue.txt",header=T,sep = "\t")
data1<-read.table("mart_export.txt",header=T,sep = "\t")
t1<-data1[match(data$fromNode,data1$GenestableID),]
t1
write.table(t1,"blue-zhuanhuangenename.txt",row.names = F,sep = "\t")
