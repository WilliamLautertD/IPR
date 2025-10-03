#!/bin/bash 
# Created by: William Lautert, Institute of Petroleum and Natural Resources, PUCRS-BR 
# 'A_pre_trycycler_assembly.sh': Multiple assemblies of the same genome. This is accomplished with read subsets. 


# Environmental variables

READS='/home/ipr/biosurf/analysis/Reads_QC/Nanopore_reads/trimmed_reads/trimming_3/'
OUT_DIR='/home/ipr/biosurf/analysis/assembly/Nanopore_Illumina'
threads=25

# Export variables

export READS OUT_DIR threads
 
# 1) Activate conda environment
#conda activate Trycycler
 
# 2) Read subsampling
find "$READS" -name '*.fq.gz' | parallel -j 1 '

	NAME=$(basename "{}" .fq.gz);
	trycycler subsample --reads "{}" --out_dir "$OUT_DIR/${NAME}_read_subsets" -t "$threads"

'

# 3) Pre-trycycler assembly

for i in "$OUT_DIR"/*_read_subsets
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
done

#conda deactivate

