#!/bin/bash -l
#SBATCH -A uppmax2025-3-3
#SBATCH -M snowy
#SBATCH -p core
#SBATCH -n 4
#SBATCH --mem=16G
#SBATCH -t 25:00:00
#SBATCH -J egg_NOG_HP126
#SBATCH --mail-user=saidasharifzade@yahoo.com
#SBATCH --output=%x.%j.out
##SBATCH --reservation=uppmax2025-3-3_2

# Load modules
module load bioinfo-tools
module load eggNOG-mapper/2.1.9

# Set paths
export INPUT_DIR=/home/saidas/GA_results/Pilon_polished_HP126
export OUTPUT_DIR=/home/saidas/GA_results/eggNOG_annotation_HP126
mkdir -p $OUTPUT_DIR


# Copy data to temporary directory
cp $INPUT_DIR/pilon_polished_HP126.fasta $SNIC_TMP/  
cd $SNIC_TMP

# Run eggNOG-mapper

emapper.py \
	-m diamond \
	--itype CDS \
	-i pilon_polished_HP126.fasta \
	-o $SNIC_TMP \
	--cpu 4

# Copy results
cp "$SNIC_TMP"/HP126_eggnog.* "$OUTPUT_DIR/"
