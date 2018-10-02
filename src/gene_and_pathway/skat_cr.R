library(SKAT)

plink_dir <- "kidneyMetaAS/results/meta/"
skat_dir <- "kidneyMetaAS/results/gene_and_pathway/"

Generate_SSD_SetID(paste(plink_dir, "batchALL.bed", sep=""),
 paste(plink_dir, "batchALL.bim", sep=""),
 paste(plink_dir, "batchALL.fam", sep=""),
 paste(skat_dir, "batchALL.setID", sep=""),
 paste(skat_dir, "batchALL.SSD", sep=""),
 paste(skat_dir, "batchALL.skatInfo", sep=""))

fam <- Read_Plink_FAM(paste(plink_dir, "batchALL.fam", sep=""))
y <- fam$Phenotype
obj <- SKAT_Null_Model_MomentAdjust(y ~ 1)

testCR <- SKAT_CommonRare.SSD.All(Open_SSD(paste(skat_dir, "batchALL.SSD", sep=""),
 paste(skat_dir, "batchALL.skatInfo", sep="")), obj, method="A")

write.csv(testCR$results[order(testCR$results$P.value),], file=paste(skat_dir, "batchAll_cr_results.csv", sep=""), row.names=FALSE)
