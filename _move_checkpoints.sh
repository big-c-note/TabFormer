#!/bin/bash

src_dir=$GPT_DATA_IN
dst_dir=$GPT_DATA_OUT

# Define the prefix of the folder to be moved
folder_prefix="checkpoint"

# Continuously monitor the source directory for the folder
while true; do
  # Search for the folder with the specified prefix
  folder=$(find "$src_dir" -maxdepth 1 -type d -name "$folder_prefix*" | head -n 1)
  # Get the number of folders in the directory
  folder_count=$(find "$src_dir" -maxdepth 1 -type d | wc -l)

  # Check if the number of folders is greater than 10
  if [ "$folder_count" -gt 10 ] && [ -n "$folder" ]; then
    # Move the folder to the destination directory
    mv "$folder" "$dst_dir"
    echo "$(date +"%Y-%m-%d %H:%M:%S") Found folder: $folder"
    sleep 5
  else
    echo "There are 10 or fewer folders in the directory."
    echo "Sleeping..5 seconds"
    sleep 5
  fi
done
