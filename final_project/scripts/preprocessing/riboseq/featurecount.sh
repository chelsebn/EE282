#!/bin/bash
#SBATCH -A NEBAKER_LAB
#SBATCH --job-name=featureCounts_riboseq
#SBATCH --output=output/featureCounts_riboseq_%j.out
#SBATCH --error=output/featureCounts_riboseq_%j.err
#SBATCH --cpus-per-task=8
#SBATCH --partition=standard

# Load conda
source ~/miniconda3/etc/profile.d/conda.sh
conda activate Riboseq_data

# Make sure the right binary is used
export PATH=~/miniconda3/envs/Riboseq_data/bin:$PATH

echo "Using featureCounts binary:"
which featureCounts
featureCounts -v

# Paths
ALIGN_DIR="/pub/chelsebn/BakerLab/Riboseq_data/processed_riboseq/aligned/bam"
OUT_DIR="/pub/chelsebn/BakerLab/Riboseq_data/processed_riboseq/counts"
GTF="/pub/chelsebn/BakerLab/Riboseq_data/references/annotation/Drosophila_melanogaster.BDGP6.46.57.gtf"

mkdir -p "$OUT_DIR"

echo "Running featureCounts..."
~/miniconda3/envs/Riboseq_data/bin/featureCounts \
  -T 8 -t CDS -g gene_id -s 1 -Q 20 --primary\
  -a "$GTF" \
  -o "$OUT_DIR/RiboSeq_cds_featureCounts.txt" \
  "$ALIGN_DIR"/*.bam

echo "Results saved to: $OUT_DIR/RiboSeq_cds_featureCounts.txt"

