#!/bin/bash

# Spades
SPADES='/Users/williamlautert/Documents/Bioinfo/SPAdes-3.15.5-Darwin/bin'

#Set the input paths and file names
INPUT='/Users/williamlautert/Desktop/William-bio-surf/analysis/trim'
OUT='/Users/williamlautert/Desktop/William-bio-surf/analysis/assembly'
REF_HYDRO='/Users/williamlautert/Desktop/William-bio-surf/data/refs/Halomonas_hydrothermalis/ncbi_dataset/data/GCF_002442575.1'
REF_EXI='/Users/williamlautert/Desktop/William-bio-surf/data/refs/Exiguobacterium_alkaliphilum/ncbi_dataset/data/GCF_018138125.1'


#create the output folders for each assembly
mkdir -p "$OUT"/{trim_1,trim_2,trim_3,trim_4}/BIOSURF_assembly_{250,253,282,283}


#Suffixes and prefixes used to run the command
FILE=('trim_1' 'trim_2' 'trim_3' 'trim_4')
ASSEMBLY=('250' '253' '282' '283')



for i in "${FILE[@]}";do
    for a in "${ASSEMBLY[@]}";do #iterate through assembly names
        #running spades
        "$SPADES"/spades.py --isolate -t 8 \
                  --pe1-1 "$INPUT/${i}/BIOSURF_trim_${a}"/*_R1.fq.gz \
                  --pe1-2 "$INPUT/${i}/BIOSURF_trim_${a}/"*_R2.fq.gz \
                  -o "$OUT/${i}/BIOSURF_assembly_${a}"
        mv -f "$OUT/${i}/BIOSURF_assembly_${a}"/scaffolds.fasta "$OUT/${i}/BIOSURF_assembly_${a}"/BIOSURF_${a}_scaffolds.fasta #renaming the output scaffolds.fasta

        #spades.py --bio -t 8 --pe1-2 "${SEQ[$idx_R1]}" --pe1-2 "${SEQ[$idx_R2]}" -o "$OUTPUT_DIR/bio"

     done
done



#bowtie2 -p 8 -x analysis/assembly/scaffolds/RagTag/patch/Halomonas_hydrothermalis/index/BIOSURF_235_ragtag -1 analysis/trimm/minlen_90/BIOSURF_235_R1_paired_min90.fq.gz -2 analysis/trimm/minlen_90/BIOSURF_235_R1_paired_min90.fq.gz -S analysis/bowtie2/BIOSURF_235

#samtools sort *.bam -o BIOSURF_235_sorted.bam -@ 8
#samtools sort -n -o BIOSURF_235_namesort.bam BIOSURF_235_sorted.bam -@ 8
#samtools fixmate -m BIOSURF_235_namesort.bam BIOSURF_235_namesort_fixmate.bam -@ 8
#samtools sort -o BIOSURF_235_namesort_fixmate_sort.bam BIOSURF_235_namesort_fixmate.bam -@ 8
#samtools markdup -r BIOSURF_235_namesort_fixmate_sort.bam BIOSURF_235_namesort_fixmate_sort_markdup.bam -@ 8
#samtools index *_markdup.bam
#samtools flagstat *_markdup.bam > mappingstats.txt
#qualimap
#qualimap bamqc BIOSURF_235_namesort_fixmate_sort_markdup.bam
#qualimap bamqc BIOSURF_235_namesort_fixmate_sort_markdup.bam -outdir bamqc
#qualimap bamqc -bam BIOSURF_235_namesort_fixmate_sort_markdup.bam -outdir bamqc











# Create QUAST output directories
mkdir -p "$OUT"/quast/{quast_250,quast_253,quast_282,quast_283}

quast.py --gene-finding --circos "$OUT/trim_1/BIOSURF_assembly_250"/*_scaffolds.fasta \
         "$OUT/trim_2/BIOSURF_assembly_250"/*_scaffolds.fasta \
         "$OUT/trim_3/BIOSURF_assembly_250"/*_scaffolds.fasta \
         "$OUT/trim_4/BIOSURF_assembly_250"/*_scaffolds.fasta \
         -r "$REF_HYDRO"/*.fna \
         -o $OUT/quast/quast_250 -t 1

quast.py --gene-finding --circos "$OUT/trim_1/BIOSURF_assembly_253"/*_scaffolds.fasta \
         "$OUT/trim_2/BIOSURF_assembly_253"/*_scaffolds.fasta \
         "$OUT/trim_3/BIOSURF_assembly_253"/*_scaffolds.fasta \
         "$OUT/trim_4/BIOSURF_assembly_253"/*_scaffolds.fasta \
         #-r
         -o $OUT/quast/quast_250 -t 1
         
quast.py --gene-finding --circos "$OUT/trim_1/BIOSURF_assembly_282"/*_scaffolds.fasta \
         "$OUT/trim_2/BIOSURF_assembly_282"/*_scaffolds.fasta \
         "$OUT/trim_3/BIOSURF_assembly_282"/*_scaffolds.fasta \
         "$OUT/trim_4/BIOSURF_assembly_282"/*_scaffolds.fasta \
         -r "$REF_EXI"/*.fna \
         -o $OUT/quast/quast_282 -t 1

quast.py --gene-finding --circos "$OUT/trim_1/BIOSURF_assembly_283"/*_scaffolds.fasta \
         "$OUT/trim_2/BIOSURF_assembly_283"/*_scaffolds.fasta \
         "$OUT/trim_3/BIOSURF_assembly_283"/*_scaffolds.fasta \
         "$OUT/trim_4/BIOSURF_assembly_283"/*_scaffolds.fasta \
         -r "$REF_EXI"/*.fna \
         -o $OUT/quast/quast_283 -t 1






