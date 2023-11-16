rm(list=ls())
library(ggplot2)
library(stringr)
setwd("E:\\Desktop\\astrocyte")
pathway<-read.table("pseudotime-go-gprofiler.txt",header=T,sep="\t",quote="")
#y=factor(pathway$cc,levels = pathway$Description)
y=factor(as.integer(rownames(pathway)),labels=pathway$Description)
#strpathway$Term<-str_split_fixed(pathway$Term,"~",2)[,2]
png_path<-ggplot(pathway,aes(x=x,y=y)) + 
  geom_point(aes(size=intersection_size,color=cluster,shape=cluster))+scale_shape_manual(values = c(17,18,19,15))+
  scale_color_manual(values = c("#33CC00","#FF9999","#33FFFF", "#CC99FF"))+
  labs(
    size="Count",
    x="-1*log10(pvalue)",
    y="Term"
  )+
  theme_bw()+
  theme(
    axis.text.y = element_text(size = 10,colour = "black"),
    axis.text.x = element_text(size = rel(0.9),colour = "black"),
    axis.title.x = element_text(size=rel(0.8)),
    axis.title.y = element_text(size=10,vjust = 0.5))+
  theme(plot.title = element_text(hjust = 0.5,size=rel(1.0)))
png_path
p=png_path+facet_grid(cluster ~ .,scales="free")+ theme(strip.text.x = element_text(size=10, angle=360))
p
ggsave("E:\\Desktop\\ct_chat_go5.pdf", p, width = 6, height = 5)
