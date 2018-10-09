#!/bin/bash
## run gsea for all batches and pathways

for batch in batchALL; do \
	for db in hallmarks; do \

		if [ $db == "hallmarks" ]; then dbDIR="gseaftp.broadinstitute.org://pub/gsea/gene_sets/h.all.v5.0.symbols.gmt"; fi
		if [ $db == "c2all" ]; then dbDIR="gseaftp.broadinstitute.org://pub/gsea/gene_sets/c2.all.v5.0.symbols.gmt"; fi
		if [ $db == "c5go" ]; then dbDIR="gseaftp.broadinstitute.org://pub/gsea/gene_sets/c5.all.v5.0.symbols.gmt"; fi
		if [ $db == "c7imm" ]; then dbDIR="gseaftp.broadinstitute.org://pub/gsea/gene_sets/c7.all.v5.0.symbols.gmt"; fi

java -Xmx2000m -cp ~/Downloads/gsea2-2.2.0.jar \
	xtools.gsea.GseaPreranked \
	-gmx $dbDIR \
	-collapse false \
	-mode Max_probe \
	-norm meandiv \
	-nperm 1000 \
	-rnk ./results/gene_and_pathway/${batch}.rnk \
	-scoring_scheme classic \
	-rpt_label ${batch}_$db \
	-include_only_symbols true \
	-make_sets true \
	-plot_top_x 10 \
	-rnd_seed timestamp \
	-set_max 1500 \
	-set_min 10 \
	-zip_report false \
	-out ./results/gene_and_pathway/${batch} \
	-gui false

	done
done

exit=0
