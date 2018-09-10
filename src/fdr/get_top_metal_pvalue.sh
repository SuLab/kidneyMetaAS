#!/bin/bash

in_dir="./results/fdr/metal/permutations"
out_dir="./results/fdr/metal/top_associations"

for num in {1..100}; do
	for i in {1..10}; do
		grep -v "nane" ${in_dir}/${num}_${i}1.txt | grep "+++" |  sort -k6,6g | head -n 1 >> ${out_dir}/metal_fdr_top_pvalue.tsv	
	done
done

sort -k6,6g ${out_dir}/metal_fdr_top_pvalue.tsv > ${out_dir}/metal_fdr_top_pvalue_sorted.tsv


