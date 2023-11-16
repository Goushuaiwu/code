source("http://bioconductor.org/biocLite.R")
biocLite(c("AnnotationDbi", "impute", "GO.db", "preprocessCore"))
install.packages("WGCNA")
library(WGCNA)
#1加载基因表达数据
Data = read.csv("E:\\1A李倩倩\\liqianqian\\毕业论文结果图\\WGCNA\\WGCNA_input.csv", header=T,stringsAsFactors = FALSE)##默认的 R 会把字符串因子化，当前情况下，必须关闭这个功能。
dim(Data)
head(Data)
names(Data)#查看数据字段命名
row.names(Data) <- Data$geneID #先将第第一行变成行名
Data1 <- Data[,-1] #把第一列删掉
dataExp = as.data.frame(t(Data1))
dataExp[seq(1,18),seq(1,4)]
gsg = goodSamplesGenes(dataExp, verbose = 3)
gsg$allOK
gsg$goodGenes
gsg$goodSamples 
#2查看是否有离群值
sampleTree = hclust(dist(dataExp), method = "average");
sizeGrWindow(12,9)
#pdf(file = "Plots/sampleClustering.pdf", width = 12, height = 9);
par(cex = 0.6);
par(mar = c(0,4,2,0))
plot(sampleTree, main = "Sample clustering to detect outliers", sub="", xlab="", cex.lab = 1.5,
     cex.axis = 1.5, cex.main = 2)
#3加载性状数据
alltraitData = read.csv("E:\\1A李倩倩\\liqianqian\\毕业论文结果图\\WGCNA\\trait1.csv",header=T,stringsAsFactors = FALSE);
dim(alltraitData)
names(alltraitData)
femaleSamples = rownames(dataExp)
traitRows = match(femaleSamples, alltraitData$sampleid) #match(x,y)  x，y 是向量，match 返回结果是 x 的每一项在 y 中的索引。
traitRows
datTraits = alltraitData[traitRows, -1]
datTraits
rownames(datTraits) = alltraitData[traitRows, 1]
rownames(datTraits)
collectGarbage()
#4软阈值的选择
powers = c(c(1:10), seq(from = 12, to=20, by=2))# 设定软阈值范围
sft = pickSoftThreshold(dataExp, powerVector = powers,verbose = 5)# 获得各个阈值下的 R方 和平均连接度 verbose表示输出结果详细程度
str(sft)# sft这中保存了每个powers值计算出来的网络特征,其中powerEstimate就是最佳power值，fitIndices保存了每个power对应的网络的特征。
sizeGrWindow(9, 5) #打开一个图形窗口中指定的尺寸
par(mfrow = c(1,2))# 设置图的显示一行两列
cex1 = 0.9
plot(sft$fitIndices[,1], -sign(sft$fitIndices[,3])*sft$fitIndices[,2],
     xlab="Soft Threshold (power)",ylab="Scale Free Topology Model Fit,signed R^2",type="n",
     main = paste("Scale independence"))
text(sft$fitIndices[,1], -sign(sft$fitIndices[,3])*sft$fitIndices[,2],
     labels=powers,cex=cex1,col="red");
# this line corresponds to using an R^2 cut-off of h
abline(h=0.90,col="red")
plot(sft$fitIndices[,1], sft$fitIndices[,5],
     xlab="Soft Threshold (power)",ylab="Mean Connectivity", type="n",
     main = paste("Mean connectivity"))
text(sft$fitIndices[,1], sft$fitIndices[,5], labels=powers, cex=cex1,col="red")
# 将临近矩阵转为 Tom 矩阵
adjacency = adjacency(datExpr, power = softPower)
TOM = TOMsimilarity(adjacency);
# 计算基因之间的相异度
dissTOM = 1-TOM
hierTOM = hclust(as.dist(dissTOM),method="average")
k <- softConnectivity(dataExp,power=7) 
sizeGrWindow(10, 5)
par(mfrow=c(1,2))
hist(k)
scaleFreePlot(k,main="Check Scale free topology\n")
#5基因模块的划分
net = blockwiseModules(dataExp, power = 7,TOMType = "unsigned", minModuleSize = 30,reassignThreshold = 0, 
                       mergeCutHeight = 0.25,numericLabels = T, pamRespectsDendro = FALSE,saveTOMs = TRUE,
                       saveTOMFileBase = "LWMSTOM",verbose = 3)#for type = "unsigned", adjacency = |cor|^power
table(net$colors)#我们现在回到网络分析。要查看标识了多少个模块以及模块大小
# 打开图型窗口
sizeGrWindow(12, 9)
# 把模块编号转换成颜色值
mergedColors = labels2colors(net$colors)
#绘制聚类图和色彩
plotDendroAndColors(net$dendrograms[[1]], mergedColors[net$blockGenes[[1]]],
                    "Module colors",
                    dendroLabels = FALSE, hang = 0.03,
                    addGuide = TRUE, guideHang = 0.05)#此函数绘制一个层次聚类树状图和彩色注释（S）下的树状图的对象
#保存后续分析所需的模块分配和模块本征信息。
moduleLabels = net$colors
moduleColors = labels2colors(net$colors)
moduleColors
MEs = net$MEs
MEs
geneTree = net$dendrograms[[1]];
save(MEs, moduleLabels, moduleColors, geneTree,
     file = "FemaleLiver-02-networkConstruction-auto.RData")
#5量化模块-特质关联
# 获得基因数和样本数
nGenes = ncol(dataExp)
nSamples = nrow(dataExp)
# 用彩色标签重新计算MEs
# 在给定的单个数据集中计算模块的模块本征基因
MEs0 = moduleEigengenes(dataExp, moduleColors) 
MEs0
MES1 = MEs0$eigengenes
# 对给定的（特征）向量进行重新排序，以使相似的向量彼此相邻
MEs = orderMEs(MES1)
# 计算module的ME值与表型的相关系数
moduleTraitCor = cor(MEs, datTraits, use = "p");
moduleTraitPvalue = corPvalueStudent(moduleTraitCor, nSamples)
names(MEs)
# sizeGrWindow(10,6)
# 显示相关性及其p值
textMatrix = paste(signif(moduleTraitCor, 2), "\n(",signif(moduleTraitPvalue, 1), ")", sep = "");
dim(textMatrix) = dim(moduleTraitCor)
par(mar = c(6, 8.5, 3, 3));
# Display the correlation values within a heatmap plot\
# ySymbols 当ylabels使用时所使用的其他标签； colorLabels 应该使用颜色标签吗
# colors 颜色； textMatrix 单元格名字
labeledHeatmap(Matrix = moduleTraitCor,xLabels = names(datTraits),yLabels = names(MEs),ySymbols = names(MEs),
               colorLabels = FALSE,colors = blueWhiteRed(50),textMatrix = textMatrix,setStdMargins = FALSE,
               cex.text = 0.5,zlim = c(-1,1), yColorWidth = 0.05, xLabelsAngle = 45,xLabelsAdj = 0.9,
               main = paste("Module-trait relationships"))
# 6基因和模块的相关系数
modNames = substring(names(MEs), 3)
geneModuleMembership = as.data.frame(cor(dataExp, MEs, use = "p"))
MMPvalue = as.data.frame(corPvalueStudent(as.matrix(geneModuleMembership), nSamples))
names(geneModuleMembership) = paste("MM", modNames, sep="")
names(MMPvalue) = paste("p.MM", modNames, sep="")
#7gene和性状的关系
# 定义包含数据特征权重列的变量权重
LW_D1 = as.data.frame(datTraits$LW.D1)
names(LW_D1) = "LW_D1"
geneTraitSignificance = as.data.frame(cor(dataExp, LW_D1, use = "p"))
GSPvalue = as.data.frame(corPvalueStudent(as.matrix(geneTraitSignificance), nSamples))
names(geneTraitSignificance) = paste("GS.", names(LW_D1), sep="")
names(GSPvalue) = paste("p.GS.", names(LW_D1), sep="")
# 模型颜色
module = "turquoise"
# 匹配列
column = match(module, modNames)
moduleGenes = moduleColors==module
#sizeGrWindow(7, 7)
par(mfrow = c(1,1))
# 画散点图
verboseScatterplot(abs(geneModuleMembership[moduleGenes, column]),
                   abs(geneTraitSignificance[moduleGenes, 1]),
                   xlab = paste("Module Membership in", module, "module"),
                   ylab = "Gene significance for body weight",
                   main = paste("Module membership vs. gene significance\n"),
                   cex.main = 1.2, cex.lab = 1.2, cex.axis = 1.2, col = module)
#提取指定模块的基因名
module = "red"
probes = colnames(dataExp)
inModule = (moduleColors==module)
modprobes = probes[inModule]
modprobes
write.table(modprobes,file ="E:\\1A李倩倩\\liqianqian\\毕业论文结果图\\WGCNA\\probes_green.txt",row.names = F)
# 7出指定模块表达量的热图和柱状图
par(mfrow=c(2,1), mar=c(0,4.8,4,1.7))
which.module="greenyellow"
dat=dataExp[,moduleColors==which.module ] 
plotMat(t(scale(dat)),nrgcols=30,rlabels=F,
        clabels=F,rcols=which.module,
        title=which.module, cex.main=2)
par(mar=c(5,4.1,0.5,0.8))#设置图形空白边界行数，mar = c(bottom, left, top, right)。缺省为mar = c(5.1,4.1,4.1,2.1)
barplot(MES1$MEblue, col=which.module, main="", cex.main=2,
        ylab="eigengene expression",xlab="array sample")
#8WGCNA从module中挖掘hub基因
# Recalculate topological overlap
TOM = TOMsimilarityFromExpr(dataExp, power = 6); 
# Select module
module = "turquoise";
# Select module probes
probes = colnames(dataExp) ## 我们例子里面的probe就是基因名
inModule = (moduleColors==module)
modProbes = probes[inModule] 
# Select the corresponding Topological Overlap
modTOM = TOM[inModule, inModule]
dimnames(modTOM) = list(modProbes, modProbes)
dimnames(modTOM)
modTOM
## 模块对应的基因关系矩阵 
#然后是导出到cytoscape
setwd("E:\\1A李倩倩\\liqianqian\\毕业论文结果图\\WGCNA\\cytoscape")
cyt = exportNetworkToCytoscape(
  modTOM,
  edgeFile = paste("CytoscapeInput-edges-", paste(module, collapse="-"), ".txt", sep=""),
  nodeFile = paste("CytoscapeInput-nodes-", paste(module, collapse="-"), ".txt", sep=""),
  weighted = TRUE,
  threshold = 0.02,
  nodeNames = modProbes, 
  nodeAttr = moduleColors[inModule]
)
cyt
#9 画各个模块里面基因的一个表达模式
expColor=t(numbers2colors(log10(dataExp+1),colors = blueWhiteRed(100),naColor = "grey"))
colnames(expColor)=rownames(dataExp)
pdf("genecolor.pdf",width=400,height=500)
plotDendroAndColors(net$dendrograms[[1]],
                    colors=cbind(moduleColors[net$blockGenes[[1]]],expColor),
                    c("Module",colnames(expColor)),
                    dendroLabels = F,
                    hang = 0.03,
                    addGuide = T,
                    guideHang = 0.05,
                    cex.rowText=0.5)
colors=cbind(moduleColors[net$blockGenes[[1]]],expColor)
dev.off()
