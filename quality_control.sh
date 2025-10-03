#!/bin/bash

SEQUENCES='/Users/williamlautert/Desktop/William-bio-surf/data/seqs/sequecing_quality_A679_183603_1/fastqs'

ADAPTER='/Users/williamlautert/Desktop/William-bio-surf/data/seqs/BGBC4-Genoma-completo'

OUT='/Users/williamlautert/Desktop/William-bio-surf/analysis/QC'

#fastqc $SEQUENCES/*fastq.gz -t 6 -o $OUT

fastqc $SEQUENCES/230802193962-1-1-1_S5_L001_R2_001.fastq.gz -t 6 -o $OUT
