#!/bin/bash

REF_LIST='/Users/williamlautert/Desktop/William-bio-surf/data/refs/Halomonas_db/ncbi_dataset/data/Halomonas_db_path.txt'
OUT='/Users/williamlautert/Desktop/William-bio-surf/analysis/287/ANI/fastANI'

#Scaffold Trim3 Halomonas_tianxiuensis_BC_M4_5_
genome1='/Users/williamlautert/Desktop/William-bio-surf/analysis/287/assembly/scaffolds/RagTag/scaffold/Halomonas_tianxiuensis_BC_M4_5/index/Halomonas_tianxiuensis_BC_M4_5_ragtag.scaffold.fasta'

#Scaffold Test using "-r" option in RagTag with Halomonas_tianxiuensis_BC_M4_5
genome2='/Users/williamlautert/Desktop/William-bio-surf/analysis/287/assembly/scaffolds/Jan_31/ragtag.scaffold.fasta'

#Scaffold from 253
#genome3='assembly/scaffolds/Jan_31/ragtag.scaffold.fasta'


fastANI -q "$genome1" --rl "$REF_LIST" --matrix -o "$OUT/BIOSURF_287_ANI_TRIM3.txt" --threads 8 -s
fastANI -q "$genome2" --rl "$REF_LIST" --matrix -o "$OUT/BIOSURF_287_ANI_TestJan31.txt" --threads 8 -s

