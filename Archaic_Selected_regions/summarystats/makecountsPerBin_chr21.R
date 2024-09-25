# Count sample sizes per bin in EMH samples
# Author: MC
# updated April 26th, 2024 with 45 ancient samples, PP set to 0.8
rm(list=ls())

#for (chr in seq(1,22,1))
#{
chr=21
k=0;
sample_size<-data.frame(matrix(ncol = 3, nrow = 0))
x<- c("chr","bin","size")
colnames(sample_size)=x
print(chr)
rawinput=paste("bindata_EUR_perCHR/bindata_ancientEUR_chr", chr, sep = "")
rawdata <- read.table(file=rawinput, header = T)
raw_dd=rawdata[,2:NCOL(rawdata)]
colnames(raw_dd)=colnames(rawdata)[-1]
bins=NCOL(raw_dd)
for (j in seq(0,bins,1))
{
  x_col=raw_dd[,j]
  b=gsub("X","",colnames(raw_dd)[j])
  sample_size[k,1]=chr
  sample_size[k,2]=b
  sample_size[k,3]=length(which(x_col != 0)) 
  k=k+1
}
outfile=paste("sample_size_", chr, sep = "")
write.table(sample_size,file=outfile,sep = "\t",quote = F,row.names = F)

#}
