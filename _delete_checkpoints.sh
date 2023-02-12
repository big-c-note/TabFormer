#!/bin/bash

# Define the source directory
src_dir=$GPT_DATA_OUT

# Continuously monitor the source directory for folders
while true; do
  # Get a list of folders with a numeric value after a dash in their name
  folders=($(find "$src_dir" -maxdepth 1 -type d -name "*-*" | sort -t- -k2 -n | awk -F- '{print $NF}'))

  # Check if there are at least 3 folders
  if [ ${#folders[@]} -ge 3 ]; then
    # Get the third highest value
    third_highest=${folders[2]}

    # Loop through the folders
    for folder in "${folders[@]}"; do
      # Remove the folder if the value is lower than the third highest
      if [ "$folder" -lt "$third_highest" ]; then
        rm -r "$src_dir/checkpoint-${folder//[!0-9]/}"
	echo "Deleted $src_dir/checkpoint-${folder//[!0-9]/}"
      fi
      echo "sleeping for 2 seconds"
      sleep 2
    done
  else
    echo "only three folders..sleeping for 2 seconds."
    sleep 2
  fi
done
