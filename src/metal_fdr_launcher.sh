###################################
#### METAL FDR Launcher Script ####
###################################

for number in {1..50}; do

qsub -N metal_fdr_$number -v number=$number /gpfs/group/su/lhgioia/kidney/src/meta_manuscript/metal_fdr.sh

done

