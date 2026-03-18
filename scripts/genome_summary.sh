#!/bin/bash

set -euo pipefail

GENOME="../references/dmel-all-chromosome-r6.66.fasta.gz"
OUTDIR="output"
mkdir -p "$OUTDIR"

# Partitioning genome by small and large 
faFilter -maxSize=100000  "$GENOME" "$OUTDIR/small_seqs.fa"
faFilter -minSize=100001  "$GENOME" "$OUTDIR/large_seqs.fa"
faSize "$OUTDIR/small_seqs.fa"
faSize "$OUTDIR/large_seqs.fa"

# Extract necessary info
bioawk -c fastx '{print length($seq), 100*gc($seq)}' \
    "$OUTDIR/small_seqs.fa" > "$OUTDIR/small_stats.tsv"

bioawk -c fastx '{print length($seq), 100*gc($seq)}' \
    "$OUTDIR/large_seqs.fa" > "$OUTDIR/large_stats.tsv"

