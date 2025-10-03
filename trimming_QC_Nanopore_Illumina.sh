#!/bin/bash
 
# Input and output directories

READS='/home/ipr/biosurf/data/NanoporeWilliam/concat_files_Nanopore'
READS_Illumina='/home/ipr/biosurf/analysis/Reads_QC/Illumina_reads'
OUT_FOLDER='/home/ipr/biosurf/analysis/Reads_QC/Nanopore_reads/trimmed_reads/trimming_3'
 
# Export variables

export READS OUT_FOLDER READS_Illumina
 
# Create necessary directories

mkdir -p "$OUT_FOLDER" "$OUT_FOLDER/FASTQ/"

# 235
filtlong -1 "$READS_Illumina"/BIOSURF_trim_235/*R1_paired_min90.fq.gz -2 "$READS_Illumina"/BIOSURF_trim_235/*R2_paired_min90.fq.gz --min_length 1000 --keep_percent 90 "$READS/BIOSURF_235.fastq.gz" | gzip > "$OUT_FOLDER/BIOSURF_235_yes_illumina.fq.gz"

# 250
filtlong -1 "$READS_Illumina"/BIOSURF_trim_250/*_R1.fq.gz -2 "$READS_Illumina"/BIOSURF_trim_250/*_R2.fq.gz --min_length 1000 --keep_percent 90 "$READS/BIOSURF_250.fastq.gz" | gzip > "$OUT_FOLDER/BIOSURF_250_yes_illumina.fq.gz"

# 253
filtlong -1 "$READS_Illumina"/BIOSURF_trim_253/*_R1.fq.gz -2 "$READS_Illumina"/BIOSURF_trim_253/*_R2.fq.gz --min_length 1000 --keep_percent 90 "$READS/BIOSURF_253.fastq.gz" | gzip > "$OUT_FOLDER/BIOSURF_253_yes_illumina.fq.gz" 

# 282
filtlong -1 "$READS_Illumina"/BIOSURF_trim_282/*_R1.fq.gz -2 "$READS_Illumina"/BIOSURF_trim_282/*_R2.fq.gz --min_length 1000 --keep_percent 90 "$READS/BIOSURF_282.fastq.gz" | gzip > "$OUT_FOLDER/BIOSURF_282_yes_illumina.fq.gz" 

# 283
filtlong -1 "$READS_Illumina"/BIOSURF_trim_283/*_R1.fq.gz -2 "$READS_Illumina"/BIOSURF_trim_283/*_R2.fq.gz --min_length 1000 --keep_percent 90 "$READS/BIOSURF_283.fastq.gz" | gzip > "$OUT_FOLDER/BIOSURF_283_yes_illumina.fq.gz" 

# 287
filtlong -1 "$READS_Illumina"/BIOSURF_trim_287/*R1_paired_val_1.fq.gz -2 "$READS_Illumina"/BIOSURF_trim_287/*R2_paired_val_2.fq.gz --min_length 1000 --keep_percent 90 "$READS/BIOSURF_287.fastq.gz" | gzip > "$OUT_FOLDER/BIOSURF_287_yes_illumina.fq.gz" 

# Quality control with FastQC

fastqc "$OUT_FOLDER"/*.fq.gz -t 8 -o "$OUT_FOLDER/FASTQ/"
 
# MultiQC summary

multiqc "$OUT_FOLDER/FASTQ/" -o "$OUT_FOLDER/FASTQ/"






















#seqkit stats *.f{a,q}.gz -T | csvtk csv2md -t
#Trimmomatic
#trimmomatic PE -threads 6 $SEQUENCES/230802193961-1-1-1_S5_L001_R1_001.fastq.gz $SEQUENCES/230802193961-1-1-1_S5_L001_R2_001.fastq.gz $OUT/trimm/BIOSURF_235_R1_paired.fq.gz $OUT/trimm/BIOSURF_235_R1_unpaired.fq.gz $OUT/trimm/BIOSURF_235_R2_paired.fq.gz $OUT/trimm/BIOSURF_235_R2_unpaired.fq.gz SLIDINGWINDOW:4:15 LEADING:3 TRAILING:3 ILLUMINACLIP:$ADAPT/neoprospecta_fastqc.txt:2:30:10 >> $OUT/trimm/log.txt
#adapter removal in Trimmomatic processed reads
#AdapterRemoval --file1 $OUT/trimm/BGBC4_R1_paired.fq.gz --file2 $OUT/trimm/BGBC4_R2_paired.fq.gz --basename $OUT/trimm/BGBC4_no_adp

#Trim_galore for adpter removal 'Nextera'
#trim_galore --nextera --paired --cores 6 --gzip $SEQUENCES/*_R1_001.fastq $SEQUENCES/*_R2_001.fastq --output_dir $OUT/Trimm_G/
#trim_galore in trimmomatic output reads
#trim_galore --nextera --paired --cores 6 --gzip $OUT/trimm/BIOSURF_235_R1_paired.fq.gz $OUT/trimm/BIOSURF_235_R2_paired.fq.gz --output_dir $OUT/trimm/Trimm_G/

#SEQUENCES='/Users/williamlautert/Desktop/William-bio-surf/data/seqs/sequecing_quality_A679_183603_1/fastqs'
#SEQ=()
#FILE=('250' '282' '253' '283')
#idx_R1=0
#idx_R2=1
#idx_out+=0
#OUT='/Users/williamlautert/Desktop/William-bio-surf/analysis'
#mkdir -p "$OUT/trim/"BIOSURF_trim_{250,253,282,283}
#for i in "${FILE[@]}"
#do
#    mkdir -p "$OUT/trim/BIOSURF_trim_$i"  # -p option to avoid error if directory already exists
    
#    cd "$OUT/trim/BIOSURF_trim_$i" || exit 1  # Exit if the directory doesn't exist or cannot be accessed

#    echo "I'm into $(pwd)"
    
#    fastp --in1 "$SEQUENCES/${SEQ[$idx_R1]}" --out1 "BIOSURF_trim_${FILE[$idx_out]}_min_90_R1.fq.gz" \
#          --in2 "$SEQUENCES/${SEQ[$idx_R2]}" --out2 "BIOSURF_trim_${FILE[$idx_out]}_min_90_R2.fq.gz" \
#          --dont_overwrite --trim_poly_g --detect_adapter_for_pe --thread 8 --length_required 90
    
#    seqkit stats *.gz -T | csvtk csv2md -t > stats.txt
    
#    idx_R1=$((idx_R1 + 2))
#    idx_R2=$((idx_R2 + 2))
#    idx_out=$((idx_out + 1))
    
#    cd ..
#done
#fastqc "$OUT/trim/BIOSURF_trim_250/"*.gz "$OUT/trim/BIOSURF_trim_282/"*.gz \
#       "$OUT/trim/BIOSURF_trim_253/"*.gz "$OUT/trim/BIOSURF_trim_283/"*.gz -t 8 -o "$OUT/QC/trim/"
#MultiQC summmary
#multiqc "$OUT/QC/trim/"
