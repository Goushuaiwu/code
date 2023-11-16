rm(list=ls())
library(ggplot2)
library(stringr)
setwd("E:\\1A李倩倩\\liqianqian\\毕业论文结果图\\PAS\\PAS利用率的差异分析\\DAVID")
pathway<-read.table("LW-MS-D180-PAS-DAVID.txt",header=T,sep="\t",quote="")
y=factor(pathway$Term,levels = pathway$Term)
strpathway$Term<-str_split_fixed(pathway$Term,"~",2)[,2]
png_path<-ggplot(pathway,aes(x=log10(Fold.Enrichment),Term,y=y)) + 
  geom_point(aes(size=Count,color=-1*log10(PValue)),shape=18)+ ##改变点的大小，四维数据的展示
  scale_colour_gradient(low="blue",high="yellow")+  ##自定义自变颜色
  labs(
    color=expression(-log[10](Pvalue)),
    size="count",
    x="Fold enrichment",
    y="Term",
    title="pathway enrichment")+
  theme_bw()+
  theme(
    axis.text.y = element_text(size = rel(1.0),colour = "black"),
    axis.text.x = element_text(size = rel(0.9),colour = "black"),
    axis.title.x = element_text(size=rel(0.8)),
    axis.title.y = element_text(size=10,vjust = 0.5))+
  theme(plot.title = element_text(hjust = 0.5,size=rel(1.0)))
png_path

dim(pathway)
str(pathway)
