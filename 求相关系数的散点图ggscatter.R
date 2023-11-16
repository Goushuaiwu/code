require(ggpubr)
require(tidyverse)
require(Hmisc)
require(corrplot)
library(ggpubr)
library(tidyverse)
setwd("C:\\Users\\Administrator\\Desktop")
data<-read.table("MS-D180-PASuse.txt",header=T,sep = "\t",row.names = 1)
class(data)
head(data)
dim(data)
str(data)
p=ggscatter(data,     #使用ggscatter函数绘制散点图
          x = "readsnumber", #x变量
          y = "FPKM",#y变量
          add = "reg.line",##拟合曲线
          conf.int = TRUE,##置信区间阴影带
          cor.coef = TRUE, ## #是否添加相关系数和p-value值
          cor.coeff.args = list(method = "pearson", label.x = 1, label.y = 16),#设定相关系数的计算方法
          cor.coef.size = 4.5,#设置R和P值的大小  label.x = 1, label.y = 16是相关系数标签在x轴和y轴的位置
          xlab = "log2(PAS reads_number)", ## x轴
          ylab = "log2(FPKM+1)",## y轴
          add.params = list(color = "black",
                            fill = "#999999"),
          color = "#FF6600",size = 1.5,
          title = "MS-D180",
          ggtheme = theme_bw())
p2=p+
  theme(axis.title.x = element_text(size = 10,face = "bold"))+
  theme(
    axis.text.y = element_text(size = rel(1.0),colour = "black"),
    axis.text.x = element_text(size = rel(1.0),colour = "black"),
    axis.title.y = element_text(size = 10,face = "bold"))+
  theme(plot.title = element_text(hjust = 0.5,size = 10,face = "bold"))
p2

