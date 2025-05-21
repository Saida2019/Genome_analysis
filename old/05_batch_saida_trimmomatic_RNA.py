#!/bin/bash -l
#SBATCH -A uppmax2025-3-3
#SBATCH -M snowy             # Cluster name
#SBATCH -p core              # Partition
#SBATCH -n 2                 # Number of CPU cores
#SBATCH -t 01:00:00          # Time limit (HH:MM:SS)
#SBATCH -J saida_RNA_trimming      # Job name
#SBATCH --mail-user=saidasharifzade@yahoo.com      
#SBATCH --output=%x.%j.out
##SBATCH --reservation=uppmax2025-3-3_1

# Load modules
module load bioinfo-tools trimmomatic


export INPUT_DIR=/home/saidas/2_Beganovic_2023/RNA_reads/
export OUTPUT_DIR=/home/saidas/GA_results/Trimmed_RNA
mkdir -p $OUTPUT_DIR

# Copy files to temporary directory for processing
cp $INPUT_DIR/*fastq.gz $SNIC_TMP/
cd $SNIC_TMP

# Process each sample
for i in {56..64}
do 
    trimmomatic PE -phred33 \
SRR245164"$i"_1.fastq.gz SRR245164"$i"_2.fastq.gz \
SRR245164"$i"_1_trimmed_RNA.fastq.gz SRR245164"$i"_2_trimmed_RNA.fastq.gz \
SRR245164"${i}"_1_unpaired_trimmed_RNA.fastq.gz SRR245164"${i}"_2_unpaired_trimmed_RNA.fastq.gz \
ILLUMINACLIP:$TRIMMOMATIC_HOME/adapters/TruSeq3-PE.fa:2:30:10 \
LEADING:20 TRAILING:20 MINLEN:36 \
-threads 2                    
done

# Copy the output files back to the results director
cp *_trimmed_RNA.fastq.gz $OUTPUT_DIR/
