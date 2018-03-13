#!/bin/bash

in_dir="/gpfs/group/su/lhgioia/kidneyMetaAS/results/meta"
out_dir="/gpfs/group/su/lhgioia/kidneyMetaAS/results/meta"

grep -v "nane" ${in_dir}/metal_output1.txt | grep "+++" |  sort -k6,6g > ${out_dir}/metal_output_sorted.tsv

