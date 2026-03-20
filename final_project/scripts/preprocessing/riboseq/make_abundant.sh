#!/bin/bash
#SBATCH -A NEBAKER_LAB
#SBATCH --job-name=makeabundant_riboseq
#SBATCH --output=makeabundant_%j.out
#SBATCH --error=makeabundant_%j.err
#SBATCH --cpus-per-task=8
#SBATCH -p standard 


ABUNDANT_DIR="/pub/chelsebn/BakerLab/Riboseq_data/references/abundant"
mkdir -p "$ABUNDANT_DIR"
cd "$ABUNDANT_DIR"

echo "Downloading Ensembl ncRNA FASTA..."
wget -O Drosophila_melanogaster.BDGP6.32.ncrna.fa.gz \
  http://ftp.ensembl.org/pub/release-110/fasta/drosophila_melanogaster/ncrna/Drosophila_melanogaster.BDGP6.32.ncrna.fa.gz

gunzip -f Drosophila_melanogaster.BDGP6.32.ncrna.fa.gz

echo "Filtering full-length abundant sequences..."
awk '/^>/{keep=($0~/(rRNA|tRNA|snRNA|snoRNA|srpRNA|mt:)/)} keep' \
  Drosophila_melanogaster.BDGP6.32.ncrna.fa \
  > abundant.fa

echo "Building Bowtie2 index..."
bowtie2-build abundant.fa abundant_index

echo "Total sequences: $(grep -c '^>' abundant.fa)"
ls -lh abundant.fa abundant_index*
