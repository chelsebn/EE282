#!/usr/bin/env Rscript

library(ggplot2)
outdir <- "output"

small <- read.table(file.path(outdir, "small_stats.tsv"),
                    col.names = c("length", "gc"))
large <- read.table(file.path(outdir, "large_stats.tsv"),
                    col.names = c("length", "gc"))
save_plot <- function(p, filename) {
  ggsave(file.path(outdir, filename), p, width = 7, height = 5)
  message("Saved: ", filename)
}

# Plot Sequence length histograms (log scale)
plot_len_hist <- function(df, label) {
  ggplot(df, aes(x = length)) +
    geom_histogram(bins = 60, fill = "steelblue", color = "white", linewidth = 0.2) +
    scale_x_log10(labels = scales::comma) +
    labs(title = paste("Sequence Length Distribution —", label),
         x = "Sequence Length (bp, log scale)", y = "Count") +
    theme_classic()
}

save_plot(plot_len_hist(small, "≤100kb"), "length_hist_small.png")
save_plot(plot_len_hist(large, ">100kb"), "length_hist_large.png")

# Plot GC% histograms 
plot_gc_hist <- function(df, label) {
  ggplot(df, aes(x = gc)) +
    geom_histogram(bins = 40, fill = "coral", color = "white", linewidth = 0.2) +
    labs(title = paste("GC% Distribution —", label),
         x = "GC Content (%)", y = "Count") +
    theme_classic()
}

save_plot(plot_gc_hist(small, "≤100kb"), "gc_hist_small.png")
save_plot(plot_gc_hist(large, ">100kb"), "gc_hist_large.png")

# Plot Cumulative size (largest → smallest) 
plot_cdf <- function(df, label) {
  sorted_len <- sort(df$length, decreasing = TRUE)
  cum_size   <- cumsum(as.numeric(sorted_len))
  cdf_df     <- data.frame(rank = seq_along(cum_size), cum_bp = cum_size)

  ggplot(cdf_df, aes(x = rank, y = cum_bp)) +
    geom_line(color = "darkgreen", linewidth = 0.8) +
    scale_y_continuous(labels = scales::comma) +
    labs(title = paste("Cumulative Sequence Size —", label),
         x = "Sequences (sorted largest → smallest)",
         y = "Cumulative Size (bp)") +
    theme_classic()
}

save_plot(plot_cdf(small, "≤100kb"), "cdf_small.png")
save_plot(plot_cdf(large, ">100kb"), "cdf_large.png")

