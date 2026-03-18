# Homework 4
**Chelsea Nguyen**
**EE282 | Spring 2026**

---

## Organization of Files 
The directory is seen below. This assignment was completed using a combination of local and hpc3. They were eventually all merged together into the following tree organization.
The Output folder is the output from the scripts ran in the Scripts folder, ran locally. The Plots folder has a copy of all the png's from the Output folder, to be referred to in the Markdown document.
As a note, large data files that were generated from the Output files were not pushed to Github, if you would like to see them, please let me know!

<pre>
├── homework4.html
├── homework4.md
├── output/
│   ├── cdf_large.png
│   ├── cdf_small.png
│   ├── gc_hist_large.png
│   ├── gc_hist_small.png
│   ├── large_seqs.fa
│   ├── large_stats.tsv
│   ├── length_hist_large.png
│   ├── length_hist_small.png
│   ├── small_seqs.fa
│   └── small_stats.tsv
├── plots/
│   ├── cdf_large.png
│   ├── cdf_small.png
│   ├── contiguity_plot.png
│   ├── gc_hist_large.png
│   ├── gc_hist_small.png
│   ├── length_hist_large.png
│   └── length_hist_small.png
├── references/
│   ├── dmel-all-chromosome-r6.66.fasta.gz
│   ├── dmel-all-r6.66.gtf.gz
│   └── GCA_000001215.4_Release_6_plus_ISO1_MT_genomic.fna
└── scripts/
    ├── assemble_genome.sh
    ├── assembly_assessment.sh
    ├── busco_score.sh
    ├── genome_plots.R
    └── genome_summary.sh
</pre>


## Summarize partitions of a genome assembly

### Calculate the following for all sequences ≤100kb and >100kb
See script: [`scripts/genome_summary.sh`](scripts/genome_summary.sh) for the script used to complete this part of the assignment. This was ran locally.

| Metric | ≤100kb | >100kb |
|---|---|---|
| Total nucleotides | 6,178,042 | 137,547,960 |
| Total Ns | 662,593 | 490,385 |
| Total sequences | 1,863 | 7 |

### Plots of the following for for all sequences ≤ 100kb and all sequences > 100kb
See script: [`scripts/genome_plots.R`](scripts/genome_plots.R) for the script used to complete this part of the assignment. This was ran locally.

#### Sequence Length Distribution
![Length histogram ≤100kb](plots/length_hist_small.png)
![Length histogram >100kb](plots/length_hist_large.png)

#### GC% Distribution
![GC histogram ≤100kb](plots/gc_hist_small.png)
![GC histogram >100kb](plots/gc_hist_large.png)

#### Cumulative Sequence Size
![CDF ≤100kb](plots/cdf_small.png)
![CDF >100kb](plots/cdf_large.png)

---

## Genome Assembly

### Assemble a genome using Pacbio HiFi reads 
See script: [`scripts/assemble_genome.sh`](scripts/assemble_genome.sh) for the script used to complete this part of the assignment. This was ran using hpc3. 

---

### Assembly Assessment
See script: [`scripts/assembly_assessment.sh`](scripts/assembly_assessment.sh) for the script used to complete this part of the assignment. This was ran using hpc3. 

#### N50 Comparison

The N50 for my assembly was found by running [`scripts/assembly_assessment.sh`](scripts/assembly_assessment.sh), but the 
N50 for the Drosophila community reference's contig N50 was found by following the link provided in the assignment. It was given
as 25.3 Mb, which in order to be converted to bp, has to be multiplied by 1,000,000, giving us 25,300,000 bp.

| Assembly | N50 |
|---|---|
| My Assembly (hifiasm) | 21,715,751 bp | 
| Drosophila Community Contig | 25,300,000 bp |

#### Contiguity Plot
Additionally, [`scripts/assembly_assessment.sh`](scripts/assembly_assessment.sh) was also used to generate the contiguity plot.

![Contiguity Plot](plots/contiguity_plot.png)

As a note, we expect the FlyBase Contig and FlyBase Scaffold line to be the same, thus there is overlap of the green and orange lines. 

#### BUSCO Scores (via compleasm, diptera_odb12)
See script: [`scripts/busco_score.sh`](scripts/busco_score.sh) for the script used to complete this part of the assignment. This was ran using hpc3. 

Unfortunately, I was unable to use Busco and instead used compleasm as suggested.

| Metric | My Assembly | FlyBase Contig |
|---|---|---|
| Single (S) | 99.39% (5,035) | 99.39% (5,035) |
| Duplicated (D) | 0.39% (20) | 0.47% (24) |
| Fragmented (F) | 0.14% (7) | 0.14% (7) |
| Incomplete (I) | 0.00% (0) | 0.00% (0) |
| Missing (M) | 0.08% (4) | 0.00% (0) |
| **Total BUSCOs** | **5,066** | **5,066** |

---


