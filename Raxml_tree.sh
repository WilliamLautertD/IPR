#!/bin/bash

DIR='/Users/williamlautert/Desktop/William-bio-surf/analysis/287/ANI/Phylogeny/align'

cd "$DIR"
ls | grep ".afa$" | awk -F '.' '{print $1}' > "$DIR/gen_regions_names.txt"

# Specify the path to your text file
file_path="$DIR/gen_regions_names.txt"

# Use a for loop to iterate over each line in the file
while IFS= read -r line; do

  # Your processing logic for each line goes here
  echo "Processing line: $line"

  # Use MUSCLE algorithm to align protein sequences
  raxmlHPC-PTHREADS-SSE3 -f a -N 1000 -m PROTGAMMAAUTO \
  -p 12345 -x 12345 -T 8 -s "$line".afa -n "$line".tree

done < "$file_path"
