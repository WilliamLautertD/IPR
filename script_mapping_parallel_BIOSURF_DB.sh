#!/bin/bash

#Created by: William Lautert, Institute of Petroleum and Natural Resources, PUCRS-BR

# - Parameters
SEQS='/home/ipr/biosurf/analysis/assembly/genomes'
#SEQS='/home/ipr/biosurf/analysis/Phylogeny/genomes/Billgrantia'
PY_PROGRAM='/home/ipr/biosurf/analysis/BioSURF_DBdiamond'
OUT_FOLDER='/home/ipr/biosurf/analysis/BioSURF_DB'
OUT_ORFS='/home/ipr/biosurf/analysis/BioSURF_DB/orfs'
OUT_DIAM='/home/ipr/biosurf/analysis/BioSURF_DB/diamond'
OUT_FASTA='/home/ipr/biosurf/analysis/BioSURF_DB/fasta'
OUT_MAINPROTEIN='/home/ipr/biosurf/analysis/BioSURF_DB/final_fastas'

# Databases
DB_BIOSURF='/home/ipr/db/BIOSURFDB/protein.fasta'

# Create dir for tmp files orfs, diamond alignment, fastas, and multi fasta files
mkdir -p "$OUT_FOLDER/orfs" "$OUT_FOLDER/diamond" "$OUT_FOLDER/fasta" "$OUT_FOLDER/final_fastas"

# Functional parameters
# Diamond
E_VALUE='.00001'

# Logging function
log() {
    echo "$(date +"%Y-%m-%d %T") - $1"
}

# Log script start
log "Script started."

# Check if Prodigal is installed
if ! command -v prodigal &>/dev/null; then
    echo "Error: Prodigal is not installed or not in the PATH. Please install Prodigal and try again." >&2
    exit 1
fi

# Log Prodigal command execution
log "Running Prodigal for ORF prediction..."

# Run Prodigal
export SEQS OUT_ORFS
find $SEQS -name '*.fasta' | parallel -j 20 '
    NAME_ORF=$(basename -s .fna {});
    prodigal -i {} -a $OUT_ORFS/$NAME_ORF.faa -d $OUT_ORFS/$NAME_ORF.ffn -o $OUT_ORFS/$NAME_ORF.gbk
'

# Check if Diamond is installed
if ! command -v diamond &>/dev/null; then
    echo "Error: Diamond is not installed or not in the PATH. Please install Diamond and try again." >&2
    exit 1
fi

# Log Diamond command execution
log "Running Diamond for sequence mapping..."

# Run 'diamond blastx'
export DB_BIOSURF E_VALUE OUT_ORFS OUT_DIAM
find $OUT_ORFS -name '*.faa' | parallel -j 1 '
    NAME_QUERY=$(basename -s .faa {});
    diamond blastp --threads 26 --outfmt 6 sseqid qlen qstart qend bitscore qseq --more-sensitive --id 50 --max-hsps 1 -k 1 -e $E_VALUE --query-gencode 11 --db $DB_BIOSURF --query {} --out $OUT_DIAM/$NAME_QUERY.b6o.bkp
'

# Log completion
log "Script completed successfully."

