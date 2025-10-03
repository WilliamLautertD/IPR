#!/bin/bash 
# Created by: William Lautert, Institute of Petroleum and Natural Resources, PUCRS-BR 

# Environmental variables
DIR='/home/ipr/biosurf/analysis/assembly/Nanopore_Illumina'
OUT_DIR='/media/ipr/Expansion/transfer_tmp'

# Export variables

export DIR OUT_DIR

# Transfer files

for i in "$DIR"/*_yes_illumina_assembly
do		
	NAME=`basename -s _yes_illumina_assembly $i`
	mkdir -p "$OUT_DIR/${NAME}"_gfa
	cp "$i"/*.gfa "$OUT_DIR/${NAME}"_gfa
done
