#!/bin/bash



DIR='/Users/williamlautert/Desktop/William-bio-surf/analysis/287/ANI/Phylogeny'

cd "$DIR"
ls | grep ".pep$" > "$DIR/gen_regions_names.txt"

# Specify the path to your text file
file_path="$DIR/gen_regions_names.txt"

# Use a for loop to iterate over each line in the file
while IFS= read -r line; do

  # Your processing logic for each line goes here
  echo "Processing line: $line"
  cat "$DIR/refs/$line" >> $line

done < "$file_path"
