#!/bin/bash

#SBATCH --job-name=multi_qc    ## Name of the job.
#SBATCH -A  CHELSEBN 
#SBATCH -p standard              ## partition name
#SBATCH --nodes=1             ## (-N) number of nodes to use
#SBATCH --ntasks=1           ## (-n) number of tasks to launch
#SBATCH --cpus-per-task=1     ## number of cores the job needs
#SBATCH --error=summarize_gene_counts-%J.err  ## error log file
#SBATCH --output=summarize_gene_counts-%J.out ## output log file

source ~/miniconda3/etc/profile.d/conda.sh
conda activate RNAseq_data

multiqc /pub/chelsebn/BakerLab/RNAseq_data/results --outdir /pub/chelsebn/BakerLab/RNAseq_data/results/5_multiQC
