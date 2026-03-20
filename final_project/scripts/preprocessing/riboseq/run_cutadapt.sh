#!/bin/bash
#SBATCH -A NEBAKER_LAB
#SBATCH --job-name=cutadapt_riboseq
#SBATCH --output=output/cutadapt_riboseq_%j.out
#SBATCH --error=output/cutadapt_riboseq_%j.err
#SBATCH --cpus-per-task=8
#SBATCH -p standard  

# Load cutadapt if using module system
source ~/miniconda3/etc/profile.d/conda.sh
conda activate Riboseq_data

INPUT_DIR="/pub/chelsebn/BakerLab/Riboseq_data/unprocessed_riboseq"
OUTPUT_DIR="/pub/chelsebn/BakerLab/Riboseq_data/processed_riboseq/trimmed"

mkdir -p $OUTPUT_DIR

echo "Starting Cutadapt trimming..."

for file in ${INPUT_DIR}/*.fastq.gz; do
    base=$(basename "$file" .fastq.gz)
    echo "Processing $base..."
    cutadapt -j 4 -a A{10} -m 25 -M 35 -u 3 -o ${OUTPUT_DIR}/${base}_trimmed.fastq.gz \
    "$file"
done

echo "Cutadapt trimming complete!"
