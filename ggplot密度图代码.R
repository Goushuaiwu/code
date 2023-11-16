library(ggplot2)
library(reshape2)
setwd("E:\\1A李倩倩\\liqianqian\\wei-yor结果图\\特征图\\exon length")
data<-read.table("工作簿2.txt",header=T,sep = "\t")

density_plot<-ggplot(data)+geom_density(aes(x=value,fill=type))+
             xlab("exon length")+xlim(0,1650)
density_plot1=density_plot+guides(fill=guide_legend(title=NULL))+   ##调整图例的函数guides函数，guide_legend（）离散型颜色标度
             theme(legend.position=c(.83,.9))+ ##图例位置
             theme(legend.key = element_blank())+theme(legend.background = element_blank())+
             theme(legend.key.size = unit(0.6,'cm'))+
             theme(axis.title.x = element_text(size = 10,face = "bold"))## face取值：plain普通，bold加粗，italic斜体，bold.italic斜体加粗
density_plot1
