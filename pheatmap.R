library(pheatmap)
setwd("E:\\1A李倩倩\\liqianqian\\毕业论文结果图\\diff\\LW-MS-COUNT\\sus11.1-count\\LW-MS-D90-sus")
data<-read.table("heatmap-sus-D90.txt",header=T,row.names = 1,sep = "\t")
data2=data.matrix(data)
pheatmap(data2,border_color='NA',scale='row',cluster_cols = F,cellwidth = 20,cellheight = 0.5,color = colorRampPalette(c("navy","white","firebrick3"))(100),
         treeheight_row = 0,treeheight_col = 0,show_rownames = FALSE,fontsize_col = 8,fontsize = 8,show_colnames = T,cutree_col = 2)
         
