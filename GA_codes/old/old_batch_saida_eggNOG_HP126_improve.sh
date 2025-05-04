#!/bin/bash -l
#SBATCH -A uppmax2025-3-3
#SBATCH -M snowy
#SBATCH -p core
#SBATCH -n 2
#SBATCH --mem=16G
#SBATCH -t 20:00:00
#SBATCH -J egg_NOG_HP126_improve_assembly
#SBATCH --mail-user=saidasharifzade@yahoo.com
#SBATCH --output=%x.%j.out
##SBATCH --reservation=uppmax2025-3-3_2

# Load modules
module load bioinfo-tools
module load eggNOG-mapper/2.1.9

# Set paths
export INPUT_DIR=/home/saidas/GA_results/Prokka_annotation_R7
export OUTPUT_DIR=/home/saidas/GA_results/eggNOG_annotation_HP126_improved_Prokka
mkdir -p $OUTPUT_DIR


# Copy data to temporary directory
cp $INPUT_DIR/HP126_annotation.faa $SNIC_TMP/  
cd $SNIC_TMP

# Run eggNOG-mapper

emapper.py \
	-m diamond \
	--itype CDS \
	-i R7_annotation.faa \
	-o $SNIC_TMP \
	--cpu 2

#Edit this part

emapper.py \
-m mmseqs 
--itype CDS 
--translate 
-i FASTA_FILE_CDS 
-o test \
--decorate_gff MY_GFF_FILE 
--decorate_gff_ID_field GeneID

# Copy results
cp "$SNIC_TMP"/HP126_eggnog.* "$OUTPUT_DIR/"
