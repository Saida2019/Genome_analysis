#!/bin/bash -l
#SBATCH -A uppmax2025-3-3
#SBATCH -M snowy
#SBATCH -p core
#SBATCH -n 1
#SBATCH --mem=16G
#SBATCH -t 20:00:00
#SBATCH -J BWA_R7
#SBATCH --mail-user=saidasharifzade@yahoo.com
#SBATCH --output=%x.%j.out
##SBATCH --reservation=uppmax2025-3-3_2

set -x  # debug mode 

# Load modules
module load bioinfo-tools
module load bwa/0.7.18
module load samtools

# Set paths
export INPUT_DIR=/home/saidas/2_Beganovic_2023/RNA_reads 
export REF_DIR=/home/saidas/GA_results/Pilon_polished_R7
export OUTPUT_DIR=/proj/uppmax2025-3-3/GA_Saida/BWA_R7_Saida
mkdir -p $OUTPUT_DIR

# Check input files
echo "Files in input directory:"
ls $INPUT_DIR/

# Copy data to temporary directory
cp $INPUT_DIR/SRR24516462*.fastq.gz $INPUT_DIR/SRR24516463*.fastq.gz \
$INPUT_DIR/SRR24516464*.fastq.gz $SNIC_TMP/

cp $REF_DIR/pilon_polished_R7.fasta $SNIC_TMP/
cd $SNIC_TMP

# Index genome if not already indexed
if [ ! -e pilon_polished_R7.fasta.bwt ]; then
  bwa index pilon_polished_R7.fasta
else
  echo "Index already exists, skipping."
fi

# Align reads for each sample
for SAMPLE in SRR24516462 SRR24516463 SRR24516464
do
  # Aligning paired reads
  if [ -f ${SAMPLE}_1.fastq.gz ] && [ -f ${SAMPLE}_2.fastq.gz ]; then
    bwa mem pilon_polished_R7.fasta ${SAMPLE}_1.fastq.gz ${SAMPLE}_2.fastq.gz > ${SAMPLE}.sam
  else
    echo "Reads for ${SAMPLE} not found."
  fi


  # Converting SAM to BAM for each
  if [ -f ${SAMPLE}.sam ]; then
    samtools view -Sb ${SAMPLE}.sam > ${SAMPLE}.bam
  fi

  samtools sort ${SAMPLE}.bam -o ${SAMPLE}_R7.sorted.bam
  samtools index ${SAMPLE}_R7.sorted.bam

  # Copy SAM files to output directory
  cp ${SAMPLE}.sam $OUTPUT_DIR/
  
done

# Copy final BAMs to output directory
for SAMPLE in SRR24516462 SRR24516463 SRR24516464
do
  if [ -f ${SAMPLE}_R7.sorted.bam ]; then
    cp ${SAMPLE}_R7.sorted.bam $OUTPUT_DIR/
  else
    echo "BAM for ${SAMPLE} not found."
  fi
done

