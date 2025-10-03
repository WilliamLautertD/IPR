#!/bin/bash 
# Created by: William Lautert, Institute of Petroleum and Natural Resources, PUCRS-BR 
# 'trycycler_polyshing_polypolish_pypolca.sh': Polishing sequences using Illumina reads. Short-reads polishers after Medaka. 


# Environmental variables

READS='/home/ipr/biosurf/analysis/Reads_QC/Illumina_reads'
ASSEMBLY='/home/ipr/biosurf/analysis/assembly/Nanopore_Illumina'
threads=26

# Export variables

export READS ASSEMBLY threads

# Loop through specified trycycler directories (Isolates with paired Illumina reads)
for i in $ASSEMBLY/BIOSURF_235_trycycler $ASSEMBLY/BIOSURF_250_trycycler $ASSEMBLY/BIOSURF_253_trycycler $ASSEMBLY/BIOSURF_282_trycycler $ASSEMBLY/BIOSURF_283_trycycler $ASSEMBLY/BIOSURF_287_trycycler; do
	
	#Extract base name (e.g.: BIOSURF_XXX)
	NAME=`basename -s _trycycler $i`
	
	for c in "$i"/cluster_*; do
		
		
		# Find matching R1 and R2 files
       		R1=$(find "$READS/${NAME}_trim" -type f -name '*R1*.fq.gz' -o -name '*R1*.fastq.gz' | head -n 1)
        	R2=$(find "$READS/${NAME}_trim" -type f -name '*R2*.fq.gz' -o -name '*R2*.fastq.gz' | head -n 1)

		# Debugging output
        	echo "Processing cluster: $c"
 		echo "R1 file: $R1"
        	echo "R2 file: $R2"
		
		# BWA Index
		#bwa index "$c/8_medaka.fasta"
		
		# BWA Alignments
		#bwa mem -t "$threads" -a "$c/8_medaka.fasta" "$R1" > "$c"/alignments_1.sam
		#bwa mem -t "$threads" -a "$c/8_medaka.fasta" "$R2" > "$c"/alignments_2.sam
		
		# Polypolish Filter and Polish
		#polypolish filter --in1 "$c/alignments_1.sam" --in2 "$c/alignments_2.sam" --out1 "$c/filtered_1.sam" --out2 "$c/filtered_2.sam"
		#polypolish polish "$c/8_medaka.fasta" "$c/filtered_1.sam" "$c/filtered_2.sam" > "$c/polypolish.fasta"
		
		
		# PyPolca Run
		/home/ipr/anaconda3/bin/pypolca run -f --careful -a "$c"/polypolish.fasta -1 "$R1" -2 "$R2" -t "$threads" -o "$c"/pypolca
		cp "$c/pypolca/pypolca_corrected.fasta" "$c/polypolish_pypolca.fasta"		

    	done
done
