###################################
#### METAL FDR Launcher Script ####
###################################

## run from kidneyMetaAS directory


for number in {1..50}; do

qsub -N metal_fdr_$number -v number=$number ./src/fdr/metal_fdr.sh

done

