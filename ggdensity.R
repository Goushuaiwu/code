library(ggplot2)
library(ggpubr)
library(reshape2)
setwd("E:\\1A李倩倩\\liqianqian\\毕业论文结果图\\特征图\\exon_length")
data<-read.table("pro_known_novel_exonlength.txt",header=T,sep = "\t")
data1=melt(data,na.rm = TRUE)
p2 <- ggdensity(data1, x = "value",add = "mean", rug = F, color = "variable",fill = "variable",
       palette = c("#F8766D","#00BA38","#619CFF"))+xlab("exon length")+xlim(0,1500)+theme_grey()+
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
