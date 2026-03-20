#!/usr/bin/env Rscript

library(clusterProfiler)
library(org.Dm.eg.db)
library(ggplot2)
library(dplyr)
library(gridExtra)

base_dir <- "/Users/chelseanguyen/Desktop/EE282/final_project/output"
outdir   <- file.path(base_dir, "GO_enrichment_by_category")
dir.create(outdir, recursive = TRUE, showWarnings = FALSE)

comparisons <- c("Xrp1_vs_RpS3", "Xrp1_vs_RpS3_Xrp1",
                 "Xrp1_vs_RpS12", "Xrp1_vs_RpS12_RpS3")

pvalue_cutoff <- 0.05
qvalue_cutoff <- 0.1
top_n         <- 20

# BACKGROUND

all_genes <- keys(org.Dm.eg.db, keytype = "FLYBASE")
cat(sprintf("Background: %d genes\n\n", length(all_genes)))

# run enrichGO and return top N plot data
run_ego <- function(genes, label) {
  if (length(genes) < 10) {
    cat(sprintf("    %s: fewer than 10 genes, skipping\n", label))
    return(NULL)
  }
  ego <- tryCatch(
    enrichGO(
      gene          = genes,
      universe      = all_genes,
      OrgDb         = org.Dm.eg.db,
      keyType       = "FLYBASE",
      ont           = "BP",
      pAdjustMethod = "BH",
      pvalueCutoff  = pvalue_cutoff,
      qvalueCutoff  = qvalue_cutoff,
      readable      = TRUE
    ),
    error = function(e) { cat(sprintf("    %s ERROR: %s\n", label, e$message)); NULL }
  )
  if (is.null(ego) || nrow(ego@result) == 0) {
    cat(sprintf("    %s: no enriched terms\n", label))
    return(NULL)
  }
  sig <- sum(ego@result$p.adjust < qvalue_cutoff)
  cat(sprintf("    %s: %d enriched terms\n", label, sig))
  ego@result %>%
    filter(p.adjust < qvalue_cutoff) %>%
    arrange(p.adjust) %>%
    head(top_n) %>%
    mutate(Description = substr(Description, 1, 55))
}

# HELPER: make a dot plot panel
make_panel <- function(df, title, color) {
  if (is.null(df) || nrow(df) == 0) {
    return(ggplot() +
             annotate("text", x = 0.5, y = 0.5,
                      label = "No enriched terms", size = 4, color = "gray50") +
             theme_void() +
             ggtitle(title) +
             theme(plot.title = element_text(size = 10, face = "bold", color = color)))
  }
  ggplot(df, aes(x = Count,
                 y = reorder(Description, -p.adjust),
                 size = Count,
                 color = p.adjust)) +
    geom_point() +
    scale_color_gradient(low = color, high = "gray80",
                         limits = c(0, qvalue_cutoff)) +
    scale_size_continuous(range = c(2, 8)) +
    labs(title  = title,
         x      = "Gene Count",
         y      = NULL,
         color  = "Adj. P-value",
         size   = "Gene Count") +
    theme_minimal(base_size = 9) +
    theme(plot.title  = element_text(size = 10, face = "bold", color = color),
          axis.text.y = element_text(size = 7))
}

# MAIN LOOP
for (comp in comparisons) {
  cat(sprintf("=== %s ===\n", comp))

  exclusive_file <- file.path(base_dir, comp, "Results", "gene_lists", "exclusive.txt")
  te_file        <- file.path(base_dir, comp, "Results", "fold_changes", "deltaTE.txt")

  if (!file.exists(exclusive_file)) {
    cat("  Skipping — exclusive.txt not found\n\n"); next
  }
  if (!file.exists(te_file)) {
    cat("  Skipping — deltaTE.txt not found\n\n"); next
  }

  # Load and clean exclusive gene list
  excl <- read.table(exclusive_file, header = FALSE,
                     stringsAsFactors = FALSE)$V1
  excl <- trimws(excl)
  excl <- excl[excl != ""]
  excl <- gsub("^FBGN", "FBgn", excl)

  # Load deltaTE fold changes
  te <- read.table(te_file, header = TRUE, sep = "\t", stringsAsFactors = FALSE)
  te$Gene <- gsub("^FBGN", "FBgn", trimws(te$Gene))

  # Filter to exclusive genes only
  te_excl <- te %>% filter(Gene %in% excl)

  up_genes   <- te_excl %>% filter(log2FoldChange > 0) %>% pull(Gene)
  down_genes <- te_excl %>% filter(log2FoldChange < 0) %>% pull(Gene)

  cat(sprintf("  %d exclusive genes: %d up, %d down\n",
              length(excl), length(up_genes), length(down_genes)))

  # Run GO
  up_data   <- run_ego(up_genes,   "UP")
  down_data <- run_ego(down_genes, "DOWN")

  # Save result tables
  if (!is.null(up_data))
    write.table(up_data,
                file.path(outdir, paste0(comp, "_exclusive_UP_GO.txt")),
                sep = "\t", quote = FALSE, row.names = FALSE)
  if (!is.null(down_data))
    write.table(down_data,
                file.path(outdir, paste0(comp, "_exclusive_DOWN_GO.txt")),
                sep = "\t", quote = FALSE, row.names = FALSE)

  # Build side-by-side PNG
  p_up   <- make_panel(up_data,   paste0("UP — ", comp),   "#E41A1C")
  p_down <- make_panel(down_data, paste0("DOWN — ", comp), "#377EB8")

  png_file <- file.path(outdir, paste0(comp, "_exclusive_UP_DOWN.png"))
  png(png_file, width = 2800, height = 1400, res = 200)
  grid.arrange(p_up, p_down, ncol = 2)
  dev.off()

  cat(sprintf("  Saved: %s\n\n", basename(png_file)))
}

cat("Done. Outputs saved to:\n")
cat(sprintf("  %s\n", outdir))