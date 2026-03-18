#!/usr/bin/env bash
#SBATCH --job-name=compleasm
#SBATCH --account=nebaker_lab
#SBATCH --cpus-per-task=16
#SBATCH --mem=128G

source /data/homezvol0/chelsebn/miniconda3/etc/profile.d/conda.sh
conda activate ee282

ASSEMBLY="/pub/chelsebn/EE282/hw4/output/iso1_assembly.bp.p_ctg.fa"
REFERENCE_CONTIG="/pub/chelsebn/EE282/hw4/references/GCA_000001215.4_Release_6_plus_ISO1_MT_genomic.fna"
OUTDIR="/pub/chelsebn/EE282/hw4/output/compleasm"
mkdir -p "$OUTDIR"

# Your assembly
compleasm run \
    -a "$ASSEMBLY" \
    -o "$OUTDIR/assembly" \
    -l diptera \
    -t 16

# FlyBase contig reference
compleasm run \
    -a "$REFERENCE_CONTIG" \
    -o "$OUTDIR/flybase_contig" \
    -l diptera \
    -t 16
