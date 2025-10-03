#!/bin/bash

DIR='/Users/williamlautert/Desktop/William-bio-surf/data/refs'
OUT='/Users/williamlautert/Desktop/William-bio-surf/analysis'
OUT_PATCH='patch'
OUT_SCAFFOLD='scaffold'
#OUT_CORRECT='correct'

REF=('Halomonas_hydrothermalis' 'Halomonas_sp_NyZ770' 'Halomonas_sp_18071143')
GCF=(
    'GCF_002442575.1'
    'GCF_020616575.1'
    'GCF_019211725.1'
)
FILE='/Users/williamlautert/Desktop/William-bio-surf/analysis/assembly/assembly/assembly1/isolate/BIOSURF_235_scaffolds_1.fasta'

for ((idx_REF=0; idx_REF<${#REF[@]}; idx_REF++)); do
    OUT_S="${REF[idx_REF]}"
    GCF_FILENAME="${GCF[idx_REF]}"

    # Get the directory of the GCF files
    GCF_DIR="$DIR/$OUT_S/ncbi_dataset/data/$GCF_FILENAME"

    # Create the output directories if they don't exist
    mkdir -p "$OUT/$OUT_PATCH/$OUT_S"
    mkdir -p "$OUT/$OUT_SCAFFOLD/$OUT_S"
    #mkdir -p "$OUT/$OUT_CORRECT/$OUT_S"

    ragtag.py patch "$FILE" "$GCF_DIR/"*.fna -o "$OUT/$OUT_PATCH/$OUT_S" -t 8 --aligner minimap2
    #ragtag.py scaffold "$GCF_DIR/"*.fna "$FILE" -o "$OUT/$OUT_SCAFFOLD/$OUT_S" -t 8
    #ragtag.py correct "$GCF_DIR/"*.fna "$FILE" -o "$OUT/$OUT_CORRECT/$OUT_S" -t 8

done



#DIR='/Users/williamlautert/Desktop/William-bio-surf/data/refs'
#OUT='/Users/williamlautert/Desktop/William-bio-surf/analysis'
#OUT_PATCH='patch'
#OUT_SCAFFOLD='scaffold'
#OUT_CORRECT='correct'

#REF=('Halomonas_sp_LR3S48' 'Halomonas_sp_MCCC_1A13316' 'Halomonas_sp_SS10_MC5' 'Halomonas_sulfidivorans_MCCC_1A13718' 'Halomonas_sulfidoxydans_MCCC_1A11059' 'Halomonas_tianxiuensis_BC_M4_5')


#SEQ='/Users/williamlautert/Desktop/William-bio-surf/analysis/assembly/scaffolds/RagTag/scaffold'

#quast.py --gene-finding --circos analysis/assembly/trimm_3/isolate/Trim3_SPAdes_scaffolds.fasta $SEQ/Halomonas_sp_LR3S48/*.scaffold.fasta $SEQ/Halomonas_sp_MCCC_1A13316/*.scaffold.fasta $SEQ/Halomonas_sp_SS10_MC5/*.scaffold.fasta $SEQ/Halomonas_sulfidivorans_MCCC_1A13718/*.scaffold.fasta $SEQ/Halomonas_sulfidoxydans_MCCC_1A11059/*.scaffold.fasta $SEQ/Halomonas_tianxiuensis_BC_M4_5/*.scaffold.fasta -o analysis/assembly/quast/scaffold/scaffold -t 1

#SEQ2='/Users/williamlautert/Desktop/William-bio-surf/analysis/assembly/scaffolds/RagTag/correct'
#OUT_CORRECT='correct'

quast.py --gene-finding --circos analysis/assembly/assembly/assembly1/isolate/BIOSURF_235_scaffolds_1.fasta analysis/assembly/scaffolds/RagTag/correct/Halomonas_hydrothermalis/*.correct.fasta analysis/assembly/scaffolds/RagTag/correct/Halomonas_sp_18071143/*.correct.fasta analysis/assembly/scaffolds/RagTag/correct/Halomonas_sp_NyZ770/*.correct.fasta analysis/assembly/scaffolds/RagTag/scaffold/Halomonas_hydrothermalis/*.scaffold.fasta
    analysis/assembly/scaffolds/RagTag/scaffold/Halomonas_sp_18071143/*.scaffold.fasta analysis/assembly/scaffolds/RagTag/scaffold/Halomonas_sp_NyZ770/*.scaffold.fasta
    analysis/assembly/scaffolds/RagTag/patch/Halomonas_hydrothermalis/*.patch.fasta analysis/assembly/scaffolds/RagTag/patch/Halomonas_sp_18071143/*.patch.fasta
    analysis/assembly/scaffolds/RagTag/patch/Halomonas_sp_NyZ770/*.patch.fasta -o analysis/assembly/quast/ -t 1






#Trim3_patch.fasta

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
