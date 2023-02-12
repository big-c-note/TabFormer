#!/bin/bash

src_dir=$GPT_DATA_IN
dst_dir=$GPT_DATA_OUT

# Define the prefix of the folder to be moved
folder_prefix="checkpoint"

# Continuously monitor the source directory for the folder
while true; do
  # Search for the folder with the specified prefix
  folders=($(find "$src_dir" -maxdepth 1 -type d -name "$folder_prefix-*" | sort -t- -k2 -n | awk -F- '{print $NF}'))
  # Get the number of folders in the directory
  folder_count=$(find "$src_dir" -maxdepth 1 -type d -name "$folder_prefix*" | wc -l)

  # Check if the number of folders is greater than 10
  if [ "$folder_count" -gt 10 ]; then
    # Get the third highest value
    ninth_highest=${folders[1]}

    # Loop through the folders
    for folder in "${folders[@]}"; do
      # Remove the folder if the value is lower than the ninth highest
      if [ "$folder" -lt "$ninth_highest" ]; then
      # Move the folder to the destination directory
        mv "$src_dir$folder_prefix-$folder" "$dst_dir"
        echo "$(date +"%Y-%m-%d %H:%M:%S") Found and moving folder: $folder-prefix-$folder"
        sleep 5
      else
        echo "sleeping for 2 seconds"
        sleep 2
      fi
    done
  else
    echo "There are 10 or fewer folders in the directory."
    echo "Sleeping..5 seconds"
    sleep 5
  fi
done
