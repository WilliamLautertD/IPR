#!/bin/bash 

# Created by: William Lautert, Institute of Petroleum and Natural Resources, PUCRS-BR 
# 'trycycler_assembly_2_254_274.sh': Multiple assemblies for the isolates 254 and 274 reads subsamples. Number of assemblies = 24


OUT_DIR='/home/ipr/biosurf/analysis/assembly/Nanopore'
threads=25



export OUT_DIR threads

for i in "$OUT_DIR"/*254_no_illumina_read_subsets "$OUT_DIR"/*274_no_illumina_read_subsets
do		
	NAME=`basename -s _read_subsets $i`
	mkdir -p "$OUT_DIR/$NAME"_assembly
	
	#### Read subset 1-3
	flye --nano-hq "$i/sample_01.fastq" --threads "$threads" --out-dir assembly_01 && \
	cp assembly_01/assembly.fasta "$OUT_DIR/$NAME"_assembly/assembly_01.fasta && \
	cp assembly_01/assembly_graph.gfa "$OUT_DIR/$NAME"_assembly/assembly_01.gfa && \
	rm -r assembly_01
	
	miniasm_and_minipolish.sh "$i/sample_02.fastq" "$threads" > "$OUT_DIR/$NAME"_assembly/assembly_02.gfa && \
	any2fasta "$OUT_DIR/$NAME"_assembly/assembly_02.gfa > "$OUT_DIR/$NAME"_assembly/assembly_02.fasta
	
	raven --threads "$threads" --disable-checkpoints --graphical-fragment-assembly \
	"$OUT_DIR/$NAME"_assembly/assembly_03.gfa "$i/sample_03.fastq" > "$OUT_DIR/$NAME"_assembly/assembly_03.fasta
	
	#### Read subset 4-6
	flye --nano-hq "$i/sample_04.fastq" --threads "$threads" --out-dir assembly_04 && \
	cp assembly_04/assembly.fasta "$OUT_DIR/$NAME"_assembly/assembly_04.fasta && \
	cp assembly_04/assembly_graph.gfa "$OUT_DIR/$NAME"_assembly/assembly_04.gfa && \
	rm -r assembly_04
	
	miniasm_and_minipolish.sh "$i/sample_05.fastq" "$threads" > "$OUT_DIR/$NAME"_assembly/assembly_05.gfa && \
	any2fasta "$OUT_DIR/$NAME"_assembly/assembly_05.gfa > "$OUT_DIR/$NAME"_assembly/assembly_05.fasta
	
	raven --threads "$threads" --disable-checkpoints --graphical-fragment-assembly \
	"$OUT_DIR/$NAME"_assembly/assembly_06.gfa $i/sample_06.fastq > "$OUT_DIR/$NAME"_assembly/assembly_06.fasta
	
	#### Read subset 7-9
	flye --nano-hq "$i/sample_07.fastq" --threads "$threads" --out-dir assembly_07 && \
	cp assembly_07/assembly.fasta "$OUT_DIR/$NAME"_assembly/assembly_07.fasta && \
	cp assembly_07/assembly_graph.gfa "$OUT_DIR/$NAME"_assembly/assembly_07.gfa && \
	rm -r assembly_07
	
	miniasm_and_minipolish.sh "$i/sample_08.fastq" "$threads" > "$OUT_DIR/$NAME"_assembly/assembly_08.gfa && \
	any2fasta "$OUT_DIR/$NAME"_assembly/assembly_08.gfa > "$OUT_DIR/$NAME"_assembly/assembly_08.fasta
	
	raven --threads "$threads" --disable-checkpoints --graphical-fragment-assembly \
	"$OUT_DIR/$NAME"_assembly/assembly_09.gfa "$i/sample_09.fastq" > "$OUT_DIR/$NAME"_assembly/assembly_09.fasta
	
	#### Read subset 10-12
	flye --nano-hq "$i/sample_10.fastq" --threads "$threads" --out-dir assembly_10 && \
	cp assembly_10/assembly.fasta "$OUT_DIR/$NAME"_assembly/assembly_10.fasta && \
	cp assembly_10/assembly_graph.gfa "$OUT_DIR/$NAME"_assembly/assembly_10.gfa && \
	rm -r assembly_10
	
	miniasm_and_minipolish.sh "$i/sample_11.fastq" "$threads" > "$OUT_DIR/$NAME"_assembly/assembly_11.gfa && \
	any2fasta "$OUT_DIR/$NAME"_assembly/assembly_11.gfa > "$OUT_DIR/$NAME"_assembly/assembly_11.fasta
	
	raven --threads "$threads" --disable-checkpoints --graphical-fragment-assembly \
	"$OUT_DIR/$NAME"_assembly/assembly_12.gfa "$i/sample_12.fastq" > "$OUT_DIR/$NAME"_assembly/assembly_12.fasta
	
	#### Read subset 13-15
	flye --nano-hq "$i/sample_13.fastq" --threads "$threads" --out-dir assembly_13 && \
	cp assembly_13/assembly.fasta "$OUT_DIR/$NAME"_assembly/assembly_13.fasta && \
	cp assembly_13/assembly_graph.gfa "$OUT_DIR/$NAME"_assembly/assembly_13.gfa && \
	rm -r assembly_13
	
	miniasm_and_minipolish.sh "$i/sample_14.fastq" "$threads" > "$OUT_DIR/$NAME"_assembly/assembly_14.gfa && \
	any2fasta "$OUT_DIR/$NAME"_assembly/assembly_14.gfa > "$OUT_DIR/$NAME"_assembly/assembly_14.fasta
	
	raven --threads "$threads" --disable-checkpoints --graphical-fragment-assembly \
	"$OUT_DIR/$NAME"_assembly/assembly_15.gfa "$i/sample_15.fastq" > "$OUT_DIR/$NAME"_assembly/assembly_15.fasta
	
	#### Read subset 16-18
	flye --nano-hq "$i/sample_16.fastq" --threads "$threads" --out-dir assembly_16 && \
	cp assembly_16/assembly.fasta "$OUT_DIR/$NAME"_assembly/assembly_16.fasta && \
	cp assembly_16/assembly_graph.gfa "$OUT_DIR/$NAME"_assembly/assembly_16.gfa && \
	rm -r assembly_16
	
	miniasm_and_minipolish.sh "$i/sample_17.fastq" "$threads" > "$OUT_DIR/$NAME"_assembly/assembly_17.gfa && \
	any2fasta "$OUT_DIR/$NAME"_assembly/assembly_17.gfa > "$OUT_DIR/$NAME"_assembly/assembly_17.fasta
	
	raven --threads "$threads" --disable-checkpoints --graphical-fragment-assembly \
	"$OUT_DIR/$NAME"_assembly/assembly_18.gfa "$i/sample_18.fastq" > "$OUT_DIR/$NAME"_assembly/assembly_18.fasta
	
	#### Read subset 19-21
	flye --nano-hq "$i/sample_19.fastq" --threads "$threads" --out-dir assembly_19 && \
	cp assembly_19/assembly.fasta "$OUT_DIR/$NAME"_assembly/assembly_19.fasta && \
	cp assembly_19/assembly_graph.gfa "$OUT_DIR/$NAME"_assembly/assembly_19.gfa && \
	rm -r assembly_19
	
	miniasm_and_minipolish.sh "$i/sample_20.fastq" "$threads" > "$OUT_DIR/$NAME"_assembly/assembly_20.gfa && \
	any2fasta "$OUT_DIR/$NAME"_assembly/assembly_20.gfa > "$OUT_DIR/$NAME"_assembly/assembly_20.fasta
	
	raven --threads "$threads" --disable-checkpoints --graphical-fragment-assembly \
	"$OUT_DIR/$NAME"_assembly/assembly_21.gfa "$i/sample_21.fastq" > "$OUT_DIR/$NAME"_assembly/assembly_21.fasta
	
	#### Read subset 22-24
	flye --nano-hq "$i/sample_22.fastq" --threads "$threads" --out-dir assembly_22 && \
	cp assembly_22/assembly.fasta "$OUT_DIR/$NAME"_assembly/assembly_22.fasta && \
	cp assembly_22/assembly_graph.gfa "$OUT_DIR/$NAME"_assembly/assembly_22.gfa && \
	rm -r assembly_22
	
	miniasm_and_minipolish.sh "$i/sample_23.fastq" "$threads" > "$OUT_DIR/$NAME"_assembly/assembly_23.gfa && \
	any2fasta "$OUT_DIR/$NAME"_assembly/assembly_23.gfa > "$OUT_DIR/$NAME"_assembly/assembly_23.fasta
	
	raven --threads "$threads" --disable-checkpoints --graphical-fragment-assembly \
	"$OUT_DIR/$NAME"_assembly/assembly_24.gfa "$i/sample_24.fastq" > "$OUT_DIR/$NAME"_assembly/assembly_24.fasta

done
