#!/bin/bash
#PBS -l nodes=1:ppn=8
#PBS -l mem=31gb
#PBS -l walltime=30:00:00
#PBS -m n
#PBS -M lhgioia@scripps.edu

############################
#### metal FDR analysis ####
############################

## get analysis number (split into 50 jobs with 10 iterations per job)
num=$number

sub="pass_anno"

## set static directories
plink_src_dir="../kidney/results/plink/new_version"
meta_dir="./results"

## choose batch
for batch in batch1 batch2 batch3; do

## set dynamic directories
# store plink data
plink_data_dir="${meta_dir}/fdr/plink/${batch}"
# plink phenotype and samples list
pheno_dir="./src/pheno"


## choose sample number based on batch number
if [ "$batch" == "batch1" ]; then
	sample_number="42"
fi
if [ "$batch" == "batch2" ]; then
	sample_number="28"
fi
if [ "$batch" == "batch3" ]; then
	sample_number="48"
fi


### PLINK
## create original raw plink files
${plink_src_dir}/plink --vcf /gpfs/group/su/lhgioia/kidney/results/gatk/new_final_recal_gVCFs/${batch}_pass_anno.vcf --double-id --out ${plink_data_dir}/${batch}_raw${num}

## take a thousand samples
for i in {1..10}; do

## generate random case phenotype file
shuf ${pheno_dir}/${batch}_samples.txt | head -n ${sample_number} > ${plink_data_dir}/${batch}_${num}_pheno${i}.txt

## assign phenotype based on list of CAN samples
${plink_src_dir}/plink --bfile ${plink_data_dir}/${batch}_raw${num} --allow-no-sex --make-pheno ${plink_data_dir}/${batch}_${num}_pheno${i}.txt '*' --make-bed --out ${plink_data_dir}/${batch}_${num}_${i}

## fisher's exact
${plink_src_dir}/plink --bfile ${plink_data_dir}/${batch}_${num}_${i} --fam ${plink_data_dir}/${batch}_${num}_${i}.fam --geno 0.25 --ci 0.95 --allow-no-sex --assoc fisher-midp perm --out ${plink_data_dir}/${batch}_${num}_${i}


### Log Odds Ratio Calculation
head -n1 ${plink_data_dir}/${batch}_${num}_${i}.assoc.fisher | awk '{$1=$1; print $0}' OFS='\t' > plink_ci.header
sed 1d ${plink_data_dir}/${batch}_${num}_${i}.assoc.fisher | awk '{$9=log($9)/log(10); $10=sqrt(($9-(log($11)/log(10)))^2)/1.96 ;print $0}' OFS='\t' > ${plink_data_dir}/${batch}_${num}_${i}.assoc.fisher.logor.body
cat plink_ci.header ${plink_data_dir}/${batch}_${num}_${i}.assoc.fisher.logor.body > ${plink_data_dir}/${batch}_${num}_${i}.assoc.fisher.logor

done

done

### METAL Analysis
for i in {1..10}; do

metal_src_dir="../kidney/results/metal/generic-metal"

metal_base_txt_dir="./src"

metal_fdr_txt_dir="${meta_dir}/fdr/metal/txt_files/"
metal_results_dir="${meta_dir}/fdr/metal/permutations/"

## create metal txt file
# keywords to change: NUM, ITER
sed "s/NUM/$num/g" ${metal_base_txt_dir}/metal_fdr_base.txt | \
sed "s/ITER/$i/g" > ${metal_fdr_txt_dir}/${num}_${i}.txt

## run metal
${metal_src_dir}/metal ${metal_fdr_txt_dir}/${num}_${i}.txt

done

exit=0
