# Homework 3 — EE282

## Summarize Genome Assembly

### File Used

- **File:** `dmel-all-chromosome-r6.66.fasta.gz`
- **Source:** https://ftp.flybase.net/releases/current/dmel_r6.66/fasta/

### File Integrity

MD5 checksum computed locally and saved to `md5sum_fasta.txt`:

```bash
md5sum dmel-all-chromosome-r6.66.fasta.gz | tee md5sum_fasta.txt
```

| File | MD5 Checksum |
|---|---|
| `dmel-all-chromosome-r6.66.fasta.gz` | `ccb86e94117eb4eeaaf70efb6be1b6b9` |

### Calculate Summaries of the Genome

Computed using `faSize`, which natively processes gzipped fasta files:

```bash
faSize dmel-all-chromosome-r6.66.fasta.gz
```

Full output:
```
143726002 bases (1152978 N's 142573024 real 142573024 upper 0 lower) in 1870 sequences in 1 files
Total size: mean 76858.8 sd 1382100.2 min 544 (211000022279089) max 32079331 (3R) median 1577
N count: mean 616.6 sd 6960.7
U count: mean 76242.3 sd 1379508.4
L count: mean 0.0 sd 0.0
%0.00 masked total, %0.00 masked real
```

| Metric | Value |
|---|---|
| Total number of nucleotides | 143,726,002 |
| Total number of Ns | 1,152,978 |
| Total number of sequences | 1,870 |

---

## Summarize an Annotation File

### File Used

- **File:** `dmel-all-r6.66.gtf.gz`
- **Source:** https://ftp.flybase.net/releases/current/dmel_r6.66/gtf/

### File Integrity

MD5 checksum computed locally and saved to `md5sum_gtf.txt`:

```bash
md5sum dmel-all-r6.66.gtf.gz | tee md5sum_gtf.txt
```

| File | MD5 Checksum |
|---|---|
| `dmel-all-r6.66.gtf.gz` | `ea600dbb86f1779463f69082131753cd` |

### Compile a Report Summarizing the Annotation

#### Total number of features of each type, sorted from the most common to the least common
Using `bioawk -c gff` to extract the feature column, then `sort | uniq -c | sort -rn` to count and rank from most to least common:

```bash
bioawk -c gff '!/^#/ { print $feature }' dmel-all-r6.66.gtf.gz \
  | sort | uniq -c | sort -rn
```

| Count | Feature Type |
|---|---|
| 190,176 | exon |
| 163,377 | CDS |
| 46,856 | 5UTR |
| 33,778 | 3UTR |
| 30,922 | start_codon |
| 30,862 | stop_codon |
| 30,836 | mRNA |
| 17,872 | gene |
| 3,059 | ncRNA |
| 485 | miRNA |
| 365 | pseudogene |
| 312 | tRNA |
| 270 | snoRNA |
| 262 | pre_miRNA |
| 115 | rRNA |
| 32 | snRNA |

#### Total Number of Genes per Chromosome Arm

Filtered for `feature == "gene"` on the major chromosome arms (X, Y, 2L, 2R, 3L, 3R, 4):

```bash
bioawk -c gff '!/^#/ && $feature == "gene" { print $seqname }' dmel-all-r6.66.gtf.gz \
  | grep -E "^(X|Y|2L|2R|3L|3R|4)$" | sort | uniq -c
```

| Chromosome Arm | Gene Count |
|---|---|
| X | 2,704 |
| Y | 113 |
| 2L | 3,508 |
| 2R | 3,649 |
| 3L | 3,481 |
| 3R | 4,226 |
| 4 | 114 |

---

## How to Run Bash Scripts

```
# Run (requires: faSize, bioawk, md5sum in PATH)
bash scripts/hw3_genome_summary.sh
bash scripts/hw3_annotation_summary.sh
```

