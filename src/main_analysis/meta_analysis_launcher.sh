###################################
#### METAL FDR Launcher Script ####
###################################

## run from kidneyMetaAS directory
qsub -N meta_analysis -o ./results/logs/meta_analysis_standard_output.txt -e ./results/logs/meta_analysis_standard_error.txt ./src/meta_analysis.sh


