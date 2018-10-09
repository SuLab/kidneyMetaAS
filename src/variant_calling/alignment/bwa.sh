#!/bin/bash
#PBS -l nodes=1:ppn=8
#PBS -l mem=31gb
#PBS -l walltime=52:00:00
#PBS -m abe
#PBS -M lhgioia@scripps.edu


module load bwa/0.7.10
module load picard/1.103
module load samtools/1.0

sample_dir="./data"
alignment_dir="./results/variant_calling/alignment"

bwa_index="/UCSC/hg19/Sequence/BWAIndex/genome.fa"


## align to hg19
bwa mem -M -t 8 $bwa_index $sample_dir/$sample\_R1.fq.gz $sample_dir/$sample\_R2.fq.gz > $alignment_dir/$sample.sam


## create read group
java -Xmx28g -jar `which AddOrReplaceReadGroups.jar` \
	I=$alignment_dir/$sample.sam \
	O=$alignment_dir/$sample\_sorted.bam \
	SORT_ORDER=coordinate \
	VALIDATION_STRINGENCY=LENIENT \
	MAX_RECORDS_IN_RAM=5000000 \
	ID=1 \
	LB=batch1 \
	PL=illumina \
	PU=1234 \
	SM=$sample


## picard mark duplicates
java -Xmx28g -jar `which MarkDuplicates.jar` \
	I=$alignment_dir/$sample\_sorted.bam \
	O=$alignment_dir/$sample\_dedup.bam \
	M=$alignment_dir/$sample\_metrics.txt \
	ASSUME_SORTED=true \
	VALIDATION_STRINGENCY=LENIENT


## index the bam file
java -Xmx28g -jar `which BuildBamIndex.jar` \
	I=$alignment_dir/$sample\_dedup.bam


exit 0
