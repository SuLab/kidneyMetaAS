#!/bin/bash
#PBS -l nodes=1:ppn=8
#PBS -l mem=31gb
#PBS -l walltime=80:00:00
#PBS -m abe
#PBS -M lhgioia@scripps.edu

module load gatk/3.3-0

variant_dir="./results/variant_calling/gatk"

hg19_reference="/UCSC/hg19/Sequence/WholeGenomeFasta/genome.fa"
dbsnp="/GATK/hg19/dbsnp_137.hg19.vcf"

for i in $variant_dir/*.vcf; do rawVCFs="$rawVCFs-V $i "; done

java -Xmx28g -jar `which GenomeAnalysisTK.jar` \
	-T CombineGVCFs \
	-R $hg19_reference \
	$rawVCFs \
  -o $variant_dir/merged.vcf 

java -Xmx28g -jar `which GenomeAnalysisTK.jar` \
	-T GenotypeGVCFs \
	-R $hg19_reference \
	-V $variant_dir/merged.vcf \
  -o $variant_dir/final.vcf \
  --dbsnp $dbsnp

exit 0
