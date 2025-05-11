#!/bin/bash -l
#SBATCH -A uppmax2025-3-3
#SBATCH -M snowy
#SBATCH -p core
#SBATCH -n 4
#SBATCH --mem=32G
#SBATCH -t 02:00:00
#SBATCH -J blast_HP126_vs_R7
#SBATCH --mail-user=saidasharifzade@yahoo.com
#SBATCH --mail-type=END,FAIL
#SBATCH --output=%x.%j.out

# Load modules
module load bioinfo-tools
module load blast

# Define paths
HP126_GENOME="/home/saidas/GA_results/Pilon_polished_HP126/pilon_polished_HP126.fasta"
R7_GENOME="/home/saidas/GA_results/Pilon_polished_R7/pilon_polished_R7.fasta"
OUTPUT_DIR="/home/saidas/GA_results/BLAST_HP126_vs_R7"
mkdir -p $OUTPUT_DIR

# Copy to temporary directory
cp $HP126_GENOME $R7_GENOME $SNIC_TMP/
cd $SNIC_TMP

# Create BLAST database from R7 (wild-type)
makeblastdb -in pilon_polished_R7.fasta -dbtype nucl -out R7_db

# Run BLASTN: HP126 (mutant) as query vs R7 (wild-type) as database
blastn -query pilon_polished_HP126.fasta \
       -db R7_db \
       -outfmt 6 \
       -num_threads 4 \
       -evalue 1e-10 \
       -out HP126_vs_R7_blastn.tsv

# Copy results back
cp HP126_vs_R7_blastn.tsv $OUTPUT_DIR/

