#!/bin/bash

#Created by: William Lautert, Institute of Petroleum and Natural Resources, PUCRS-BR
# 'antismash_annotation.sh': Implements AntiSMASH pipeline on bacterial annotation files (.gbk) to infer secundary metabolite gene clusters.

# Variables 
GBK="/home/ipr/biosurf/analysis/AntiSMASH/gbk/GBK_Billgrantia"
#GBK_list="/home/ipr/biosurf/analysis/AntiSMASH/gbk/GBK_Billgrantia/gbk_list.txt"
GBK_list="/home/ipr/biosurf/analysis/AntiSMASH/gbk/GBK_Billgrantia/gbk_list_3.txt"
OUT_DIR="/home/ipr/biosurf/analysis/AntiSMASH/results/Billgrantia_287"

#Export variables
export GBK GBK_list OUT_DIR

# Run AntiSMASH

parallel -j 2 ' 
	NAME=$(basename -s .gbk {});
	antismash -t bacteria -c 13 --output-dir ${OUT_DIR}/${NAME} \
		--clusterhmmer \
		--tigrfam \
		--asf \
		--cc-mibig \
		--cb-general \
		--cb-subclusters \
		--cb-knownclusters \
		--pfam2go \
		--rre \
		--smcog-trees \
		--tfbs ${GBK}/{}' :::: "$GBK_list"


	

