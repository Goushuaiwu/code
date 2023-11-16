rm(list=ls())
library(ggplot2)
library(stringr)
setwd("E:\\Desktop")
PATHWAY <- read.table("BLUE-DAVID.txt",header = T,sep="\t",quote = "")
ggplot(data=PATHWAY)+
  geom_bar(aes(x=reorder(Term,Count),y=Count),fill="BLUE",stat='identity',width = 0.6) + 
  xlab("Term ") +
  ylab("Gene count") +
  scale_y_continuous(expand=c(0, 0))+
  coord_flip() +
  theme(
    axis.text.y = element_text(color="black",size = 20),
    axis.text.x = element_text(color="black",size = 20),
    axis.title.x = element_text(size=20),
    axis.title.y = element_text(size=20,vjust = 0.5))+
  theme(plot.title = element_text(hjust = 0.5,size=rel(0.8)))
  
