#!/bin/bash
#PBS -l nodes=1:ppn=8
#PBS -l mem=31gb
#PBS -l walltime=30:00:00
#PBS -m abe
#PBS -M lhgioia@scripps.edu
## Plink2 Analysis


## set static directories
plink_src_dir="../kidney/results/plink/new_version"
meta_dir="./results"
vcf_dir="../kidney/results/gatk/new_final_recal_gVCFs"
pheno_dir="./src/pheno"


## choose batch to analyze
for batch in batch1 batch2 batch3; do

## set dynamic directories
# plink output
plink_results_dir="${meta_dir}/meta"


## generate plink format
${plink_src_dir}/plink --vcf ${vcf_dir}/${batch}_pass_anno.vcf --double-id --out ${plink_results_dir}/${batch}_raw

## assign phenotype based on list of CAN samples
${plink_src_dir}/plink --bfile ${plink_results_dir}/${batch}_raw --allow-no-sex --make-pheno ${pheno_dir}/${batch}\_can_pheno.txt '*' --make-bed --out ${plink_results_dir}/${batch}

## check hardy-weinberg equilibrium
${plink_src_dir}/plink --bfile ${plink_results_dir}/${batch} --geno 0.25 --allow-no-sex --hardy midp --out ${plink_results_dir}/${batch}

## fisher's exact
${plink_src_dir}/plink --bfile ${plink_results_dir}/${batch} --fam ${plink_results_dir}/${batch}.fam --geno 0.25 --ci 0.95 --allow-no-sex --assoc fisher-midp perm --out ${plink_results_dir}/${batch}


### Log Odds Ratio Calculation
head -n1 ${plink_results_dir}/${batch}.assoc.fisher | awk '{$1=$1; print $0}' OFS='\t' > plink_ci.header
sed 1d ${plink_results_dir}/${batch}.assoc.fisher | awk '{$9=log($9)/log(10); $10=sqrt(($9-(log($11)/log(10)))^2)/1.96 ;print $0}' OFS='\t' > ${plink_results_dir}/${batch}.assoc.fisher.logor.body
cat plink_ci.header ${plink_results_dir}/${batch}.assoc.fisher.logor.body > ${plink_results_dir}/${batch}.assoc.fisher.logor

done


### METAL Analysis
metal_src_dir="../kidney/results/metal/generic-metal"
metal_base_txt_dir="./src"

## run metal
${metal_src_dir}/metal ${metal_base_txt_dir}/metal_run.txt


exit=0
