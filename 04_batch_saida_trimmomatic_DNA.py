#!/bin/bash -l
#SBATCH -A uppmax2025-3-3
#SBATCH -M snowy             # Cluster name
#SBATCH -p core              # Partition (queue)
#SBATCH --ntasks=16
#SBATCH --cpus-per-task=1
#SBATCH -t 01:00:00          # Time limit (HH:MM:SS)
#SBATCH -J saida_trimming_DNA      # Job name
#SBATCH --mail-user=saidasharifzade@yahoo.com 
#SBATCH --output=%x.%j.out
##SBATCH --reservation=uppmax2025-3-3_1

# Load modules
module load bioinfo-tools trimmomatic

export INPUT_DIR=/home/saidas/2_Beganovic_2023/DNA_reads/short_reads/
export OUTPUT_DIR=/home/saidas/GA_results/Trimmed_DNA
mkdir -p $OUTPUT_DIR

# Copy files to temporary directory for processing
cp $INPUT_DIR/*fastq.gz $SNIC_TMP/
cd $SNIC_TMP

# Process each sample
for i in 65 71
do 
    trimmomatic PE -phred33 \
SRR244130"$i"_1.fastq.gz SRR244130"$i"_2.fastq.gz \
SRR244130"$i"_1_trimmed.fastq.gz SRR244130"$i"_1_unpaired.trimmed.fastq.gz \
SRR244130"$i"_2_trimmed.fastq.gz SRR244130"$i"_2_unpaired.trimmed.fastq.gz \
ILLUMINACLIP:$TRIMMOMATIC_HOME/adapters/TruSeq3-PE.fa:2:30:10:2:keepBothReads \
LEADING:20 TRAILING:20 MINLEN:100 \
-threads 2                    
done

# Copy the output files back to the results director
cp *.gz $OUTPUT_DIR/
