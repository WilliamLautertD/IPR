#!/bin/bash

#Set the input paths and file names
INPUT='/Users/williamlautert/Desktop/William-bio-surf/analysis/assembly/trim_2'
OUT='/Users/williamlautert/Desktop/William-bio-surf/analysis'
REF_HYDRO='/Users/williamlautert/Desktop/William-bio-surf/data/refs/Halomonas_hydrothermalis/ncbi_dataset/data/GCF_002442575.1'
REF_EXI='/Users/williamlautert/Desktop/William-bio-surf/data/refs/Exiguobacterium_alkaliphilum/ncbi_dataset/data/GCF_018138125.1'


# RagTag scaffold section

#create the output folders for each scaffold
mkdir -p "$OUT"/scaffold/trim_2/BIOSURF_scaffold_{250,253,282,283}

#Suffixes and prefixes used to run the command
#FILE=('trim_1' 'trim_2' 'trim_3' 'trim_4')
FILE=('trim_2')
ASSEMBLY=('250' '253' '282' '283')
REF=("$REF_HYDRO" "$REF_HYDRO" "$REF_EXI" "$REF_EXI")

idx_ref=0 #Index used to run through the REF variable

for a in "${ASSEMBLY[@]}"; do
    echo "Running ragtag for assembly $a using $REF/*.fna as reference."
    #running ragtag
    ragtag.py scaffold "${REF[$idx_ref]}/"*.fna "$INPUT/BIOSURF_assembly_${a}"/*_scaffolds.fasta \
    -o "$OUT/scaffold/trim_2/BIOSURF_scaffold_${a}" \
    -t 8

    #renaming the output scaffolds.fasta
    echo "Renaming output scaffolds.fasta for assembly $a."
    mv -f "$OUT/scaffold/trim_2/BIOSURF_scaffold_${a}"/*scaffold.fasta \
    "$OUT/scaffold/trim_2/BIOSURF_scaffold_${a}"/BIOSURF_${a}_rtg_scaffold.fasta

    ((idx_ref++)) #add one to $REF
done


# Bowtie2 mapping section

#Create the output for  folders for Bowtie2 mapping for each isolate
mkdir -p "$OUT"/bowtie2/trim_2/BIOSURF_mapped_{250,253,282,283}

for a in "${ASSEMBLY[@]}"; do # Iterate through different assemblies
    
    #Create a directory for the rtg_scaffold.fasta
    mkdir -p "$OUT/scaffold/trim_2/BIOSURF_scaffold_${a}"/index
    
    #Create the index for the rtg_scaffold in the intex directory
    bowtie2-build "$OUT/scaffold/trim_2/BIOSURF_scaffold_${a}/BIOSURF_${a}_rtg_scaffold.fasta" \
    "$OUT/scaffold/trim_2/BIOSURF_scaffold_${a}/index/BIOSURF_${a}_rtg_scaffold"
    
    #Move the rtg_scaffold.fasta to index folder
    mv "$OUT/scaffold/trim_2/BIOSURF_scaffold_${a}/BIOSURF_${a}_rtg_scaffold.fasta" "$OUT/scaffold/trim_2/BIOSURF_scaffold_${a}"/index

    bowtie2 -p 8 -x "$OUT/scaffold/trim_2/BIOSURF_scaffold_${a}/index/BIOSURF_${a}_rtg_scaffold" \
            -1 "$OUT/trim/trim_2/BIOSURF_trim_${a}"/*R1.fq.gz \
            -2 "$OUT/trim/trim_2/BIOSURF_trim_${a}"/*R2.fq.gz \
            -S "$OUT/bowtie2/trim_2/BIOSURF_mapped_${a}/BIOSURF_mapped_${a}.sam"
    

        # Sort the SAM file and create a BAM file
    samtools sort -@ 8 -O BAM -o "$OUT/bowtie2/trim_2/BIOSURF_mapped_${a}/BIOSURF_mapped_${a}.bam" "$OUT/bowtie2/trim_2/BIOSURF_mapped_${a}/BIOSURF_mapped_${a}.sam"

    # Sort the BAM file by name, fixmate, and mark duplicates
    samtools sort -n -@ 8 -O BAM "$OUT/bowtie2/trim_2/BIOSURF_mapped_${a}/BIOSURF_mapped_${a}.bam" | \
    samtools fixmate -m -@ 8 - - | \
    samtools sort -@ 8 -O BAM -o "$OUT/bowtie2/trim_2/BIOSURF_mapped_${a}/BIOSURF_mapped_${a}_namesort_fixmate_sort.bam" - && \
    samtools markdup -r -@ 8 --write-index --duplicate-count \
    "$OUT/bowtie2/trim_2/BIOSURF_mapped_${a}/BIOSURF_mapped_${a}_namesort_fixmate_sort.bam" \
    "$OUT/bowtie2/trim_2/BIOSURF_mapped_${a}/BIOSURF_mapped_${a}_namesort_fixmate_sort_markdup.bam"
        # samtools index "$OUT/bowtie2/BIOSURF_${a}_${i}_namesort_fixmate_sort_markdup.bam"

    samtools flagstat "$OUT/bowtie2/trim_2/BIOSURF_scaffold_${a}/BIOSURF_mapped_${a}_namesort_fixmate_sort_markdup.bam" > "$OUT/bowtie2/trim_2/BIOSURF_mapped_${a}/mappingstats_trim2_${a}.txt"

        # qualimap
    qualimap bamqc -bam "$OUT/bowtie2/trim_2/BIOSURF_mapped_${a}/BIOSURF_mapped_${a}_namesort_fixmate_sort_markdup.bam" \
        -outdir "$OUT/bowtie2/trim_2/BIOSURF_mapped_${a}/bamqc_${a}"

done


# QUAST analysis section

# Create QUAST output directories in the scaffold folder
mkdir -p "$OUT"/scaffold/quast/{quast_250,quast_253,quast_282,quast_283}

for a in "${ASSEMBLY[@]}"; do
    # Run QUAST analysis for each assembly
    quast.py --gene-finding --circos "$OUT/scaffold/trim_2/BIOSURF_scaffold_${a}/index/BIOSURF_${a}_rtg_scaffold.fasta" \
            --bam "$OUT/bowtie2/trim_2/BIOSURF_mapped_${a}/BIOSURF_mapped_${a}_namesort_fixmate_sort_markdup.bam" \
            -o "$OUT/scaffold/quast/quast_${a}" -t 1
done

