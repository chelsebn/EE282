#!/bin/bash

# Base directories
COMPARISONS_DIR="/Users/chelseanguyen/Desktop/EE282/final_project/output"
RSCRIPT_PATH="/Users/chelseanguyen/Desktop/EE282/final_project/scripts/analysis/deltaTE/translational_regulation/DTEG.R"

# Check if comparisons directory exists
if [ ! -d "$COMPARISONS_DIR" ]; then
    echo "Error: Comparisons directory not found: $COMPARISONS_DIR"
    exit 1
fi

# Check if R script exists
if [ ! -f "$RSCRIPT_PATH" ]; then
    echo "Error: R script not found: $RSCRIPT_PATH"
    exit 1
fi

# Loop through each subdirectory in Comparisons
for group_dir in "$COMPARISONS_DIR"/*; do
    
    # Skip if not a directory
    if [ ! -d "$group_dir" ]; then
        continue
    fi
    
    # Get the group name (basename of directory)
    group_name=$(basename "$group_dir")
    
    # Define full absolute file paths
    # FIX: Use group_dir to construct absolute paths
    ribo_file="$group_dir/RiboSeq.txt"
    rna_file="$group_dir/RNASeq.txt"
    exp_file="$group_dir/sample_info.txt"
    
    # Check if all required files exist
    if [ -f "$ribo_file" ] && [ -f "$rna_file" ] && [ -f "$exp_file" ]; then
        
        echo "Processing: $group_name"
        # Rscript is executed passing the FULL PATHS
        # The use of a subshell (cd "$group_dir") is no longer strictly necessary 
        # for file lookup, but we keep it to ensure the output files are written 
        # to the correct directory (./Results) relative to the input files.

        (
            cd "$group_dir" || { echo "Error: Failed to enter directory: $group_dir"; exit 1; }

            # Rscript is called using the RELATIVE file paths (passed as arguments)
            # RiboSeq.txt will be the argument, and R will find it in the current working directory.
            Rscript --vanilla "$RSCRIPT_PATH" "RiboSeq.txt" "RNASeq.txt" "sample_info.txt" 0
    
            # Check if Rscript completed successfully
            if [ $? -eq 0 ]; then
                echo "✓ Completed: $group_name"
            else
                echo "✗ Error processing: $group_name"
            fi
            echo "---"
        )
    else
        # ... (error skipping logic remains the same)
        echo "⚠ Skipping $group_name - missing required files"
        [ ! -f "$ribo_file" ] && echo "  Missing: $ribo_file"
        [ ! -f "$rna_file" ] && echo "  Missing: $rna_file"
        [ ! -f "$exp_file" ] && echo "  Missing: $exp_file"
        echo "---"
    fi
done