
library("sqldf")

data_dir <- "kidneyMetaAS/results/vcf/"
results_dir <- "kidneyMetaAS/results/gene_and_pathway/"

## glist is from https://www.cog-genomics.org/static/bin/plink/glist-hg19
glist <- read.table(paste(data_dir, "glist-hg19", sep=""), stringsAsFactors=F, header=F, sep=" ")
names(glist) <- c("CHR", "Start", "End", "Gene")

## 3col vcfs are just the chromosome, basepair, and snp ID columns from the vcf files
batchALLvcf <- read.csv(paste(data_dir, "batchALL_3col.vcf", sep=""), stringsAsFactors=FALSE, header=F, sep='\t', comment.char="#")
names(batchALLvcf) <- c("CHR", "BP", "SNP")
batchALLvcf$CHR <- gsub("chr", "", batchALLvcf$CHR)

batchALLgenes <- sqldf("select * from batchALLvcf f1 left join glist f2 on (f1.CHR == f2.CHR and f1.BP >= f2.Start and f1.BP <= f2.End) ")
batchALLgenes <- batchALLgenes[,c(1,2,3,7)]
batchALLgenes <- batchALLgenes[-which(is.na(batchALLgenes$Gene)),]
for(i in 1:nrow(batchALLgenes)){
  if(batchALLgenes$SNP[i]=="."){
    batchALLgenes$SNP[i] <- paste("chr", batchALLgenes$CHR[i], ":", batchALLgenes$BP[i], sep="")
  }
}
write.table(batchALLgenes[,c("Gene", "SNP")], file=paste(results_dir, "batchALL.setID", sep=""), quote=F, sep='\t', row.names=FALSE, col.names=FALSE)

