#!/bin/bash 
# Created by: William Lautert, Institute of Petroleum and Natural Resources, PUCRS-BR 
# 'cp_ref_genomes.sh': Copy final assemblies (ref) genomes to '/genomes' file. 

# Environmental variables
DIR='/home/ipr/biosurf/analysis/assembly/Nanopore/'
OUT_DIR='/home/ipr/biosurf/analysis/assembly/genomes'

# Export variables

export DIR OUT_DIR

# Transfer files

for i in "$DIR"/*_trycycler
do		
	NAME=`basename -s _trycycler $i`
	cp "$i"/cluster_001/8_medaka.fasta "$OUT_DIR/${NAME}"_ref.fasta
done
