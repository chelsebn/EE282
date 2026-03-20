#!/bin/bash
#SBATCH -A NEBAKER_LAB
#SBATCH --job-name=fastqc_riboseq
#SBATCH --output=output/fastqc_riboseq_%j.out
#SBATCH --error=output/fastqc_riboseq_%j.err
#SBATCH --cpus-per-task=8
#SBATCH --partition=standard

# Load cutadapt if using module system
source ~/miniconda3/etc/profile.d/conda.sh
conda activate Riboseq_data

# Paths
INPUT_DIR="/pub/chelsebn/BakerLab/Riboseq_data/processed_riboseq/cleaned"
OUTPUT_DIR="/pub/chelsebn/BakerLab/Riboseq_data/processed_riboseq/fastqc_reports"

mkdir -p $OUTPUT_DIR

echo "Running FastQC on cleaned FASTQ files..."

# Loop through all cleaned FASTQs
for file in ${INPUT_DIR}/*.fastq.gz; do
    echo "Processing $file ..."
    fastqc -t 8 -o $OUTPUT_DIR $file
done

echo "Reports saved in: $OUTPUT_DIR"
