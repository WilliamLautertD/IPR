#!/bin/bash

DIR='/Users/williamlautert/Desktop/William-bio-surf/analysis/287/ANI/Phylogeny'

cd "$DIR"
ls | grep ".faa$" | awk -F '.' '{print $1}' > "$DIR/gen_regions_names.txt"

# Specify the path to your text file
file_path="$DIR/gen_regions_names.txt"

# Use a for loop to iterate over each line in the file
while IFS= read -r line; do

  # Your processing logic for each line goes here
  echo "Processing line: $line"

  # Use MUSCLE algorithm to align protein sequences
  muscle -align "$DIR/$line".faa -output "$DIR/align/$line".afa
  

done < "$file_path"
