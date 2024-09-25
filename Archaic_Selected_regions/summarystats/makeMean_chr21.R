# Compute the Mean in each bins across samples
# Author: MC
# updated April 11th, 2024 with 45 ancient samples, PP set to 0.8

rm(list=ls())
c=1
genome_data<-data.frame(matrix(ncol = 3, nrow = 0))
x<- c("chr","bin","mean")
colnames(genome_data)=x
chr=seq(1,22,1)
i=21
print(i)
input=paste("bindata_EUR_perCHR/bindata_ancientEUR_chr", i, sep = "")
data <- read.table(file=input, header = T)
dd=data[,2:NCOL(data)]
colnames(dd)=colnames(data)[-1]
b=NCOL(dd)
    for (j in seq(1,b,1))
    {
      x=dd[,j]
      genome_data[c,1]=i
      genome_data[c,2]=gsub("X","",colnames(dd)[j])
      genome_data[c,3]=mean(x)
      c=c+1
    }

write.table(genome_data,file="Summary_mean_21",sep = "\t",quote = F,row.names = F)

