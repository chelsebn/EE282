#!/bin/bash
#SBATCH --job-name=install_ribotools
#SBATCH -A NEBAKER_LAB
#SBATCH -p standard
#SBATCH --cpus-per-task=4
#SBATCH --error=output/install_ribotools-%J.err
#SBATCH --output=output/install_ribotools-%J.out

source ~/miniconda3/etc/profile.d/conda.sh
conda activate Riboseq_data

# Fix the solver issue
conda config --set solver classic

# Install all tools including deeptools
conda install -y -c conda-forge -c bioconda cutadapt star subread multiqc ribotish deeptools

# Check installation
conda list | grep -E "(cutadapt|star|subread|multiqc|ribotish|deeptools|bamCoverage)"
