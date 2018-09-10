#!/bin/bash

in_dir="./results/fdr/plink"
out_dir="./results/fdr/plink/top_associations"

for batch in batch1 batch2 batch3; do
	for num in {1..100}; do
		for i in {1..10}; do
			sed 1d ${in_dir}/${batch}/${batch}_${num}_${i}.assoc.fisher.logor | sort -k8,8g | head -n 1 >> ${out_dir}/${batch}_top_pvalues.tsv
		done
	done
done

