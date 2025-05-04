#!/bin/bash -l
#SBATCH -A uppmax2025-3-3
#SBATCH -M snowy
#SBATCH -p core
#SBATCH -n 2
#SBATCH --mem=16G
#SBATCH -t 02:00:00
#SBATCH -J prokka_R7
#SBATCH --mail-user=saidasharifzade@yahoo.com
#SBATCH --output=%x.%j.out
##SBATCH --reservation=uppmax2025-3-3_2

# Load modules
module load bioinfo-tools
module load prokka/1.14.6

# Set paths
export INPUT_DIR=/home/saidas/GA_results/Pilon_polished_R7
export OUTPUT_DIR=/home/saidas/GA_results/Prokka_annotation_R7
mkdir -p $OUTPUT_DIR

# Copy data to temporary directory
cp $INPUT_DIR/pilon_polished_R7.fasta $SNIC_TMP/  
cd $SNIC_TMP

# Run Prokka annotation
prokka --outdir $SNIC_TMP/prokka_output \
       --prefix R7_annotation \
       --genus "Streptomyces" \
       --species "S.rimosus" \
       --kingdom "Bacteria" \
       --cpus 2 \
       --force \
       --compliant \
       pilon_polished_R7.fasta 

# Copy results
cp $SNIC_TMP/prokka_output/* $OUTPUT_DIR/
