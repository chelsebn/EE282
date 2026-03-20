#!/bin/bash
#SBATCH -A NEBAKER_LAB
#SBATCH --job-name=star_riboseq
#SBATCH --output=output/star_riboseq_%j.out
#SBATCH --error=output/star_riboseq_%j.err
#SBATCH --cpus-per-task=16
#SBATCH --partition=standard

# Load cutadapt if using module system
source ~/miniconda3/etc/profile.d/conda.sh
conda activate Riboseq_data

# Paths
STAR_INDEX="/pub/chelsebn/BakerLab/Riboseq_data/star_index"
INPUT_DIR="/pub/chelsebn/BakerLab/Riboseq_data/processed_riboseq/cleaned"
OUTPUT_DIR="/pub/chelsebn/BakerLab/Riboseq_data/processed_riboseq/aligned"

mkdir -p $OUTPUT_DIR

echo "Starting STAR alignment for cleaned Ribo-seq files..."

for file in ${INPUT_DIR}/*_clean.fastq.gz; do
    base=$(basename "$file" _clean.fastq.gz)
    echo "Processing $base..."

STAR \
    --runThreadN 16 \
    --genomeDir $STAR_INDEX \
    --readFilesIn $file \
    --readFilesCommand gunzip -c \
    --alignIntronMax 1 \
    --alignMatesGapMax 1000 \
    --alignSJoverhangMin 8 \
    --alignSJDBoverhangMin 1 \
    --outFilterMismatchNmax 2 \
    --outFilterMultimapNmax 1 \
    --alignEndsType EndToEnd \
    --outFileNamePrefix ${OUTPUT_DIR}/${base}_ \
    --quantMode GeneCounts \
    --outSAMtype BAM SortedByCoordinate \
    --limitBAMsortRAM 31532137230 \
    --outSAMattributes All

done

echo "Aligned BAMs and GeneCounts files are saved in: $OUTPUT_DIR"
