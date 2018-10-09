#!/bin/bash
#PBS -l nodes=1:ppn=8
#PBS -l mem=31gb
#PBS -l walltime=60:00:00
#PBS -m abe
#PBS -M lhgioia@scripps.edu

module load gatk/3.3-0

sample=$SpecimenID
alignment_dir="./results/variant_calling/alignment"
variant_dir="./results/variant_calling/gatk"

hg19_reference="/UCSC/hg19/Sequence/WholeGenomeFasta/genome.fa"
dbsnp="/GATK/hg19/dbsnp_137.hg19.vcf" 
mills="/GATK/hg19/Mills_and_1000G_gold_standard.indels.hg19.vcf"
g1000="/GATK/hg19/1000G_phase1.indels.hg19.vcf"
capture_kit_bed="./data/union.bed"


java -Xmx28g -jar `which GenomeAnalysisTK.jar` \
    -T RealignerTargetCreator -nt 8 \
    -R $hg19_reference \
    -I $alignment_dir/$sample\_dedup.bam \
    -o $variant_dir/$sample.intervals \
    -L $capture_kit_bed \
    --fix_misencoded_quality_scores \
    -known $mills \
    -known $g1000

java -Xmx28g -jar `which GenomeAnalysisTK.jar` \
    -T IndelRealigner \
    -R $hg19_reference \
    -I $alignment_dir/$sample\_dedup.bam \
    -targetIntervals $variant_dir/$sample.intervals \
    -o $variant_dir/$sample\_realigned.bam \
    --fix_misencoded_quality_scores \
    -known $mills \
    -known $g1000

java -Xmx28g -jar `which GenomeAnalysisTK.jar` \
    -T BaseRecalibrator -nct 8 \
    -R $hg19_reference \
    -I $variant_dir/$sample\_realigned.bam  \
    -L $capture_kit_bed \
    -o $variant_dir/$sample\_recal_data.table \
    -knownSites $dbsnp \
    -knownSites $mills \
    -knownSites $g1000

java -Xmx28g -jar `which GenomeAnalysisTK.jar` \
    -T PrintReads -nct 8 \
    -R $hg19_reference \
    -I $variant_dir/$sample\_realigned.bam \
    -L $capture_kit_bed \
    -BQSR $variant_dir/$sample\_recal_data.table \
    -o $variant_dir/$sample\_recal.bam

java -Xmx28g -jar `which GenomeAnalysisTK.jar` \
	-T HaplotypeCaller \
	-nct 8 \
	-R $hg19_reference \
	--dbsnp $dbsnp \
	-I $variant_dir/$sample\_recal.bam \
	-o $variant_dir/$sample.vcf \
	--emitRefConfidence GVCF \
    --variant_index_type LINEAR \
    --variant_index_parameter 128000

exit 0
