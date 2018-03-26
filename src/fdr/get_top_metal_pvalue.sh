#!/bin/bash

in_dir="./results/fdr/metal/permutations"
out_dir="./results/fdr/metal/top_associations"

for num in {1..100}; do
	for i in {1..10}; do
		grep -v "nane" ${in_dir}/${num}_${i}1.txt | grep "+++" |  sort -k6,6g | head -n 1 >> ${out_dir}/top_pvalue.tsv
	
		 grep -v "nane" ${in_dir}/${num}_${i}1.txt | grep "+++" |  sort -k6,6g | head -n 2 | tail -n 1 >> ${out_dir}/2nd_pvalue.tsv

		 grep -v "nane" ${in_dir}/${num}_${i}1.txt | grep "+++" |  sort -k6,6g | head -n 3 | tail -n 1 >> ${out_dir}/3rd_pvalue.tsv
	
		 grep -v "nane" ${in_dir}/${num}_${i}1.txt | grep "+++" |  sort -k6,6g | head -n 4 | tail -n 1 >> ${out_dir}/4th_pvalue.tsv

	done
done

sort -k6,6g ${out_dir}/top_pvalue.tsv > ${out_dir}/top_pvalue_sorted.tsv
sort -k6,6g ${out_dir}/2nd_pvalue.tsv > ${out_dir}/2nd_pvalue_sorted.tsv
sort -k6,6g ${out_dir}/3rd_pvalue.tsv > ${out_dir}/3rd_pvalue_sorted.tsv
sort -k6,6g ${out_dir}/4th_pvalue.tsv > ${out_dir}/4th_pvalue_sorted.tsv

