#!/bin/bash -l
#SBATCH -A uppmax2025-3-3
#SBATCH -M snowy
#SBATCH -p core
#SBATCH -n 2
#SBATCH -t 02:00:00
#SBATCH -J pilon_polishing_R7
#SBATCH --mail-user=saidasharifzade@yahoo.com
#SBATCH --output=%x.%j.out

# Load modules
module load bioinfo-tools
module load bwa
module load samtools
module load Pilon/1.24

# Set paths
export ASSEMBLY_DIR=/home/saidas/GA_results/Flye_assembly_R7
export READS_DIR=/home/saidas/GA_results/Trimmed_DNA
export OUTPUT_DIR=/home/saidas/GA_results/Pilon_polished_R7
mkdir -p $OUTPUT_DIR

# Copy data to temporary directory
cp $ASSEMBLY_DIR/assembly_R7.fasta $SNIC_TMP/   # edit name
cp $READS_DIR/SRR24413071_1_trimmed.fastq.gz $READS_DIR/SRR24413071_2_trimmed.fastq.gz $SNIC_TMP/
cd $SNIC_TMP

# Index the genome
bwa index assembly_R7.fasta  #edit name

# Map reads to assembly
bwa mem -t 2 assembly_R7.fasta SRR24413071_1_trimmed.fastq.gz SRR24413071_2_trimmed.fastq.gz | samtools sort -@ 2 -o aligned_R7.bam
samtools index aligned_R7.bam

# Run Pilon
java -Xmx16G -jar $PILON_HOME/pilon.jar \
  --genome assembly_R7.fasta \
  --frags aligned_R7.bam \
  --output pilon_polished_R7 \
  --threads 2 \
  --changes \
  --vcf

# Copy results
cp pilon_polished_R7* $OUTPUT_DIR/

