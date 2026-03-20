#!/bin/bash
#SBATCH -A NEBAKER_LAB
#SBATCH --job-name=make_starindex
#SBATCH --output=output/make_starindex_%j.out
#SBATCH --error=output/make_starindex_%j.err
#SBATCH --cpus-per-task=8
#SBATCH --partition=standard

source ~/miniconda3/etc/profile.d/conda.sh
conda activate RNAseq_data

mkdir -p star_index

STAR \
  --runMode genomeGenerate \
  --genomeDir star_index \
  --genomeFastaFiles /pub/chelsebn/BakerLab/RNAseq_data/genome/dm6.fa \
  --sjdbGTFfile /pub/chelsebn/BakerLab/RNAseq_data/annotation/Drosophila_melanogaster.BDGP6.46.57.gtf \
  --sjdbOverhang 99 \
  --genomeSAindexNbases 12 \
  --runThreadN 8
