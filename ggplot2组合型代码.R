library(ggplot2)
setwd("E:\\1A李倩倩\\liqianqian\\毕业论文结果图\\特征图\\exon_number")
data<-read.table("exon_number_percent_1.txt",header=T,sep = "\t")
barplot<-ggplot(data,aes(x=order,y=y))+geom_bar(aes(fill=condition),stat='identity', position='dodge') + ##并列式需要几何对象position='dodge'，并列
       labs(x = 'Exon number',y = 'Percent(%)')+scale_x_continuous(breaks=data$order, labels=data$x)+
  scale_fill_discrete(breaks=c("anovel_lncRNA_gene","bprotein_coding_gene","known_lncRNA_gene"),
                      labels=c("novel_lincRNA_gene","protein_coding_gene","known_lincRNA_gene"))
       
bar_plot1=barplot+guides(fill=guide_legend(title=NULL))+   ##调整图例的函数guides函数，guide_legend（）离散型颜色标度
  theme(legend.position=c(.83,.9) )+ ##图例位置
  theme(legend.key = element_blank())+theme(legend.background = element_blank())+
  theme(legend.key.size = unit(0.6,'cm'))+
  theme(
    axis.text.y = element_text(size = rel(1.0),colour = "black"),
    axis.text.x = element_text(size = rel(1.0),colour = "black"),
    axis.title.y = element_text(size = 10,face = "bold"),
    axis.title.x = element_text(size = 10,face = "bold"))## face取值：plain普通，bold加粗，italic斜体，bold.italic斜体加粗
bar_plot1

