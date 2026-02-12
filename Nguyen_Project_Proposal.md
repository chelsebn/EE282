---
title: "Informatics Project Proposal"
author: "Chelsea Nguyen"
date: "`r Sys.Date()`"
output: 
  html_document:
    toc: true
    toc_depth: 3
    theme: united
---

# Title?

## Introduction

Ribosomal proteins (Rp) are essential to the cell, with roles in ribosome biogenesis, as well as in the function of mature ribosomes. Ribosomal protein haploinsufficiency presents an intriguing paradox in cancer biology. Although ribosomal proteins are essential for translation, these genes frequently behave as tumor suppressors. Somatic Rp mutations occur in T-cell Acute Lymphoblastic Leukemia (T-ALL) (De Keersmaecker et al. 2013), Chronic Lymphocytic Leukemia (CLL) (Landau et al. 2013), and colon cancer (Bianchi et al. 2021). Germline Rp mutations also confer cancer predisposition: approximately 60% of Diamond Blackfan Anemia patients carry Rp mutations and show elevated cancer rates (Vlachos et al. 2012), as do Del(5q) myelodysplastic syndrome patients with acquired RPS14 haploinsufficiency (Ebert et al. 2008). The mechanism by which reduced translation capacity leads to oncogenesis remains poorly understood.

In *Drosophila*, Rp haploinsufficiency (Minute mutations) triggers a phenomenon called cell competition, where mutant cells are recognized and eliminated by wild-type neighbors through apoptosis (Morata and Ripoll 1975). This process requires the transcription factor Xrp1, which is specifically upregulated in Rp-haploinsufficient cells and is necessary and sufficient for their elimination (Lee et al. 2018). Xrp1 activates a transcriptional program including stress response genes and pro-apoptotic factors, while also triggering PERK-dependent phosphorylation of eIF2α, which globally suppresses translation initiation (Kang et al. 2015). Critically, the ribosomal protein RpS12 directly regulates Xrp1 activity: loss of one copy of RpS12 suppresses Xrp1 upregulation and rescues cell competition phenotypes even in other Rp mutant backgrounds (Kale et al. 2015). This positions RpS12 as a key sensor of ribosomal stress that couples reduced ribosome levels to downstream stress signaling.

## Data

To study the translational effects of Rp gene haploinsufficiency, we adapted ribosome profiling (Ingolia et al. 2009) to third-instar larval *Drosophila* imaginal disc samples and profiled wing discs from RpS3, RpS12, and Xrp1 mutants and their combinations. In addition to ribosome profiling, bulk RNA sequencing was performed as well. This genome-wide approach will reveal how actively translated transcripts are, enabling us to identify translation-specific effects of Rp haploinsufficiency and determine their dependence on RpS12 and Xrp1. Preprocessing will begin with raw FASTQ sequencing files, making this a complete analytical workflow from sequencing output to biological interpretation.

The raw data consist of single-end sequencing reads (typically 50-75 bp) containing ribosome-protected fragments (RPFs) along with various technical sequences that must be removed during preprocessing. Each FASTQ file contains millions of reads requiring quality assessment, adapter trimming, and filtering. The pipeline must handle the technical complexity of ribosome profiling data, including removal of 3' adapter sequences, size selection for appropriate footprint lengths (28-30 nucleotides), and aggressive filtering of ribosomal RNA contamination which typically comprises 80-95% of raw reads.

## Questions

The overarching goal of this project is to define the translational landscape of ribosomal stress and identify molecular and pathway-level features that determine how RpS12 and Xrp1 mediate translation changes under ribosomal stress. Within the scope of this course, I will address three interconnected computational questions that form the foundation of this larger investigation.

### Question 1: Robust Preprocessing Pipeline

**How can we build a robust preprocessing pipeline that transforms raw sequencing data into analyzable ribosome occupancy profiles?** 

The initial challenge is processing raw FASTQ files through quality control, adapter trimming, rRNA depletion, and genome alignment to generate high-quality ribosome footprint data. I will implement this preprocessing workflow using established tools including FastQC for quality assessment, cutadapt for adapter removal, Bowtie2 for rRNA filtering, and STAR for alignment to the *Drosophila* genome. Success will be evaluated through multiple quality metrics, particularly the 3-nucleotide periodicity of aligned reads, which is indicative of genuine ribosome footprints. This preprocessing stage directly engages with course themes of working with high-throughput sequencing data and implementing reproducible computational workflows on HPC systems.

### Question 2: Differential Translation Analysis

**Which transcripts show differential translation between ribosomal protein mutant genotypes and wild-type controls?** 

Once ribosome occupancy and mRNA abundance are quantified, I will perform differential translation efficiency analysis to identify transcripts whose translation is specifically altered by RpS3 or RpS12 haploinsufficiency, and determine how these changes depend on Xrp1. Using DESeq2 for statistical testing, I will identify significantly up- and down-translated genes in each genotype comparison. Exploratory data analysis and visualization will be central to this question. The goal of the visualizations will be to reveal whether different ribosomal protein mutations cause distinct translational signatures and whether Xrp1 mediates specific subsets of translation changes.

### Question 3: Differential Ribosomal Pausing

**Do ribosomal protein mutations cause altered ribosomal pausing at specific positions within transcripts?** 

Beyond measuring overall translation rates, ribosome profiling data reveal where ribosomes pause during elongation. I will implement a differential pausing analysis pipeline following methods from a previous paper, which identifies positions where ribosome occupancy significantly deviates from local background levels and tests for differential pausing between conditions. This analysis may reveal that ribosomal stress causes ribosomes to stall at specific sequence contexts—such as rare codons or particular amino acids—providing mechanistic insight into how compromised ribosomes struggle during translation. Visualization will include metagene profiles showing ribosome density patterns across transcript features, individual transcript browsers displaying position-specific occupancy, and comparative plots examining pausing differences between RpS3 and RpS12 mutants.

## Feasibility

This project is highly feasible for the time given. First, all experimental data have already been generated and are immediately available. The raw FASTQ files, genome annotations, and reference sequences are prepared and accessible, allowing immediate opportunity to preprocess the data. Second, I have already established functional analysis environments on the HPC cluster, including validated conda installations of required preprocessing tools (cutadapt, STAR, SAMtools) and R packages for differential analysis (DESeq2). Previous successful test runs confirm that the computational infrastructure is operational and that I can submit jobs, manage environments, and execute analysis scripts effectively. Lastly, for the differential pausing analysis, I will follow the specific computational pipeline described by a previous paper, which provides detailed methodology including statistical frameworks and software implementations.

## Conclusions

In conclusion, this project proposes a comprehensive computational analysis of ribosome profiling data to understand how ribosomal protein haploinsufficiency affects translation. By processing raw sequencing data through differential translation analysis and ribosomal pausing detection, I will systematically characterize the translational landscape of ribosomal stress and identify RpS12- and Xrp1-dependent effects. The project is feasible because data are available, computational infrastructure is established, methodological templates exist, and the modular design allows flexible prioritization. Most importantly, this work exemplifies core bioinformatics principles emphasized in this course: implementing reproducible analytical pipelines, conducting exploratory data analysis of complex genomic datasets, and creating effective visualizations that reveal biological patterns. The questions I will address—preprocessing high-throughput sequencing data, identifying differentially translated genes, and detecting altered ribosomal pausing—require the full spectrum of skills developed throughout this course, from command-line data manipulation through statistical analysis to publication-quality figure generation. Success with this project will not only fulfill course objectives but will generate genuine scientific insights into translational control mechanisms underlying cell competition and cancer biology, directly advancing my thesis research while developing computational expertise essential for modern biological investigation.

## References

1. De Keersmaecker K, Atak ZK, Li N, Viciconti C, Kan S, Gleeson E, Van Vlierberghe P, Aslanyan MG, Bono H, Cools J, et al. 2013. Exome sequencing identifies mutation in CNOT3 and ribosomal genes RPL5 and RPL10 in T-cell acute lymphoblastic leukemia. *Nat Genet* 45: 186-190.

2. Landau DA, Carter SL, Stojanov P, McKenna A, Lawrence MS, Sivachenko A, Sougnez C, Stewart C, Tyekucheva S, Reeve EL, et al. 2013. Evolution and impact of subclonal mutations in chronic lymphocytic leukemia. *Cell* 152: 714-726.

3. Bianchi JJ, Zhao X, Mays JC, Davoli T. 2021. Not all created equal: A framework to identify and prioritize cancer dependencies for clinical applications. *Cancer Cell* 39: 779-783.

4. Vlachos A, Rosenberg PS, Atsidaftos E, Alter BP, Lipton JM. 2012. Incidence of neoplasia in Diamond Blackfan anemia: a report from the Diamond Blackfan Anemia Registry. *Blood* 119: 3815-3819.

5. Ebert BL, Pretz J, Bosco J, Chang CY, Tamayo P, Lamprecht B, Donadieu J, Vyas P, Kastan MB, Miller MA, et al. 2008. Identification of RPS14 as a 5q- syndrome gene by RNA interference screen. *Nature* 451: 335-339.

6. Morata G, Ripoll P. 1975. Minutes: mutants of drosophila autonomously affecting cell division rate. *Dev Biol* 42: 211-221.

7. Lee CH, Kiparaki M, Blanco J, Folgado V, Ji Z, Kumar A, Baker NE. 2018. A regulatory response to ribosomal protein mutations controls translation, growth, and cell competition. *Dev Cell* 46: 456-469.e4.

8. Kang K, Ryoo HD, Park JE, Yoon JH, Kang MJ. 2015. A Drosophila reporter for the translational activation of ATF4 marks stressed cells during development. *PLoS One* 10: e0126795.

9. Kale A, Li W, Lee CH, Baker NE. 2015. Apoptotic mechanisms during competition of ribosomal protein mutant cells: roles of the initiator caspases Dronc and Dream/Strica. *Cell Death Differ* 22: 1300-1312.

10. Ingolia NT, Ghaemmaghami S, Newman JR, Weissman JS. 2009. Genome-wide analysis in vivo of translation with nucleotide resolution using ribosome profiling. *Science* 324: 218-223.
