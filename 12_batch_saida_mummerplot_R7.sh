#!/bin/bash -l
#SBATCH -A uppmax2025-3-3
#SBATCH -M snowy
#SBATCH -p core
#SBATCH -n 2
#SBATCH --mem=16G
#SBATCH -t 02:00:00
#SBATCH -J assembly_validation_R7
#SBATCH --mail-user=saidasharifzade@yahoo.com
#SBATCH --output=%x.%j.out
##SBATCH --reservation=uppmax2025-3-3_2

# Load modules
module load bioinfo-tools
module load MUMmer/4.0.0beta2

# Set paths
export INPUT_DIR=/home/saidas/GA_results/Pilon_polished_R7
export REF_DIR=/home/saidas/2_Beganovic_2023/reference_genome
export OUTPUT_DIR=/home/saidas/GA_results/Assembly_validation_R7
mkdir -p $OUTPUT_DIR

# Copy data to temporary directory
cp $INPUT_DIR/pilon_polished_R7.fasta $SNIC_TMP/  
cp $REF_DIR/R7_genome.fasta $SNIC_TMP/
cd $SNIC_TMP

# Align assembly to reference

nucmer --prefix=asmR7_vs_ref R7_genome.fasta pilon_polished_R7.fasta

# Filter alignments (optional, but helpful)
delta-filter -1 -i 90 -l 1000 asmR7_vs_ref.delta > asmR7_vs_ref.filtered.delta

# Generate MUMmerplot
mummerplot --prefix=asmR7_vs_ref --png --layout --filter asmR7_vs_ref.filtered.delta

# Copy results
cp asmR7_vs_ref* $OUTPUT_DIR/
