#!/bin/bash

set -euo pipefail

GTF_FILE="dmel-all-r6.66.gtf.gz"

# File Integrity using MD5 checksum
echo "File Integrity (MD5 Checksum)"
md5sum "$GTF_FILE" | tee md5sum_gtf.txt
echo "Checksum saved to md5sum_gtf.txt"

# Total number of features per type (sorted most to least common) 
echo ""
echo "Feature Type Counts (most to least common)"
bioawk -c gff '
    !/^#/ { print $feature }
' "$GTF_FILE" \
  | sort \
  | uniq -c \
  | sort -rn \
  | awk '{printf "%-10s %s\n", $1, $2}'

# Total number of genes per chromosome arm 
echo ""
echo "Gene Count per Chromosome Arm"
bioawk -c gff '
    !/^#/ && $feature == "gene" { print $seqname }
' "$GTF_FILE" \
  | grep -E "^(X|Y|2L|2R|3L|3R|4)$" \
  | sort \
  | uniq -c \
  | awk '{printf "%-6s %s\n", $2, $1}' \
  | sort -k1,1
