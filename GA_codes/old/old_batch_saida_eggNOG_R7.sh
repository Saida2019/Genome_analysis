#!/bin/bash -l
#SBATCH -A uppmax2025-3-3
#SBATCH -M snowy
#SBATCH -p core
#SBATCH -n 2
#SBATCH --mem=16G
#SBATCH -t 20:00:00
#SBATCH -J egg_NOG_R7
#SBATCH --mail-user=saidasharifzade@yahoo.com
#SBATCH --output=%x.%j.out
##SBATCH --reservation=uppmax2025-3-3_2

# Load modules
module load bioinfo-tools
module load eggNOG-mapper/2.1.9
module load eggNOG_data/5.0.0

# Set paths
export INPUT_DIR=/home/saidas/GA_results/Prokka_annotation_R7
export OUTPUT_DIR=/home/saidas/GA_results/eggNOG_annotation_R7
mkdir -p $OUTPUT_DIR


# Copy data to temporary directory
cp $INPUT_DIR/R7_annotation.faa $SNIC_TMP/  
cd $SNIC_TMP

# Run eggNOG-mapper
eggnog-mapper -i R7_annotation.faa -o $SNIC_TMP/eggNOG_results_R7 --cpu 2 \
--project S.rimosus 

# Copy results
cp $SNIC_TMP/eggNOG_results_R7/* $OUTPUT_DIR/
