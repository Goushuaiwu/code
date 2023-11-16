library(ggpubr)
library(tidyverse)
setwd("C:\\Users\\Administrator\\Desktop")
data<-read.table("工作簿1.txt",header=T,sep = "\t")
class(data)
head(data)
dim(data)
str(data)
p=ggscatter(data,     #使用ggscatter函数绘制散点图
            x = "M.241", #x变量
            y = "FOXO4",#y变量
            add = "reg.line",##拟合曲线
            conf.int = F,##置信区间阴影带
            cor.coef = TRUE, ## #是否添加相关系数和p-value值
            cor.coeff.args = list(method = "pearson", label.x = 0.3, label.y = 2.1),#设定相关系数的计算方法
            cor.coef.size = 4.5,#设置R和P值的大小  label.x = 1, label.y = 16是相关系数标签在x轴和y轴的位置
            xlab = "Relative expression level (MSTRG.241)", ## x轴
            ylab = "Relative expression level (FOXO4)",## y轴
            add.params = list(color = "black",
                              fill = "#999999",size = 0.73),
            color = "#FF6600",size =2.5,shape = 17,
            ggtheme = theme_bw())
p2=p+
  theme(
    axis.text.y = element_text(size = 9,colour = "black"),
    axis.text.x = element_text(size = 9,colour = "black"),
    axis.title.y = element_text(size = 10,colour = "black"),
    axis.title.x = element_text(size = 10,colour = "black"))
p2
