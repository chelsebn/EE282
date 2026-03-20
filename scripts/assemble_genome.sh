#!/usr/bin/env bash
#SBATCH --job-name=hifiasm_assembly
#SBATCH --account=nebaker_lab
#SBATCH --cpus-per-task=16

source /data/homezvol0/chelsebn/miniconda3/etc/profile.d/conda.sh
conda activate ee282

READS="/pub/chelsebn/EE282/hw4/data/ISO_HiFi_Shukla2025.fasta.gz"
OUTDIR="/pub/chelsebn/EE282/hw4/output"
mkdir -p "$OUTDIR"

# Run assembly
hifiasm -o "$OUTDIR/iso1_assembly" -t 16 "$READS"

# Convert GFA to FASTA
awk '/^S/{print ">"$2"\n"$3}' "$OUTDIR/iso1_assembly.bp.p_ctg.gfa" \
    > "$OUTDIR/iso1_assembly.bp.p_ctg.fa"

