#!/usr/bin/env bash
#SBATCH --job-name=assembly_assessment
#SBATCH --account=nebaker_lab
#SBATCH --cpus-per-task=4

source /data/homezvol0/chelsebn/miniconda3/etc/profile.d/conda.sh
conda activate ee282

ASSEMBLY="/pub/chelsebn/EE282/hw4/output/iso1_assembly.bp.p_ctg.fa"
REFERENCE_CONTIG="/pub/chelsebn/EE282/hw4/references/GCA_000001215.4_Release_6_plus_ISO1_MT_genomic.fna"
REFERENCE_SCAFFOLD="/pub/chelsebn/EE282/hw4/references/dmel-all-chromosome-r6.66.fasta.gz"
OUTDIR="/pub/chelsebn/EE282/hw4/output"

# Calculate N50 
bioawk -c fastx '{print length($seq)}' "$ASSEMBLY" \
    | sort -rn \
    | awk 'BEGIN{s=0} {s+=$1; lens[NR]=$1; total=s} END{
        cumsum=0;
        for(i=1; i<=NR; i++){
            cumsum+=lens[i];
            if(cumsum >= total/2){print "N50 =", lens[i]; break}
        }
    }'

faSize "$ASSEMBLY"

# Extract lengths for contiguity plot
bioawk -c fastx '{print length($seq)}' "$ASSEMBLY"          | sort -rn > "$OUTDIR/lengths_assembly.txt"
bioawk -c fastx '{print length($seq)}' "$REFERENCE_CONTIG"  | sort -rn > "$OUTDIR/lengths_contig.txt"
bioawk -c fastx '{print length($seq)}' "$REFERENCE_SCAFFOLD"| sort -rn > "$OUTDIR/lengths_scaffold.txt"

# Contiguity plot (base R, sorry could not get plotCDF2 to work)
echo "=== Generating contiguity plot ==="
Rscript - <<'EOF'
outdir <- "/pub/chelsebn/EE282/hw4/output"

make_cdf <- function(file) {
  lens <- as.numeric(readLines(file))
  lens <- lens[lens > 0]
  list(rank = seq_along(lens), cumsize = cumsum(lens))
}

assembly <- make_cdf(file.path(outdir, "lengths_assembly.txt"))
contig   <- make_cdf(file.path(outdir, "lengths_contig.txt"))
scaffold <- make_cdf(file.path(outdir, "lengths_scaffold.txt"))

png(file.path(outdir, "contiguity_plot.png"), width = 800, height = 600)

plot(assembly$rank, assembly$cumsize,
     type = "l", col = "steelblue", lwd = 2,
     log = "x",
     xlab = "Sequence Rank (log scale)",
     ylab = "Cumulative Size (bp)",
     main = "Contiguity Plot",
     xlim = c(1, max(scaffold$rank)),
     ylim = c(0, max(scaffold$cumsize)))

lines(contig$rank,   contig$cumsize,   col = "coral",     lwd = 2)
lines(scaffold$rank, scaffold$cumsize, col = "darkgreen", lwd = 2)

legend("bottomright",
       legend = c("My Assembly", "FlyBase Contig", "FlyBase Scaffold"),
       col    = c("steelblue", "coral", "darkgreen"),
       lwd    = 2)

dev.off()
EOF

