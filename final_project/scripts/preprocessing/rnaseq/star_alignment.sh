#!/bin/bash
#SBATCH -A NEBAKER_LAB
#SBATCH --job-name=star_align_rnaseq
#SBATCH --output=output/star_align_rnaseq_%j.out
#SBATCH --error=output/star_align_rnaseq_%j.err
#SBATCH --cpus-per-task=8
#SBATCH --partition=standard

source ~/miniconda3/etc/profile.d/conda.sh
conda activate RNAseq_data

TRIMMED=/pub/chelsebn/BakerLab/RNAseq_data/results/2_trimmed_output
ALIGNED=/pub/chelsebn/BakerLab/RNAseq_data/results/4_aligned_sequences

samples=(
  68A 68B 68C
  70A_T 70B_T 70C_T
  77A 77B 77C
  82A_T 82B_T 82C_T
  F14A F14B F14C
  FA_T FB_T FC_T
)

for sample in "${samples[@]}"
do
  echo "Aligning $sample"

  STAR \
    --genomeDir star_index \
    --readFilesCommand zcat \
    --readFilesIn ${TRIMMED}/${sample}_R1_val_1.fq.gz ${TRIMMED}/${sample}_R2_val_2.fq.gz \
    --outFilterMismatchNmax 2 \
    --runThreadN 8 \
    --outSAMtype BAM SortedByCoordinate \
    --quantMode GeneCounts \
    --outFileNamePrefix ${ALIGNED}/${sample}_

done

