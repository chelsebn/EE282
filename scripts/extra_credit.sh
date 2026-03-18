#!/usr/bin/env bash
#SBATCH --job-name=extra_credit
#SBATCH --account=nebaker_lab
#SBATCH --cpus-per-task=16
#SBATCH --mem=64G

source /data/homezvol0/chelsebn/miniconda3/etc/profile.d/conda.sh
conda activate ee282

SCAFFOLD="/pub/chelsebn/EE282/hw4/references/dmel-all-chromosome-r6.66.fasta.gz"
ASSEMBLY="/pub/chelsebn/EE282/hw4/output/iso1_assembly.bp.p_ctg.fa"
OUTDIR="/pub/chelsebn/EE282/hw4/output/mummer"
mkdir -p "$OUTDIR"

# Split scaffold assembly into contigs at Ns
faSplitByN "$SCAFFOLD" "$OUTDIR/flybase_contigs.fa" 10

# Nucmer alignment (query=your assembly, ref=flybase contigs)
nucmer --maxmatch \
       --threads 16 \
       -p "$OUTDIR/mummer_out" \
       "$OUTDIR/flybase_contigs.fa" \
       "$ASSEMBLY"

# Filter alignments (keep best)
delta-filter -r -q "$OUTDIR/mummer_out.delta" > "$OUTDIR/mummer_filtered.delta"

# Generate dotplot
mummerplot --fat \
           --layout \
           --filter \
           -t png \
           -p "$OUTDIR/dotplot" \
           "$OUTDIR/mummer_filtered.delta"

