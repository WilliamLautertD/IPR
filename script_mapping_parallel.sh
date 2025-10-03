#!/bin/bash

#Created by: William Lautert, Institute of Petroleum and Natural Resources, PUCRS-BR

# - Parameters
#SEQS='/home/ipr/biosurf/analysis/Phylogeny/genomes/Halomonas_Billgrantia_Vreelandella/ncbi_dataset'
SEQS='/home/ipr/biosurf/analysis/Phylogeny/genomes/Billgrantia'
PY_PROGRAM='/home/ipr/biosurf/analysis/Phylogeny/species_tree/results/diamond'
OUT_FOLDER='/home/ipr/biosurf/analysis/Phylogeny/species_tree/results'
OUT_ORFS='/home/ipr/biosurf/analysis/Phylogeny/species_tree/results/orfs'
OUT_DIAM='/home/ipr/biosurf/analysis/Phylogeny/species_tree/results/diamond'
OUT_FASTA='/home/ipr/biosurf/analysis/Phylogeny/species_tree/results/fasta'
OUT_MAINPROTEIN='/home/ipr/biosurf/analysis/Phylogeny/species_tree/results/final_fastas'

# Databases
DB_PHY='/home/ipr/biosurf/analysis/Phylogeny/db/phylophlan/phylophlan.faa'

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
find $SEQS -name '*.fna' | parallel -j 20 '
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
export DB_PHY E_VALUE OUT_ORFS OUT_DIAM
find $OUT_ORFS -name '*.faa' | parallel -j 1 '
    NAME_QUERY=$(basename -s .faa {});
    diamond blastp --threads 25 --outfmt 6 sseqid qlen qstart qend bitscore qseq --more-sensitive --id 50 --max-hsps 1 -k 1 -e $E_VALUE --query-gencode 11 --db $DB_PHY --query {} --out $OUT_DIAM/$NAME_QUERY.b6o.bkp
'

# Create .fasta files and add the final protein sequences
touch $OUT_MAINPROTEIN/p{0000..0400}.fa

export OUT_DIAM PY_PROGRAM OUT_FASTA OUT_MAINPROTEIN
find $OUT_DIAM -name '*.b6o.bkp' | parallel -j 12 '
    NAME_DIAM_MAPPED=$(basename -s .b6o.bkp {});
    cat {} | awk -F "[_\t]" "{print \$2, \$7, \$8}" | sort -u -k1,1 -k2,2 | sort -u -k1,1 -s | awk -F " " "{print \$1, \$3}" > "$OUT_DIAM/$NAME_DIAM_MAPPED.txt";
    python "$PY_PROGRAM/makefasta.py" "$OUT_DIAM/$NAME_DIAM_MAPPED.txt"
'

# Ensure the renamed directory exists

#create a fasta file for each protein sequence within $NAME_DIAM_MAPPED.txt
for d in  $OUT_DIAM/*.fasta
do

	NAME_MAPPED=`basename -s .fasta $d`
	fastaexplode -f $d -d $OUT_FASTA
	        
        #replace fasta headers with file name 
	for e in $OUT_FASTA/*.fa
	do	
		
		NAME_FASTA=`basename -s .fa $e`
		
		seqkit replace -p "^(\\S+)" -r "$NAME_MAPPED" $e > "$OUT_FASTA/renamed/$NAME_FASTA"_renamed.fa
		# Append the renamed .fasta file to a file containing the main proteins 
		cat "$OUT_FASTA/renamed/$NAME_FASTA"_renamed.fa >> "$OUT_MAINPROTEIN/$NAME_FASTA".fa

	done
	rm $OUT_FASTA/*.fa
	rm $OUT_FASTA/renamed/*.fa
done


# Run MUSCLE for sequence alignment
export OUT_MAINPROTEIN
find $OUT_MAINPROTEIN -name '*.fa' | parallel -j 6 '
    MUSCLE_NAME=$(basename -s .fa {});
    muscle -align {} -output "$OUT_MAINPROTEIN/$MUSCLE_NAME.afa"
'

# Run TrimAl for sequence trimming
export OUT_MAINPROTEIN
find $OUT_MAINPROTEIN -name '*.afa' | parallel -j 25 '
    MAPPED_NAME=$(basename -s .afa {});
    trimal -gappyout -in {} -out "$OUT_MAINPROTEIN/$MAPPED_NAME.trim" -htmlout "$OUT_MAINPROTEIN/$MAPPED_NAME.trim.html" -phylip -automated1
'


# Run RaxML for trimmed sequences
export OUT_MAINPROTEIN
find $OUT_MAINPROTEIN -name '*.trim' | parallel -j 1 '
    TREE_NAME=$(basename -s .trim {});
    raxmlHPC-PTHREADS-SSE3 -f c -N 100 -m PROTGAMMAAUTO -T 26 -s "$OUT_MAINPROTEIN/$TREE_NAME.trim" -n "$TREE_NAME.check";
    mv "RAxML_info.$TREE_NAME.check" "$OUT_MAINPROTEIN/"
    mv "RAxML_bestTree.$TREE_NAME.check" "$OUT_MAINPROTEIN/"
    mv "RAxML_log.$TREE_NAME.check" "$OUT_MAINPROTEIN/"
    mv "RAxML_result.$TREE_NAME.check" "$OUT_MAINPROTEIN/"
    raxmlHPC-PTHREADS-SSE3 -f a -N 100 -m PROTGAMMAAUTO -p 12345 -x 12345 -T 26 -s "$OUT_MAINPROTEIN/$TREE_NAME.trim.reduced" -n "$TREE_NAME.tree";
    mv "RAxML_info.$TREE_NAME.tree" "$OUT_MAINPROTEIN/"
    mv "RAxML_bestTree.$TREE_NAME.tree" "$OUT_MAINPROTEIN/"
    mv "RAxML_bootstrap.$TREE_NAME.tree" "$OUT_MAINPROTEIN/"
    mv "RAxML_bipartitions.$TREE_NAME.tree" "$OUT_MAINPROTEIN/"
    mv "RAxML_bipartitionsBranchLabels.$TREE_NAME.tree" "$OUT_MAINPROTEIN/"
'

# Run ASTRAL for trimmed sequences
mkdir "$OUT_MAINPROTEIN/raxml"
mv $OUT_MAINPROTEIN/*.tree "$OUT_MAINPROTEIN/raxml"
cat $OUT_MAINPROTEIN/raxml/RAxML_bestTree.p* >> "$OUT_MAINPROTEIN/raxml/final_tree.tree"

#remember add code for treeShrink

# /home/ipr/anaconda3/envs/phylophlan/bin/run_treeshrink.py -t final_tree.tree -q "0.05 0.10 0.15" -O treeShrink


java -jar ~/Programs/ASTRAL/astral.5.7.8.jar -i "$OUT_MAINPROTEIN/raxml/final_tree.tree" -o "$OUT_MAINPROTEIN/raxml/astral.tree" 2> "$OUT_MAINPROTEIN/raxml/out_ASTRAL.log"

# Log completion
log "Script completed successfully."

