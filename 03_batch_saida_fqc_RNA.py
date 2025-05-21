#!/bin/bash -l
#SBATCH -A uppmax2025-3-3    # Project name
#SBATCH -M snowy             # Cluster name
#SBATCH -p core              # Partition (queue)
#SBATCH --ntasks=16
#SBATCH --cpus-per-task=1
#SBATCH -t 01:00:00          # Time limit (HH:MM:SS)
#SBATCH -J saida_fqc_RNA	  # Job name
#SBATCH --mail-user=saidasharifzade@yahoo.com
#SBATCH --output=%x.%j.out
##SBATCH --reservation=uppmax2025-3-3_1


# Load modules
module load bioinfo-tools FastQC/0.11.9

# Define input directory
export INPUT_DIR=/home/saidas/2_Beganovic_2023/RNA_reads/
export OUTPUT_DIR=/home/saidas/GA_results/FQC_RNA
mkdir -p $OUTPUT_DIR

# Copy files to temporary directory for processing
cp $INPUT_DIR/*fastq.gz $SNIC_TMP/
cd $SNIC_TMP


# Run FastQC on each of the specified files

for i in {56..64}
do
    fastqc -t 2 -o $OUTPUT_DIR SRR245164"$i"_1.fastq.gz SRR245164"$i"_2.fastq.gz
done

# Check that FastQC output files are present
ls $SNIC_TMP/*.zip $SNIC_TMP/*.html

# Copy the output files back to the results director
#cp $SNIC_TMP/*.zip $SNIC_TMP/*.html $OUTPUT_DIR/

