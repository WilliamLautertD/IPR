#!/bin/bash

#Created by: William Lautert, Institute of Petroleum and Natural Resources, PUCRS-BR
# 'extract_can.sh': Extract Carbonic Anhydrase from Annotation files. All sequences containing "carbonic anhydrase" in its header will be extracted.

# Parameters
# Home
DIR='/home/ipr/biosurf/analysis/annotation/PGAP/Vreelandella_PGAP'
DIR_B='/home/ipr/biosurf/analysis/annotation/PGAP/Billgrantia_PGAP'
# Annotation ID folders
VREE='/home/ipr/biosurf/analysis/annotation/PGAP/Vreelandella_PGAP/list_PGAP_result.txt'
BILL='/home/ipr/biosurf/analysis/Phylogeny/genomes/Billgrantia_summary.txt'
# Output files
OUT_V='/home/ipr/biosurf/analysis/annotation/PGAP/Vreelandella_PGAP/CAN_Vreelandella'
OUT_B='/home/ipr/biosurf/analysis/annotation/PGAP/Billgrantia_PGAP/CAN_Billgrantia'

# export variables
export DIR DIR_B VREE BILL OUT

# 1. Run extraction for Vreelandella
parallel -j 26 "awk -v RS='>' '/carbonic anhydrase/ {print \">\"\$0}' \
	${DIR}/results_{}/annot_translated_cds.faa \
	> ${OUT_V}/{}_can_only.fasta" \
	:::: "${VREE}"

# 2. Run extraction for Billgrantia
parallel -j 26 "awk -v RS='>' '/carbonic anhydrase/ {print \">\"\$0}' \
	${DIR_B}/results_{}/annot_translated_cds.faa \
	> ${OUT_B}/{}_can_only.fasta" \
	:::: ${BILL}
	
	
# OBS
# debug first (i.e., see all the commands that would run without executing), add --dry-run to parallel
