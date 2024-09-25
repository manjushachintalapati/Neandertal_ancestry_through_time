# Compute the Z-score and SE across samples
# Author: MC
# updated April 11th, 2024 with 45 ancient samples, PP set to 0.8

rm(list=ls())
# first computing the genomewide mean and SD
data <- read.table(file="Summary_mean_All", header = T)
genomewide_mean=mean(data$mean)
genomewide_sd=sd(data$mean)

print(genomewide_mean)
print(genomewide_sd)

# For each row containing the mean per col- compute the Z score using genome wide mean and SD

c=1
chr=21 # replace the chr number to process all the chromosomes
print(c)
input=paste("Summary_mean_", chr, sep = "")
data <- read.table(file=input, header = T)
c=1
genomewide_data<-data.frame(matrix(ncol = 8, nrow = 0))
x<- c("chr","bin","mean","z","bin","mean","se","z_sample")
colnames(genomewide_data)=x
len=seq(1,NROW(data),1)
print(NROW(data))
for (i in len)
{
  x=data[i,]
  genomewide_data[c,1]=x$chr
  genomewide_data[c,2]=x$bin
  genomewide_data[c,3]=x$mean
  genomewide_data[c,4]=(x$mean-genomewide_mean)/genomewide_sd
  c=c+1
}

print(c)
write.table(genomewide_data,file="genomeStats_21",sep = "\t",quote = F,row.names = F)

