#!/bin/bash -l
#SBATCH -A uppmax2025-3-3
#SBATCH -M snowy
#SBATCH -p core
#SBATCH -n 4
#SBATCH --mem=32G
#SBATCH -t 02:00:00
#SBATCH -J quast_HP126
#SBATCH --mail-user=saidasharifzade@yahoo.com
#SBATCH --output=%x.%j.out

# Load modules
module load bioinfo-tools
module load quast/5.0.2

# Set paths
export INPUT_DIR=/home/saidas/GA_results/Pilon_polished_HP126
export REF_DIR=/home/saidas/2_Beganovic_2023/reference_genome
export OUTPUT_DIR=/home/saidas/GA_results/Assembly_validation_HP126
mkdir -p $OUTPUT_DIR

# Copy files to temporary directory
cp $INPUT_DIR/pilon_polished_HP126.fasta $SNIC_TMP/
cp $REF_DIR/HP126_genome.fasta $SNIC_TMP/
cd $SNIC_TMP

# Run QUAST
quast.py pilon_polished_HP126.fasta \
  -r HP126_genome.fasta \
  -o quast_results_HP126 \
  -t 4 \
  --min-contig 200

# Copy results back
cp -r quast_results_HP126 $OUTPUT_DIR/

