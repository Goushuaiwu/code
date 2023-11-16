
library(ggplot2)
volcano_data <- read.csv("C:\\Users\\Administrator\\Desktop\\LW_MS_D180.txt",header = T,sep = "\t",comment.char="",stringsAsFactors=F)
loc_up <- intersect(which(volcano_data$pvalue<0.05),which(volcano_data$log2FoldChange>=1))
loc_down <- intersect(which(volcano_data$pvalue<0.05),which(volcano_data$log2FoldChange<=(-1)))
significant <- rep("normal",times=nrow(volcano_data))
significant[loc_up] <- "up"
significant[loc_down] <- "down"
significant <- factor(significant,levels=c("up","down","normal"))
p <- qplot(x=volcano_data$log2FoldChange,y=-log10(volcano_data$pvalue),xlab="log2(FoldChange)",ylab="-log1O(Pvalue)",
size=I(1.3),colour=significant)
p <- p+ scale_color_manual(values=c("up"="firebrick3","normal"="grey","down"="navy"))
xline=c(-log2(2),log2(2))
p <- p+geom_vline(xintercept=xline,lty=2,size=I(0.2),colour="grey11")
yline=-log(0.05,10)
p <- p+geom_hline(yintercept=yline,lty=2,size=I(0.2),colour="grey11")
p <- p+theme_bw()+theme(panel.background=element_rect(colour="black", size=1, fill="white"),panel.grid=element_blank())+ggtitle("LW180 vs MS180")+
  theme(plot.title = element_text(hjust = 0.5,size=rel(1.0)))
p
pdf("Volcano.pdf")
print(p)
dev.off()

png("Volcano.png",width=3000,height=3000,res=500)
print(p)
dev.off()