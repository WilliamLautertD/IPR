#!/bin/bash 
# Created by: William Lautert, Institute of Petroleum and Natural Resources, PUCRS-BR 
# 'trycycler_polyshing.sh': Polyshing steps for Nanopore-only assemblies. 


# Environmental variables

READS='/home/ipr/biosurf/analysis/Reads_QC/Nanopore_reads/trimmed_reads/trimming_1'
ASSEMBLY='/home/ipr/biosurf/analysis/assembly/Nanopore'
threads=26

# Export variables

export READS ASSEMBLY threads
 

# 1) Nanopore-only assemblies


for i in $ASSEMBLY/*_trycycler; do
	for c in "$i"/cluster_*; do
		medaka_consensus -i "$c"/4_reads.fastq \
		-d "$c"/7_final_consensus.fasta \
		-o "$c"/medaka -m r1041_e82_400bps_sup_v4.3.0 \
		-t "$threads"
    		mv "$c"/medaka/consensus.fasta "$c"/8_medaka.fasta
    		rm -r "$c"/medaka "$c"/*.fai "$c"/*.mmi  # clean up
    done
done
