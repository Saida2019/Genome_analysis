#!/bin/bash -l
#SBATCH -A uppmax2025-3-3         # Project name
#SBATCH -M snowy                   # Cluster name
#SBATCH -p core                    # Queue (core)
#SBATCH -n 8                       # Number of CPU cores
#SBATCH --mem=16G                  # Memory allocation
#SBATCH -t 20:00:00                # Time limit (hh:mm:ss)
#SBATCH -J deSeq2                  # Job name
#SBATCH --mail-user=your_email@domain.com  # Email for notifications
#SBATCH --output=%x.%j.out        # Standard output
#SBATCH --error=%x.%j.err         # Standard error output

# Debugging: Exit immediately if a command exits with a non-zero status
set -e
set -x

# Load necessary module
module load R/4.2.1

# Set the working directory to your FeatureCounts folder
cd /proj/uppmax2025-3-3/GA_Saida/FeatureCounts

# Run the R script for DESeq2 analysis
Rscript /home/saidas/Genome_analysis/GA_codes/deseq2_analysis.R

