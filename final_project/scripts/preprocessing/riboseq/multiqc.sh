#!/bin/bash
#SBATCH -A NEBAKER_LAB
#SBATCH --job-name=multiqc_riboseq
#SBATCH --output=output/multiqc_riboseq_%j.out
#SBATCH --error=output/multiqc_riboseq_%j.err
#SBATCH --cpus-per-task=8
#SBATCH --partition=standard

set -euo pipefail

mkdir -p output

source ~/miniconda3/etc/profile.d/conda.sh
conda activate Riboseq_data

# === Paths ===
PARENT_DIR="/pub/chelsebn/BakerLab/Riboseq_data/processed_riboseq/aligned"
OUT_DIR="/pub/chelsebn/BakerLab/Riboseq_data/processed_riboseq/multiqc_summary"

mkdir -p "$OUT_DIR"

echo "Running MultiQC summary..."
multiqc "$PARENT_DIR" -o "$OUT_DIR" -f -v

echo "Report saved at: ${OUT_DIR}/multiqc_report.html"
