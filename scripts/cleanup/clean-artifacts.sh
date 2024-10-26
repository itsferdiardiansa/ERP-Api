#!/bin/bash
set -e

# Configuration
ARTIFACT_DIRS=("dist" "build" "coverage" "node_modules" "tmp" ".cache")
MIN_AGE_DAYS=${MIN_AGE_DAYS:-7}  # Files older than this age (in days) will be deleted
DRY_RUN=${DRY_RUN:-"true"}       # Set to "false" to perform actual deletion

# Function to clean artifacts older than specified days
clean_old_files() {
  local dir=$1
  echo "Checking directory: $dir"

  # Find and delete files older than MIN_AGE_DAYS if not in dry run mode
  find "$dir" -type f -mtime +"$MIN_AGE_DAYS" -print -exec rm -f {} \; > /dev/null 2>&1
  find "$dir" -type d -empty -print -exec rm -rf {} \; > /dev/null 2>&1
}

# Iterate over artifact directories and clean them
for dir in "${ARTIFACT_DIRS[@]}"; do
  if [ -d "$dir" ]; then
    echo "Cleaning artifacts in $dir older than $MIN_AGE_DAYS days"
    if [ "$DRY_RUN" == "true" ]; then
      echo "(Dry Run) Found files:"
      find "$dir" -type f -mtime +"$MIN_AGE_DAYS"
    else
      clean_old_files "$dir"
      echo "Old artifacts in $dir removed."
    fi
  else
    echo "Directory $dir not found, skipping."
  fi
done

# Summary
if [ "$DRY_RUN" == "true" ]; then
  echo "Dry run complete. No files were actually deleted."
else
  echo "Cleanup complete. Old artifacts deleted."
fi