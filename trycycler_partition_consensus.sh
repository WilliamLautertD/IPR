#!/bin/bash 
# Created by: William Lautert, Institute of Petroleum and Natural Resources, PUCRS-BR 
# 'trycycler_partition_consensus.sh': Partition reads between assembled clusters. Assign reads to each cluster. Then, it generates consensus sequences for each contig.


# Environmental variables

READS='/home/ipr/biosurf/analysis/Reads_QC/Nanopore_reads/trimmed_reads/trimming_3'
ASSEMBLY='/home/ipr/biosurf/analysis/assembly/Nanopore_Illumina'
threads=26

# Export variables

export READS ASSEMBLY threads
 

# 1) Cluster MSA


for i in $ASSEMBLY/*_trycycler; do
	#Extract base name (e.g.: BIOSURF_XXX)
	NAME=`basename -s _trycycler $i`
	
	for c in "$i"/cluster_*; do
		
		# Debugging output to verify paths
        	echo "Processing cluster: $c with reads: $READS/${NAME}_yes_illumina.fq.gz"
		
		# Run Trycycler partition
        	trycycler partition \
        	--reads "$READS/${NAME}_yes_illumina.fq.gz" \
        	--cluster_dir "$c" \
        	--threads "$threads"
        	
        	#Run trycycler consensus
        	trycycler consensus \
        	--cluster_dir "$c" \
        	--threads "$threads"
        	
        
        	medaka_consensus -i "$c"/4_reads.fastq \
		-d "$c"/7_final_consensus.fasta \
		-o "$c"/medaka -m r1041_e82_400bps_sup_v4.3.0 \
		-t "$threads"
    		mv "$c"/medaka/consensus.fasta "$c"/8_medaka.fasta
    		rm -r "$c"/medaka "$c"/*.fai "$c"/*.mmi  # clean up

    	done
done


