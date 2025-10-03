#!/bin/bash
# Created by: William Lautert, Institute of Petroleum and Natural Resources, PUCRS-BR 
# 'Mapping_bowtie_QC.sh': Mapping Illumina reads to Reference de novo genome assembled usinng Nanopore reads. 


#Set the input paths and file names
INPUT='/home/ipr/biosurf/analysis/assembly/Nanopore/BIOSURF_253_trycycler/cluster_001/polypolish_pypolca.fasta'
OUT='/home/ipr/biosurf/analysis/assembly/Nanopore/BIOSURF_253_trycycler/cluster_001'
threads='26'
READS='/home/ipr/biosurf/analysis/Reads_QC/Illumina_reads/BIOSURF_235_trim/'

# Export variables
export READS INPUT threads OUT

# Bowtie2 mapping section

#Create the index for the rtg_scaffold in the intex directory

bowtie2-build "$INPUT" "$OUT/polypolish_pypolca"

# Perform Bowtie2 mapping
echo "Running Bowtie2 mapping..."
bowtie2 -p "$THREADS" -x "$OUT/polypolish_pypolca" \
    -1 "$READS/"*R1_paired_min90.fq.gz \
    -2 "$READS/"*R2_paired_min90.fq.gz \
    -S "$OUT/BIOSURF_253_mapped.sam" > "$OUT/bowtie2_mapping.log" 2>&1

# Convert SAM to BAM and sort
echo "Converting and sorting BAM file..."
samtools sort -@ "$THREADS" -O BAM -o "$OUT/BIOSURF_253_mapped.bam" "$OUT/BIOSURF_253_mapped.sam"

# Sort, fixmate, and mark duplicates
echo "Processing BAM file..."
samtools sort -n -@ "$THREADS" -O BAM "$OUT/BIOSURF_253_mapped.bam" | \
samtools fixmate -m -@ "$THREADS" - - | \
samtools sort -@ "$THREADS" -O BAM -o "$OUT/BIOSURF_253_mapped_namesort_fixmate_sort.bam" - && \
samtools markdup -r -@ "$THREADS" --duplicate-count \
    "$OUT/BIOSURF_253_mapped_namesort_fixmate_sort.bam" \
    "$OUT/BIOSURF_253_mapped_namesort_fixmate_sort_markdup.bam"

# Generate mapping statistics
echo "Generating mapping statistics..."
samtools flagstat "$OUT/BIOSURF_253_mapped_namesort_fixmate_sort_markdup.bam" > "$OUT/mappingstats.txt"

# qualimap
qualimap bamqc -bam "$OUT/BIOSURF_253_mapped_namesort_fixmate_sort_markdup.bam" \
-outdir "$OUT/bamqc_253"
            
            
            
