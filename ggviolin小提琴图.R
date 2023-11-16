library(ggplot2)
library(ggpubr)
library(reshape2)
setwd("E:\\1A李倩倩\\liqianqian\\毕业论文结果图\\特征图\\FPKM")
data<-read.table("known_novel_pro_gene_FPKM.txt",header=T,sep = "\t")
data1=melt(data,na.rm = TRUE)
p=ggviolin(data1, x = "variable", y = "value", fill = "variable",
         add = "boxplot", add.params = list(fill = "variable"))+
  xlab("Gene type")+ylab("FPKM")+theme_grey()
p2=p+
  theme(legend.position=c(.83,.9))+ ##图例位置
  theme(legend.key = element_blank())+theme(legend.background = element_blank())+
  theme(legend.key.size = unit(0.6,'cm'))+
  theme(axis.title.x = element_text(size = 10,face = "bold"))+
  theme(
    axis.text.y = element_text(size = rel(1.0),colour = "black"),
    axis.text.x = element_text(size = rel(1.0),colour = "black"),
    axis.title.y = element_text(size = 10,face = "bold"))
p3 <- ggpar(p2,legend.title = "")
p3
