#!/bin/bash -l
#SBATCH -A uppmax2025-3-3
#SBATCH -M snowy
#SBATCH -p core
#SBATCH -n 1
#SBATCH --mem=1G
#SBATCH -t 00:15:00
#SBATCH -J FixFASTA
#SBATCH --mail-user=saidasharifzade@yahoo.com
#SBATCH --output=%x.%j.out

set -e
set -x

# Load modules
module load bioinfo-tools

# Set paths
export REF_DIR=/home/saidas/GA_results/Pilon_polished_R7
export OUTPUT_DIR=/home/saidas/GA_results/Fasta_fixed
mkdir -p $OUTPUT_DIR

# Work in temp dir
cp $REF_DIR/pilon_polished_R7.fasta $SNIC_TMP/
cd $SNIC_TMP

# Fix contig names
sed -e 's/^>contig_2_pilon/>gnl|Prokka|GDBGCFLD_1/' \
    -e 's/^>contig_3_pilon/>gnl|Prokka|GDBGCFLD_2/' \
    pilon_polished_R7.fasta > fixed_reference.fasta

# Copy fixed file back
cp fixed_reference.fasta $OUTPUT_DIR/

