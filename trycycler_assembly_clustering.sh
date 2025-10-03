#!/bin/bash 
# Created by: William Lautert, Institute of Petroleum and Natural Resources, PUCRS-BR 
# 'trycycler_assembly_clustering.sh': Cluster contigs from multiple assemblies.


# Environmental variables

READS='/home/ipr/biosurf/analysis/Reads_QC/Nanopore_reads/trimmed_reads/trimming_3/'
ASSEMBLY='/home/ipr/biosurf/analysis/assembly/Nanopore_Illumina'
OUT_DIR='/home/ipr/biosurf/analysis/assembly/Nanopore_Illumina'
threads=25

# Export variables

export READS ASSEMBLY OUT_DIR threads
 
# 1) Read clustering

find "$ASSEMBLY" -name '*_yes_illumina_assembly' | parallel -j 1 '
	
	NAME=$(basename "{}" _yes_illumina_assembly); 
	
	# Create output directory
	mkdir -p "$OUT_DIR/${NAME}_trycycler"
	
	trycycler cluster \
	--assemblies "{}"/*.fasta \
	--reads "$READS/${NAME}_yes_illumina.fq.gz" \
	--out_dir "$OUT_DIR/${NAME}_trycycler" \
	-t "$threads"

'


