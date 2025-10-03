#!/bin/bash 
# Created by: William Lautert, Institute of Petroleum and Natural Resources, PUCRS-BR 
# 'trycycler_reconcile_contigs.sh': Reconcile contigs for each good cluster within the assemblies.


# Environmental variables

READS='/home/ipr/biosurf/analysis/Reads_QC/Nanopore_reads/trimmed_reads/trimming_3'
ASSEMBLY='/home/ipr/biosurf/analysis/assembly/Nanopore_Illumina'

threads=25

# Export variables

export READS ASSEMBLY threads
 

# 1) Read reconciliation

for trycycler_dir in "$ASSEMBLY"/*_trycycler; do
    # Extract the base name
    NAME=`basename "$trycycler_dir" _trycycler`

    # Process each cluster directory
    find "$trycycler_dir" -type d -name 'cluster*' | parallel -j 1 bash -c '
        cluster_dir="{}";
       
       	# Extract BIOSURF_XXX from the directory path
        NAME2=`echo "{$cluster_dir}" | awk -F"/" "{for (i=1; i<=NF; i++) if (\$i ~ /^BIOSURF_[0-9]+$/) print \$i}"`

        # Debugging output
        echo "Processing cluster_dir=$cluster_dir with extracted name=$NAME2"
        
        # Run Trycycler reconcile
        trycycler reconcile \
            --reads "$READS/${NAME2}"_yes_illumina.fq.gz \
            --cluster_dir "{}" \
            -t "$threads"
    ' {}
done


# trycycler reconcile --reads /home/ipr/biosurf/analysis/Reads_QC/Nanopore_reads/trimmed_reads/trimming_1/BIOSURF_224_no_illumina.fq.gz --cluster_dir cluster_001/ --threads 26 2> reconcile_c1_log1.log
# tail reconcile_c1_log1.log -n 40


