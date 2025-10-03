#!/bin/bash 
# Created by: William Lautert, Institute of Petroleum and Natural Resources, PUCRS-BR 
# 'trycycler_assembly_clustering_2_254_274.sh': Cluster contigs from multiple assemblies for the isolates 254 and 274 reads subsamples. Number of assemblies = 24


# Environmental variables

READS='/home/ipr/biosurf/analysis/Reads_QC/Nanopore_reads/trimmed_reads/trimming_1/'
ASSEMBLY='/home/ipr/biosurf/analysis/assembly/Nanopore'
OUT_DIR='/home/ipr/biosurf/analysis/assembly/Nanopore'
threads=26

# Export variables

export READS ASSEMBLY OUT_DIR threads
 
# 1) Read CLUSTERING

for name in BIOSURF_254 BIOSURF_274; do
    find "$ASSEMBLY" -name "${name}_no_illumina_assembly" | parallel -j 1 '
        
        NAME=$(basename "{}" _no_illumina_assembly);
        
        # Create output directory
        mkdir -p "$OUT_DIR/${NAME}_trycycler_2"

        # Run Trycycler clustering
        trycycler cluster \
            --assemblies "{}"/*.fasta \
            --reads "$READS/${NAME}_no_illumina.fq.gz" \
            --out_dir "$OUT_DIR/${NAME}_trycycler_2" \
            -t "$threads"
    ' 
done
