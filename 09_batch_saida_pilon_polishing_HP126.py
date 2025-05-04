#!/bin/bash -l
#SBATCH -A uppmax2025-3-3
#SBATCH -M snowy
#SBATCH -p core
#SBATCH --ntasks=1                 # 1 task
#SBATCH --cpus-per-task=4          # Use 4 cores for 1 task
#SBATCH --mem=16G
#SBATCH -t 02:00:00
#SBATCH -J pilon_polishing_HP126
#SBATCH --mail-user=saidasharifzade@yahoo.com
#SBATCH --output=%x.%j.out
##SBATCH --reservation=uppmax2025-3-3_2

# Load modules
module load bioinfo-tools
module load bwa
module load samtools/1.20
module load Pilon/1.24

# Set paths
export ASSEMBLY_DIR=/home/saidas/GA_results/Flye_assembly_HP126
export READS_DIR=/home/saidas/GA_results/Trimmed_DNA
export OUTPUT_DIR=/home/saidas/GA_results/Pilon_polished_HP126
mkdir -p $OUTPUT_DIR

# Copy data to temporary directory
cp $ASSEMBLY_DIR/assembly_HP126.fasta $SNIC_TMP/   
cp $READS_DIR/SRR24413065* $SNIC_TMP/
cd $SNIC_TMP

# Index the genome
bwa index assembly_HP126.fasta

# Map paired-end reads
bwa mem -v 3 -t 2 assembly_HP126.fasta \
  SRR24413065_1_trimmed.fastq.gz SRR24413065_2_trimmed.fastq.gz > aligned_HP126_paired.sam

# Map unpaired reads separately
bwa mem -v 3 -t 4 assembly_HP126.fasta SRR24413065_1_unpaired.trimmed.fastq.gz > aligned_HP126_unp1.sam
bwa mem -v 3 -t 4 assembly_HP126.fasta SRR24413065_2_unpaired.trimmed.fastq.gz > aligned_HP126_unp2.sam

# Convert SAMs to BAMs
samtools view -b aligned_HP126_paired.sam > paired_HP126.bam
samtools view -b aligned_HP126_unp1.sam > unp1_HP126.bam
samtools view -b aligned_HP126_unp2.sam > unp2_HP126.bam

# Merge unpaired BAMs
samtools merge -@ 2 unpaired_HP126.bam unp1_HP126.bam unp2_HP126.bam

# Sort and index
samtools sort -@ 2 -o paired_HP126.sorted.bam paired_HP126.bam
samtools index paired_HP126.sorted.bam

samtools sort -@ 2 -o unpaired_HP126.sorted.bam unpaired_HP126.bam
samtools index unpaired_HP126.sorted.bam

# Run Pilon
java -Xmx16G -jar $PILON_HOME/pilon.jar \
  --genome assembly_HP126.fasta \
  --frags paired_HP126.sorted.bam \
  --unpaired unpaired_HP126.sorted.bam \
  --output pilon_polished_HP126 \
  --threads 4 \
  --changes \
  --vcf

# Copy results
cp pilon_polished_HP126* $OUTPUT_DIR/
cp paired_HP126.sorted.bam paired_HP126.sorted.bam.bai unpaired_HP126.sorted.bam unpaired_HP126.sorted.bam.bai \
/proj/uppmax2025-3-3/GA_Saida/BAM_126
