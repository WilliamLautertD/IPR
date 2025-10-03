#!/bin/bash 
# Created by: William Lautert, Institute of Petroleum and Natural Resources, PUCRS-BR 
# 'trycycler_cluster_MSA.sh': Multiple sequence alignment for each cluste.


# Environmental variables

READS='/home/ipr/biosurf/analysis/Reads_QC/Nanopore_reads/trimmed_reads/trimming_3'
ASSEMBLY='/home/ipr/biosurf/analysis/assembly/Nanopore_Illumina'
threads=26

# Export variables

export READS ASSEMBLY threads
 

# 1) Cluster MSA


for i in $ASSEMBLY/*_trycycler
do
    for c in "$i"/cluster_*
    do
        #echo 
        trycycler msa \
        --cluster_dir "$c" \
        --threads "$threads"
    done
done
