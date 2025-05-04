#!/bin/bash -l
#SBATCH -A uppmax2025-3-3    # Project name
#SBATCH -M snowy             # Cluster name
#SBATCH -p core              # Partition (queue)
#SBATCH --ntasks=16
#SBATCH --cpus-per-task=1
#SBATCH -t 01:00:00          # Time limit (HH:MM:SS)
#SBATCH -J saida_fqcl	  # Job name
#SBATCH --mail-user=saidasharifzade@yahoo.com	   # email notification
#SBATCH --output=%x.%j.out
#SBATCH --reservation=uppmax2025-3-3_1


# Load modules
module load bioinfo-tools FastQC/0.11.9

# Define input directory
export INPUT_DIR=/home/saidas/2_Beganovic_2023/DNA_reads/


# Copy files to temporary directory for processing
cp $INPUT_DIR/*fastq.gz $SNIC_TMP/
cd $SNIC_TMP

export OUTPUT_DIR=/home/saidas/GA_results/FQC_long

# Set Java options to increase heap space
export FASTQC_JAVA_OPTIONS="-Xmx4G"  # Set Java heap size to 4GB

# Run FastQC on each of the specified files

for i in {66,72};
do
    fastqc -t 2 -o $OUTPUT_DIR SRR244130"$i".fastq.gz
done


# Copy the output files back to the results director
cp *fastq* $OUTPUT_DIR/

