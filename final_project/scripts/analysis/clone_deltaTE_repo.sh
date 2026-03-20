#!/bin/bash

set -euo pipefail

REPO_URL="https://github.com/SGDDNB/translational_regulation"
REPO_DIR="deltaTE"
ENV_NAME="deltaTE_env"
R_VERSION="4.2"

echo ">>> Cloning deltaTE repository..."
if [ -d "$REPO_DIR" ]; then
    echo "    Directory '$REPO_DIR' already exists — skipping clone."
else
    git clone "$REPO_URL" "$REPO_DIR"
    echo "    Cloned to: $(realpath $REPO_DIR)"
fi

# Create conda environment
echo ">>> Creating conda environment: $ENV_NAME ..."
conda create -y -n "$ENV_NAME" \
    -c conda-forge \
    -c bioconda \
    r-base="$R_VERSION" \
    bioconductor-deseq2 \
    bioconductor-apeglm \
    r-ggplot2 \
    r-dplyr \
    r-readr \
    r-optparse