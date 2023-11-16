library(RColorBrewer)
library(gplots)
setwd("E:\\1A李倩倩\\liqianqian\\diff\\LW-MS-COUNT\\sus11.1-count\\LW-MS-D1-sus")
data<-read.table("heatmap-sus-D1.txt",header=T,row.names = 1,sep = "\t")
data2=data.matrix(data)
View(data2)
my_palette <- colorRampPalette(c("navy", "white", "firebrick3"))#创建颜色梯度 从绿到黑再红#自设置调色板
heatmap.2(data2,
          #notecol="black",      # change font color of cell labels to black
          density.info="none",  # turns off density plot inside color legend图例中的密度图
          trace="none",         # turns off trace lines inside the heat map不需要基准线
          #margins =c(12,9),     # widens margins around plot
          col=my_palette,       # use on color palette defined earlier
          #breaks=col_breaks,   # enable color transition at specified limits
          scale='row',        # only draw a row dendrogram
          dendrogram="none",     #把聚类数去掉 
          Colv="NA",        # turn off column clustering
          ylab="", 
          keysize = 1.5,
          labRow = " ",        #
          cexRow=0.8,cexCol=1,
          offsetCol = -0.3,
          offsetRow = -0.3)            

