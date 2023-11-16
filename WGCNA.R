source("http://bioconductor.org/biocLite.R")
biocLite(c("AnnotationDbi", "impute", "GO.db", "preprocessCore"))
install.packages("WGCNA")
library(WGCNA)
#1���ػ����������
Data = read.csv("E:\\1A��ٻٻ\\liqianqian\\��ҵ���Ľ��ͼ\\WGCNA\\WGCNA_input.csv", header=T,stringsAsFactors = FALSE)##Ĭ�ϵ� R ����ַ������ӻ�����ǰ����£�����ر�������ܡ�
dim(Data)
head(Data)
names(Data)#�鿴�����ֶ�����
row.names(Data) <- Data$geneID #�Ƚ��ڵ�һ�б������
Data1 <- Data[,-1] #�ѵ�һ��ɾ��
dataExp = as.data.frame(t(Data1))
dataExp[seq(1,18),seq(1,4)]
gsg = goodSamplesGenes(dataExp, verbose = 3)
gsg$allOK
gsg$goodGenes
gsg$goodSamples 
#2�鿴�Ƿ�����Ⱥֵ
sampleTree = hclust(dist(dataExp), method = "average");
sizeGrWindow(12,9)
#pdf(file = "Plots/sampleClustering.pdf", width = 12, height = 9);
par(cex = 0.6);
par(mar = c(0,4,2,0))
plot(sampleTree, main = "Sample clustering to detect outliers", sub="", xlab="", cex.lab = 1.5,
     cex.axis = 1.5, cex.main = 2)
#3������״����
alltraitData = read.csv("E:\\1A��ٻٻ\\liqianqian\\��ҵ���Ľ��ͼ\\WGCNA\\trait1.csv",header=T,stringsAsFactors = FALSE);
dim(alltraitData)
names(alltraitData)
femaleSamples = rownames(dataExp)
traitRows = match(femaleSamples, alltraitData$sampleid) #match(x,y)  x��y ��������match ���ؽ���� x ��ÿһ���� y �е�������
traitRows
datTraits = alltraitData[traitRows, -1]
datTraits
rownames(datTraits) = alltraitData[traitRows, 1]
rownames(datTraits)
collectGarbage()
#4����ֵ��ѡ��
powers = c(c(1:10), seq(from = 12, to=20, by=2))# �趨����ֵ��Χ
sft = pickSoftThreshold(dataExp, powerVector = powers,verbose = 5)# ��ø�����ֵ�µ� R�� ��ƽ�����Ӷ� verbose��ʾ��������ϸ�̶�
str(sft)# sft���б�����ÿ��powersֵ�����������������,����powerEstimate�������powerֵ��fitIndices������ÿ��power��Ӧ�������������
sizeGrWindow(9, 5) #��һ��ͼ�δ�����ָ���ĳߴ�
par(mfrow = c(1,2))# ����ͼ����ʾһ������
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
# ���ٽ�����תΪ Tom ����
adjacency = adjacency(datExpr, power = softPower)
TOM = TOMsimilarity(adjacency);
# �������֮��������
dissTOM = 1-TOM
hierTOM = hclust(as.dist(dissTOM),method="average")
k <- softConnectivity(dataExp,power=7) 
sizeGrWindow(10, 5)
par(mfrow=c(1,2))
hist(k)
scaleFreePlot(k,main="Check Scale free topology\n")
#5����ģ��Ļ���
net = blockwiseModules(dataExp, power = 7,TOMType = "unsigned", minModuleSize = 30,reassignThreshold = 0, 
                       mergeCutHeight = 0.25,numericLabels = T, pamRespectsDendro = FALSE,saveTOMs = TRUE,
                       saveTOMFileBase = "LWMSTOM",verbose = 3)#for type = "unsigned", adjacency = |cor|^power
table(net$colors)#�������ڻص����������Ҫ�鿴��ʶ�˶��ٸ�ģ���Լ�ģ���С
# ��ͼ�ʹ���
sizeGrWindow(12, 9)
# ��ģ����ת������ɫֵ
mergedColors = labels2colors(net$colors)
#���ƾ���ͼ��ɫ��
plotDendroAndColors(net$dendrograms[[1]], mergedColors[net$blockGenes[[1]]],
                    "Module colors",
                    dendroLabels = FALSE, hang = 0.03,
                    addGuide = TRUE, guideHang = 0.05)#�˺�������һ����ξ�����״ͼ�Ͳ�ɫע�ͣ�S���µ���״ͼ�Ķ���
#����������������ģ������ģ�鱾����Ϣ��
moduleLabels = net$colors
moduleColors = labels2colors(net$colors)
moduleColors
MEs = net$MEs
MEs
geneTree = net$dendrograms[[1]];
save(MEs, moduleLabels, moduleColors, geneTree,
     file = "FemaleLiver-02-networkConstruction-auto.RData")
#5����ģ��-���ʹ���
# ��û�������������
nGenes = ncol(dataExp)
nSamples = nrow(dataExp)
# �ò�ɫ��ǩ���¼���MEs
# �ڸ����ĵ������ݼ��м���ģ���ģ�鱾������
MEs0 = moduleEigengenes(dataExp, moduleColors) 
MEs0
MES1 = MEs0$eigengenes
# �Ը����ģ�������������������������ʹ���Ƶ������˴�����
MEs = orderMEs(MES1)
# ����module��MEֵ����͵����ϵ��
moduleTraitCor = cor(MEs, datTraits, use = "p");
moduleTraitPvalue = corPvalueStudent(moduleTraitCor, nSamples)
names(MEs)
# sizeGrWindow(10,6)
# ��ʾ����Լ���pֵ
textMatrix = paste(signif(moduleTraitCor, 2), "\n(",signif(moduleTraitPvalue, 1), ")", sep = "");
dim(textMatrix) = dim(moduleTraitCor)
par(mar = c(6, 8.5, 3, 3));
# Display the correlation values within a heatmap plot\
# ySymbols ��ylabelsʹ��ʱ��ʹ�õ�������ǩ�� colorLabels Ӧ��ʹ����ɫ��ǩ��
# colors ��ɫ�� textMatrix ��Ԫ������
labeledHeatmap(Matrix = moduleTraitCor,xLabels = names(datTraits),yLabels = names(MEs),ySymbols = names(MEs),
               colorLabels = FALSE,colors = blueWhiteRed(50),textMatrix = textMatrix,setStdMargins = FALSE,
               cex.text = 0.5,zlim = c(-1,1), yColorWidth = 0.05, xLabelsAngle = 45,xLabelsAdj = 0.9,
               main = paste("Module-trait relationships"))
# 6�����ģ������ϵ��
modNames = substring(names(MEs), 3)
geneModuleMembership = as.data.frame(cor(dataExp, MEs, use = "p"))
MMPvalue = as.data.frame(corPvalueStudent(as.matrix(geneModuleMembership), nSamples))
names(geneModuleMembership) = paste("MM", modNames, sep="")
names(MMPvalue) = paste("p.MM", modNames, sep="")
#7gene����״�Ĺ�ϵ
# ���������������Ȩ���еı���Ȩ��
LW_D1 = as.data.frame(datTraits$LW.D1)
names(LW_D1) = "LW_D1"
geneTraitSignificance = as.data.frame(cor(dataExp, LW_D1, use = "p"))
GSPvalue = as.data.frame(corPvalueStudent(as.matrix(geneTraitSignificance), nSamples))
names(geneTraitSignificance) = paste("GS.", names(LW_D1), sep="")
names(GSPvalue) = paste("p.GS.", names(LW_D1), sep="")
# ģ����ɫ
module = "turquoise"
# ƥ����
column = match(module, modNames)
moduleGenes = moduleColors==module
#sizeGrWindow(7, 7)
par(mfrow = c(1,1))
# ��ɢ��ͼ
verboseScatterplot(abs(geneModuleMembership[moduleGenes, column]),
                   abs(geneTraitSignificance[moduleGenes, 1]),
                   xlab = paste("Module Membership in", module, "module"),
                   ylab = "Gene significance for body weight",
                   main = paste("Module membership vs. gene significance\n"),
                   cex.main = 1.2, cex.lab = 1.2, cex.axis = 1.2, col = module)
#��ȡָ��ģ��Ļ�����
module = "red"
probes = colnames(dataExp)
inModule = (moduleColors==module)
modprobes = probes[inModule]
modprobes
write.table(modprobes,file ="E:\\1A��ٻٻ\\liqianqian\\��ҵ���Ľ��ͼ\\WGCNA\\probes_green.txt",row.names = F)
# 7��ָ��ģ�����������ͼ����״ͼ
par(mfrow=c(2,1), mar=c(0,4.8,4,1.7))
which.module="greenyellow"
dat=dataExp[,moduleColors==which.module ] 
plotMat(t(scale(dat)),nrgcols=30,rlabels=F,
        clabels=F,rcols=which.module,
        title=which.module, cex.main=2)
par(mar=c(5,4.1,0.5,0.8))#����ͼ�οհױ߽�������mar = c(bottom, left, top, right)��ȱʡΪmar = c(5.1,4.1,4.1,2.1)
barplot(MES1$MEblue, col=which.module, main="", cex.main=2,
        ylab="eigengene expression",xlab="array sample")
#8WGCNA��module���ھ�hub����
# Recalculate topological overlap
TOM = TOMsimilarityFromExpr(dataExp, power = 6); 
# Select module
module = "turquoise";
# Select module probes
probes = colnames(dataExp) ## �������������probe���ǻ�����
inModule = (moduleColors==module)
modProbes = probes[inModule] 
# Select the corresponding Topological Overlap
modTOM = TOM[inModule, inModule]
dimnames(modTOM) = list(modProbes, modProbes)
dimnames(modTOM)
modTOM
## ģ���Ӧ�Ļ����ϵ���� 
#Ȼ���ǵ�����cytoscape
setwd("E:\\1A��ٻٻ\\liqianqian\\��ҵ���Ľ��ͼ\\WGCNA\\cytoscape")
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
#9 ������ģ����������һ������ģʽ
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