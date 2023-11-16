rm(list=ls())
library(ggplot2)
library(stringr)
setwd("E:\\1A李倩倩\\liqianqian\\wei-yor结果图\\trans-go-kegg")
pathway = read.table("can_use_BP.txt",header=T,sep="\t")
dorder = factor(as.integer(rownames(pathway)),labels=pathway$Term) #对数据按Description排序

p<-ggplot(pathway,aes(x=Term,y=Count,fill=Category))+ #定义X轴，Y轴的数据和颜色填充
     geom_bar(stat="identity",position=position_dodge(0.7),width=0.5,aes(x=dorder))+ #定义柱形图的宽度和间距
    coord_flip()+ #转换横纵坐标
    scale_y_log10(breaks = c(1,10,100,1000))+ #Y轴按log10排序，展示1，10，100，1000刻度
    scale_fill_discrete(name="Category")+ #修改legend的tittle
    theme(panel.background = element_rect(fill = "transparent",colour = NA))+ #清楚背景颜色
    xlab("Term")+ #修改X轴标签
  theme(
    axis.text.y = element_text(color="black",size = rel(1.0)),
    axis.text.x = element_text(size = rel(0.9)),
    axis.title.x = element_text(size=rel(0.8)),
    axis.title.y = element_text(size=10,vjust = 0.5))
p
