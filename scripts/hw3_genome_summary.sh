#!/bin/bash

set -euo pipefail

GENOME_FILE="dmel-all-chromosome-r6.66.fasta.gz"

# File Integrity using MD5 checksum 
echo "File Integrity (MD5 Checksum):"
md5sum "$GENOME_FILE" | tee md5sum_fasta.txt
echo "Checksum saved to md5sum_fasta.txt"

# Genome summaries using faSize 
echo ""
echo "Genome Assembly Summary (faSize):"
faSize "$GENOME_FILE"

echo ""
echo "Parsed Summary:"
faSize "$GENOME_FILE" 2>&1 | awk '
/bases/ {
    for (i=1; i<=NF; i++) {
        val = $i
        gsub(/[^0-9]/, "", val)
        if (val ~ /^[0-9]+$/ && $(i+1) == "bases")     total_bp  = val
        if (val ~ /^[0-9]+$/ && $(i+1) ~ /^N/)         n_count   = val
        if (val ~ /^[0-9]+$/ && $(i+1) == "sequences") seq_count = val
    }
}
END {
    print "Total nucleotides : " total_bp
    print "Total Ns          : " n_count
    print "Total sequences   : " seq_count
}'
