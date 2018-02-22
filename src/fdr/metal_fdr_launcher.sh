###################################
#### METAL FDR Launcher Script ####
###################################

## run from kidneyMetaAS directory


for number in {1..50}; do

qsub -N metal_fdr_$number -v number=$number -o ./results/logs/metal_fdr_standard_output_${number}.txt -e ./results/logs/metal_fdr_standard_error_${number}.txt ./src/fdr/metal_fdr.sh

done

