library(ggpubr)
library(reshape2)
setwd("E:\\1A��ٻٻ\\liqianqian\\wei-yor���ͼ\\����ͼ\\FPKM")
data<-read.table("������12.txt",header=T,sep = "\t")
data1=melt(data)
p <- ggboxplot(data1,x="variable",fill="variable",y="value",color = "black",
               add = "jitter",shape="variable")+
                 xlab("Gene type")+ylab("FPKM")+theme_grey()
p2=p+   
  theme(legend.position=c(.83,.9))+ ##ͼ��λ��
  theme(legend.key = element_blank())+theme(legend.background = element_blank())+
  theme(legend.key.size = unit(0.6,'cm'))+
  theme(axis.title.x = element_text(size = 10,face = "bold"))
p3 <- ggpar(p2,legend.title = "")
p3
