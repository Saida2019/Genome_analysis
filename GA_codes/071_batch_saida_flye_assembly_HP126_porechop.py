#!/bin/bash -l
#SBATCH -A uppmax2025-3-3
#SBATCH -M snowy             # Cluster name
#SBATCH -p core              # Partition (queue)
#SBATCH -n 4                 # Number of CPU cores
#SBATCH --mem=16G
#SBATCH -t 06:00:00          # Time limit (HH:MM:SS)
#SBATCH -J saida_flye_assembly_HP126_porechop      # Job name
#SBATCH --mail-user=saidasharifzade@yahoo.com      # Job email notification
#SBATCH --output=%x.%j.out
##SBATCH --reservation=uppmax2025-3-3_1

# Load modules
module load bioinfo-tools Flye/2.9.5


export INPUT_DIR=/home/saidas/GA_results/Porechop2/trimmed_demultiplexed_reads_66
export OUTPUT_DIR=/home/saidas/GA_results/Flye_assembly_HP126_Porechop
mkdir -p $OUTPUT_DIR

# Copy files to temporary directory for processing
cp $INPUT_DIR/*.fastq.gz $SNIC_TMP/
cd $SNIC_TMP

# Process each sample

flye -t 4 --nano-corr *.fastq.gz --out-dir $OUTPUT_DIR

# Copy the output files back to the results director
#cp -r $SNIC_TMP/* $OUTPUT_DIR/
