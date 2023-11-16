setwd("E:\\1A李倩倩\\liqianqian\\毕业论文结果图\\lincRNA的trans调控分析\\LW_MS-D1")
data <- read.delim("D1-trans-FPKM.txt", head=T, stringsAsFactors=F)
n <- nrow(data) # gene number
data <- matrix(unlist(data), nrow=n) # 閽堝data鏄釜list
result.total <- n*(n-1)/2
result <- matrix(0,result.total,3)
index <- 1 # 鍌ㄥ瓨缁撴灉鐢ㄧ殑
for(i in 1:n){
  gene1 <- data[i,-1]
  gene1 <- as.numeric(gene1)
  gene1.name <- data[i,1]
  for(j in (i+1):n){
    if(j > n) break
    gene2 <- data[j,-1]
    gene2 <- as.numeric(gene2)
    gene2.name <- data[j,1]
    correlation <- cor.test(gene1, gene2)
    result[index,3] <- correlation$p.value
    result[index,2] <- correlation$estimate
    name <- paste(gene1.name,gene2.name,sep="-")
    result[index,1] <- name
    index <- index+1 
  }
  # return(result)
}
write.csv(result, "D1-gene correlation result1.csv", row.names=F) # 涓ょ鍌ㄥ瓨鏍煎紡
write.table(result, "gene correlation result.txt", row.names=F,col.names=F, quote=F, sep="\t")