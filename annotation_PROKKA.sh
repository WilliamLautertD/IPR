#!/bin/bash 
# Created by: William Lautert, Institute of Petroleum and Natural Resources, PUCRS-BR 
# 'annotation_PROKKA.sh': Genome annotation using PROKKA.


# Environmental variables
ASSEMBLY='/home/ipr/biosurf/analysis/assembly/Nanopore/'
OUT_DIR='/home/ipr/biosurf/analysis/annotation/PROKKA'
threads=25

# Export variables

export ASSEMBLY OUT_DIR threads
 
# 1) Read clustering

find "$ASSEMBLY" -name '*_trycycler' | parallel -j 1 '
	
	NAME=$(basename "{}" _trycycler); 

	#mkdir -p "$OUT_DIR/${NAME}_PROKKA"

	prokka --compliant --centre IPR \
	--outdir "$OUT_DIR"/${NAME}_PROKKA \
	--addgene \
	--addmrna \
	--rnammer \
	--rfam \
	--cpus "$threads" \
	"{}/cluster_001/8_medaka.fasta"
'


