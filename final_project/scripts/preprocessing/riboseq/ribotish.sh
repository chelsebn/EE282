#!/bin/bash
#SBATCH -A NEBAKER_LAB
#SBATCH --job-name=ribotish_quality
#SBATCH --output=output/ribotish_quality_%j.out
#SBATCH --error=output/ribotish_quality_%j.err
#SBATCH --cpus-per-task=8
#SBATCH --partition=standard

# Load cutadapt if using module system
source ~/miniconda3/etc/profile.d/conda.sh
conda activate Riboseq_data

# === Paths ===
ALIGN_DIR="/pub/chelsebn/BakerLab/Riboseq_data/processed_riboseq/aligned/bam"
GTF="/pub/chelsebn/BakerLab/Riboseq_data/references/annotation/Drosophila_melanogaster.BDGP6.46.57.gtf"

echo "Starting RiboTish periodicity QC..."

for bam in ${ALIGN_DIR}/*.bam; do
    base=$(basename "$bam".bam)
    echo "Indexing and analyzing ${base}..."

    # Index BAM
    samtools index "$bam"

    # Run ribotish quality
    ribotish quality -b "$bam" -g "$GTF" \
        -o ${ALIGN_DIR}/${base}_ribotish_quality.pdf
done

echo "PDF reports saved in: $ALIGN_DIR"
