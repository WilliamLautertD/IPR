#!/bin/bash

####OBS####
# - Parameters to test before running the code

SEQS='/home/ipr/bio-surf/phylophlan/isolates/isolates/GenBank_ANI_287'
PY_PROGRAM='/home/ipr/bio-surf/Phylogeny/Species_tree/diamond/'
OUT_ORFS='/home/ipr/bio-surf/Phylogeny/Species_tree/orfs'
DB_PHY='/home/ipr/bio-surf/phylophlan/phylophlan_databases/phylophlan/phylophlan.faa'
DB_AMPHORA='/home/ipr/bio-surf/phylophlan/phylophlan_databases/amphora2/amphora2.faa'
OUT_DIAM='/home/ipr/bio-surf/Phylogeny/Species_tree/diamond'
OUT_FASTA='/home/ipr/bio-surf/Phylogeny/Species_tree/fasta'
OUT_MAINPROTEIN='/home/ipr/bio-surf/Phylogeny/Species_tree/final_fastas'

#Functional parameters
#Diamond
E_VALUE='.00001'
#...


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
#Run Prodigal
for a in $SEQS/*.fna 						#Iterate through all .fna files in $SEQS directory
do

	NAME_ORF=`basename -s .fna $a` 				#Extract base names for each Genome. 
				       				#Remember that '``' are necessary to basename work
	#This step generate ORFs for each assembly
	#-a ORFs translated to proteins
	#-d ORFs in nuc format
	#Output.gbk format
	prodigal -i $SEQS/$NAME_ORF.fna \
	-a $OUT_ORFS/$NAME_ORF.faa \
	-d $OUT_ORFS/$NAME_ORF.ffn \
	-o $OUT_ORFS/$NAME_ORF.gbk 

done

# Check if Diamond is installed
if ! command -v diamond &>/dev/null; then
	echo "Error: Diamond is not installed or not in the PATH. Please install Prodigal and try again." >&2     
	exit 1
fi

# Log Diamond command execution
log "Running Diamond for sequence mapping..."
#Run 'diamond blastx'
for b in $OUT_ORFS/*.faa 					#Iterate through all .faa files in $OUT_ORFS directory
do

	NAME_QUERY=`basename -s .faa $b`
	
	#Mapping the ORFs to protein databases and extract sequence hits
	diamond blastp --threads 12 \
	--outfmt 6 sseqid qlen qstart qend bitscore qseq \
	--more-sensitive \
	--id 50 \
	--max-hsps 1 \
	-k 1 \
	-e $E_VALUE \
	--query-gencode 11 \
	--db $DB_PHY \
	--query $OUT_ORFS/$NAME_QUERY.faa \
	--out $OUT_DIAM/$NAME_QUERY.b6o.bkp

done


#Create .fasta files add the final protein sequences
touch $OUT_MAINPROTEIN/p{0001..0400}.fa

for c in $OUT_DIAM/*.b6o.bkp 					#Iterate through all .fna files in $OUT_DIAM directory
do

	NAME_DIAM_MAPPED=`basename -s .b6o.bkp $c`

	#Command to extract columns: Protein id, bitscores and qseq. #Then, sort column 1 and 2. 
	#After that, keep only first element from duplicates ones.
	cat $c | awk -F "[_\t]" '{print $2, $7, $8}' | sort -u -k1,1 -k2,2 | sort -u -k1,1 -s | awk -F " " '{print $1, $3}' > "$OUT_DIAM/$NAME_DIAM_MAPPED".txt

	# Make fasta file
	python $PY_PROGRAM/makefasta.py $OUT_DIAM/$NAME_DIAM_MAPPED.txt

done


#create a fasta file for each protein sequence within $NAME_DIAM_MAPPED.txt
for d in  $OUT_DIAM/*.fasta
#for d in $OUT_DIAM/GCA_000800185.fasta
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
# Log completion
log "Script completed successfully."	


#for f in *fa; do MUSCLE_NAME=`basename -s .fa $f`; muscle -align $f -output $MUSCLE_NAME.afa; done

#for a in *.afa; do MAPPED_NAME=`basename -s .afa $a`; trimal -gappyout -in $a -out $MAPPED_NAME.trim.aln; done

#raxmlHPC-PTHREADS-SSE3 -f a -N 100 -m PROTGAMMAAUTO -p 12345 -x 12345 -T 7 -s $r -n $tree_NAME.tree
