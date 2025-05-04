#!/bin/bash -l
#SBATCH -A uppmax2025-3-3
#SBATCH -M snowy             # Cluster name
#SBATCH -p core              # Partition (queue)
#SBATCH --ntasks=1                 # 1 task
#SBATCH --cpus-per-task=4          # Use 4 cores for 1 task
#SBATCH --mem=16G
#SBATCH -t 06:00:00          # Time limit (HH:MM:SS)
#SBATCH -J saida_flye_assembly_HP126      # Job name
#SBATCH --mail-user=saidasharifzade@yahoo.com      # Job email notification
#SBATCH --output=%x.%j.out
##SBATCH --reservation=uppmax2025-3-3_1

# Load modules
module load bioinfo-tools Flye/2.9.5


export INPUT_DIR=/home/saidas/2_Beganovic_2023/DNA_reads
export OUTPUT_DIR=/home/saidas/GA_results/Flye_assembly_HP126
mkdir -p $OUTPUT_DIR

# Copy files to temporary directory for processing
cp $INPUT_DIR/SRR24413066.fastq.gz $SNIC_TMP/
cd $SNIC_TMP

# Process each sample

flye -t 4 --nano-raw SRR24413066.fastq.gz --min-overlap 2000 --out-dir $OUTPUT_DIR

# Copy the output files back to the results director
cp -r $SNIC_TMP/* $OUTPUT_DIR/
