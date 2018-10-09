
skat_dir <- "kidneyMetaAS/results/gene_and_pathway/"

#### Import SKAT Results ####
batchALLskatCR <- read.csv(paste(skat_dir, "batchAll_cr_results", sep=""), header=T)

#### Create Summary Table of SKAT Results ####
batchALLskatCRSig <- batchALLskatCR[which(batchALLskatCR$P.value < 0.0005),]

batchALLskatCRSig$cohort <- "ALL"

batchALLskatCRSig$pop <- "Mixed"

skatSig <- data.frame()
skatSig <- batchALLskatCRSig
skatSig <- skatSig[order(skatSig$P.value),]

write.table(skatSig, file=paste(skat_dir, "skat_variants.tsv", sep=""), sep='\t', row.names=FALSE)
