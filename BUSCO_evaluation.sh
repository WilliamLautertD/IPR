#!/bin/bash 
# Created by: William Lautert, Institute of Petroleum and Natural Resources, PUCRS-BR 
# 'BUSCO_evaluation.sh': BUSCO annotation (genome and geneset mode) for all assemblies. Automatic detect high-level taxonomic lineage for each genome.


# Environmental variables
ASSEMBLY='/home/ipr/biosurf/analysis/assembly/genomes/'
GENESET='/home/ipr/biosurf/analysis/annotation/PROKKA'
#OUT_DIR='/home/ipr/biosurf/analysis/annotation/BUSCO'
threads=12

# Export variables

export ASSEMBLY GENESET threads
 
# 1) Run BUSCO (Genome and geneset mode)
find "$ASSEMBLY" -name '*_ref.fasta' | parallel -j 2 '
	NAME=$(basename "{}" _ref.fasta); 
	busco -i {} -m geno -c $threads -o "${NAME}_genome_specific" --auto-lineage-prok
	busco -i "$(find "${GENESET}/${NAME}_PROKKA" -name '*.faa' | head -n 1)" -m prot -c $threads -o "${NAME}_geneset_specific" --auto-lineage-prok
	
'

# busco -i "${GENESET}/${NAME}_PROKKA/*.faa" -m prot -c $threads -o "${NAME}_dataset_specific" --auto-lineage-prok
