#!/bin/bash
#SBATCH --job-name=install_rnatools
#SBATCH -A NEBAKER_LAB
#SBATCH -p standard
#SBATCH --cpus-per-task=4
#SBATCH --error=output/install_rnaotools-%J.err
#SBATCH --output=output/install_rnatools-%J.out

source ~/miniconda3/etc/profile.d/conda.sh
conda create -n RNAseq_data -c bioconda -c conda-forge fastqc trim-galore star subread multiqc samtools