#!/bin/bash
#SBATCH --job-name=remove_abundant
#SBATCH -A NEBAKER_LAB
#SBATCH --output=output/remove_abundant_%j.out
#SBATCH --error=output/remove_abundant_%j.err
#SBATCH --cpus-per-task=8
#SBATCH --partition=standard

source ~/miniconda3/etc/profile.d/conda.sh
conda activate Riboseq_data

ABUNDANT_INDEX="/pub/chelsebn/BakerLab/Riboseq_data/references/abundant/abundant_index"
TRIMMED_DIR="/pub/chelsebn/BakerLab/Riboseq_data/processed_riboseq/trimmed"
CLEAN_DIR="/pub/chelsebn/BakerLab/Riboseq_data/processed_riboseq/cleaned"
STATS_FILE="${CLEAN_DIR}/depletion_stats.txt"

mkdir -p $CLEAN_DIR

if [ ! -f "${ABUNDANT_INDEX}.1.bt2" ]; then
    echo "ERROR: Bowtie2 index not found at $ABUNDANT_INDEX"
    exit 1
fi

echo "Starting removal of abundant sequences..."
echo "Sample,Total_Reads,rRNA_Aligned,rRNA_Percent,Clean_Reads" > $STATS_FILE

for file in ${TRIMMED_DIR}/*_trimmed.fastq.gz; do
    base=$(basename "$file" _trimmed.fastq.gz)
    echo "Processing $base ..."

    # Fixed: removed conflicting --score-min parameter
    bowtie2 -p 8 -x $ABUNDANT_INDEX \
        -U $file \
        --un-gz ${CLEAN_DIR}/${base}_clean.fastq.gz \
        -S /dev/null \
        --very-sensitive-local \
        2>&1 | tee ${CLEAN_DIR}/${base}_bowtie2.log

    # Extract stats
    total=$(grep "reads; of these:" ${CLEAN_DIR}/${base}_bowtie2.log | awk '{print $1}')
    aligned=$(grep "aligned exactly 1 time" ${CLEAN_DIR}/${base}_bowtie2.log | awk '{print $1}')
    multi=$(grep "aligned >1 times" ${CLEAN_DIR}/${base}_bowtie2.log | awk '{print $1}')

    if [ ! -z "$total" ]; then
        total_aligned=$((aligned + multi))
        clean=$((total - total_aligned))
        percent=$(awk "BEGIN {printf \"%.2f\", ($total_aligned/$total)*100}")
        echo "$base,$total,$total_aligned,$percent,$clean" >> $STATS_FILE
    fi

done

echo "=== Depletion Summary ==="
column -t -s',' $STATS_FILE
