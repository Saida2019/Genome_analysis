#!/bin/bash -l
#SBATCH -A uppmax2025-3-3
#SBATCH -M snowy
#SBATCH -p core
#SBATCH -n 16
##SBATCH --cpus-per-task=16
#SBATCH --mem=64G
#SBATCH -t 30:00:00
#SBATCH -J egg_NOG_R7_improve_assembly
#SBATCH --mail-user=saidasharifzade@yahoo.com
#SBATCH --output=%x.%j.out
##SBATCH --reservation=uppmax2025-3-3_2

# Load modules
module load bioinfo-tools
module load eggNOG-mapper/2.1.9

# Set paths
export INPUT_DIR=/home/saidas/GA_results/Prokka_annotation_R7
export OUTPUT_DIR=/proj/uppmax2025-3-3/GA_Saida/eggNOG_annotation_R7_improved_Prokka
mkdir -p $OUTPUT_DIR

# Ensure output directory exists for eggNOG-mapper
mkdir -p $SNIC_TMP/R7_eggnog_results

# Copy data to temporary directory
cp $INPUT_DIR/R7_annotation.faa $SNIC_TMP/  
cp $INPUT_DIR/R7_annotation_clean.gff $SNIC_TMP/
cd $SNIC_TMP

# Run eggNOG-mapper
emapper.py \
  -i R7_annotation.faa \
  --itype proteins \
  -m diamond \
  --cpu 16 \
  -o R7_eggnog_results \
  --output_dir $SNIC_TMP \
  --decorate_gff R7_annotation_clean.gff \
  --decorate_gff_ID_field GeneID \
  --excel

# Copy results

cp $SNIC_TMP/R7_eggnog_results.* $OUTPUT_DIR/
