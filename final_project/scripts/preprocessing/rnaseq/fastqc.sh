#!/bin/bash
#SBATCH -A NEBAKER_LAB
#SBATCH --job-name=fastqc_rnaseq
#SBATCH --output=output/fastqc_rnaseq_%j.out
#SBATCH --error=output/fastqc_rnaseq_%j.err
#SBATCH --cpus-per-task=8
#SBATCH --partition=standard

# Load cutadapt if using module system
source ~/miniconda3/etc/profile.d/conda.sh
conda activate RNAseq_data

samples=(
  68A 68B 68C
  70A_T 70B_T 70C_T
  77A 77B 77C
  82A_T 82B_T 82C_T
  F14A F14B F14C
  FA_T FB_T FC_T
)

# Make sure the output directory exists
mkdir -p results/1_initial_qc/

for sample in "${samples[@]}"; do
  echo "Running FastQC on $sample_R1..."
  fastqc -o /pub/chelsebn/BakerLab/RNAseq_data/results/1_initial_qc/ --noextract \
    /mnt/p/RNAseq_data/input/${sample}_R1.fastq.gz

  echo "Running FastQC on $sample_R2..."
  fastqc -o /mnt/p/RNAseq_data/results/1_initial_qc/ --noextract \
    /pub/chelsebn/BakerLab/RNAseq_data/input/${sample}_R2.fastq.gz
done
