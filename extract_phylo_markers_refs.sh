#!/bin/bash

DIR='/Users/williamlautert/Desktop/William-bio-surf/data/refs/Halomonas_db/ncbi_dataset/data'

#/Users/williamlautert/Desktop/William-bio-surf/data/refs/Halomonas_db/ncbi_dataset/data

# Specify the path to your text file
file_path="$DIR/Halomonas_db_path.txt"

# Use a for loop to iterate over each line in the file
while IFS= read -r line; do
    (
      echo "Processing line: $line"
      cd "$DIR" || exit
      if perl ~/Documents/Bioinfo/AMPHORA2-master/Scripts/MarkerScanner.pl -DNA -Bacteria "$line"; then
          echo "Script executed successfully."
      else
          echo "Error executing the script."
      fi
    )
done < "$file_path"
