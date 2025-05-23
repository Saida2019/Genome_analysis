#!/bin/bash -l
#SBATCH -A uppmax2025-3-3
#SBATCH -M snowy
#SBATCH -p core
#SBATCH --ntasks=1               
#SBATCH --cpus-per-task=4       
#SBATCH --mem=16G
#SBATCH -t 02:00:00
#SBATCH -J busco_analysis_H126
#SBATCH --mail-user=your_email@example.com
#SBATCH --output=%x.%j.out

# Load modules
module load bioinfo-tools
module load BUSCO/5.7.1
module load prodigal/2.6.3

# Set paths
export ASSEMBLY_DIR=/home/saidas/GA_results/Pilon_polished_HP126
export OUTPUT_DIR=/home/saidas/GA_results/BUSCO_HP126
mkdir -p $OUTPUT_DIR

# Copy data to temporary directory
cp $ASSEMBLY_DIR/pilon_polished_HP126.fasta $SNIC_TMP/

# Check if the file was successfully copied
echo "Checking file in SNIC_TMP:"
ls -l $SNIC_TMP/pilon_polished_HP126.fasta

# Move to the working directory
cd $SNIC_TMP

# Run BUSCO analysis with correct flags
echo "Running BUSCO analysis..."
busco -i pilon_polished_HP126.fasta -o HP126_BUSCO -l $BUSCO_LINEAGE_SETS/bacteria_odb10 -m geno -c 4

# Check if BUSCO folder was created
echo "Checking if BUSCO folder exists in SNIC_TMP:"
ls -l $SNIC_TMP/HP126_BUSCO

# Copy results back to the output directory
echo "Copying results to the output directory..."
cp -r $SNIC_TMP/HP126_BUSCO $OUTPUT_DIR/

# Check if the copy was successful
echo "Checking output directory for results:"
ls -l $OUTPUT_DIR
