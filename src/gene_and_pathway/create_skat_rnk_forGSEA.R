#### Import SKAT Results ####
batchALLskatCR <- read.csv('kidneyMetaAS/results/gene_and_pathway/batchALL_cr_results.csv', header=T)

#### Generate .rnk files for GSEA ####
batchALLskat <- batchALLskatCR[,1:2]
batchALLskat$P.value <- -log10(batchALLskat$P.value)
batchALLskat <- subset(batchALLskat, !is.na(P.value) & P.value>0)
write.table(batchALLskat, file="kidneyMetaAS/results/gene_and_pathway/batchALL.rnk", quote=F, sep='\t', row.names=FALSE, col.names=FALSE)
