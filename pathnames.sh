#!/bin/bash



DIR='/Users/williamlautert/Desktop/William-bio-surf/data/refs/Halomonas_db/ncbi_dataset/data'

cd "$DIR"
ls | grep "^GCF" > "$DIR/GCF_names.txt"

# Specify the path to your text file
file_path="$DIR/GCF_names.txt"

# Use a for loop to iterate over each line in the file
while IFS= read -r line; do

  # Your processing logic for each line goes here
  echo "Processing line: $line"

  # Append all file names inside the directory to the output file
  find "$DIR/$line" -type f -name "*_genomic.fna" >> "$DIR/Halomonas_db_path.txt"

done < "$file_path"
