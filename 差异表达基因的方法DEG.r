library("DESeq2")
setwd("E:\\1A李倩倩\\liqianqian\\毕业论文结果图\\diff\\LW-MS-COUNT\\sus11.1-count\\LW-MS-D180-sus")
counts_dir="E:\\1A李倩倩\\liqianqian\\毕业论文结果图\\diff\\LW-MS-COUNT\\sus11.1-count\\LW-MS-D180-sus"
counts_Files <- grep("\\.count",list.files(counts_dir),value=TRUE)
counts_group <- sub("(\\w)\\d.*","\\1",counts_Files)

counts_Table <- data.frame(sampleName = counts_Files,
                         fileName = counts_Files,
                         group=counts_group,
                         condition = counts_group)
counts_HTSeq <-
  DESeqDataSetFromHTSeqCount(
    sampleTable = counts_Table,
    directory = counts_dir,
    design = ~ condition
  )

#鍙鍖?
library("pheatmap")
nt <- normTransform(counts_HTSeq) # defaults to log2(x+1)
pheatmap(assay(nt), cluster_rows=T, show_rownames=FALSE,
         cluster_cols=T)

rld <- rlog(counts_HTSeq, blind=FALSE)
pheatmap(assay(rld), cluster_rows=T, show_rownames=FALSE,
         cluster_cols=T)

vsd <- varianceStabilizingTransformation(counts_HTSeq, blind=FALSE)
pheatmap(assay(vsd), cluster_rows=T, show_rownames=FALSE,
         cluster_cols=T)

plotPCA(nt, intgroup=c("condition"))
plotPCA(rld, intgroup=c("condition"))
plotPCA(vsd, intgroup=c("condition"))



#杩囨护
dds <- counts_HTSeq[ rowSums(counts(counts_HTSeq)) > 1, ]

#璁＄畻
dds_DE <- DESeq(dds)

#灞曠ず缁撴灉
res_DE <- results(dds_DE,alpha=0.05,contrast=c("condition","LW_De_sus_","MS_De_sus_"))
summary(res_DE)

#淇濆瓨缁撴灉
resOrdered <- res_DE[order(res_DE$padj),]
write.csv(as.data.frame(resOrdered),
          file="LW_MS_D180.csv")



plotMA(dds_DE, main="DESeq2", ylim=c(-1,1))
plotCounts(dds, gene=which.min(res_DE$padj), intgroup="condition")


N=18807
n=321
M=74
m=11
phyper(n-m,M, N-M, n, lower.tail=FALSE)



