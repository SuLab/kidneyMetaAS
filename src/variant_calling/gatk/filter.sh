#!/bin/bash
#PBS -l nodes=1:ppn=8
#PBS -l mem=31gb
#PBS -l walltime=30:00:00
#PBS -m abe
#PBS -M lhgioia@scripps.edu

module load vcftools
module load snpeff/3.5

recal_dir="./results/variant_calling/gatk"

vcftools --vcf $recal_dir/recal_SNP_INDEL.vcf --remove-filtered-all --recode --recode-INFO-all --out $recal_dir/_pass;

java -jar snpEff.jar -v hg19 -noStats $recal_dir/pass.recode.vcf > $recal_dir/pass_annotated.vcf;

exit 0
