#!/bin/bash


DIR='/Users/williamlautert/Desktop/William-bio-surf/data/refs'

datasets download genome accession GCF_018138125.1 --filename Exiguobacterium_alkaliphilum.zip

mv Exiguobacterium_alkaliphilum.zip $DIR

unzip $DIR/Exiguobacterium_alkaliphilum.zip

#datasets download genome taxon "Halomonas" --annotated --assembly-level complete --reference
datasets download genome taxon "Halomonas" --reference --assembly-level complete --filename Holomonas_db.zip


#Download reference sequences from reference type strains of the genus Halomonas
datasets download genome taxon "Halomonas" --reference --assembly-source "refseq" --filename Holomonas_db_Reference.zip

GCF_003254665.1


