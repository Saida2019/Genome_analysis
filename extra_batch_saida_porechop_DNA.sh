#!/bin/bash -l
#SBATCH -A uppmax2025-3-3
#SBATCH -M snowy             # Cluster name
#SBATCH -p core              # Partition (queue)
#SBATCH -n 2                 # Number of CPU cores
#SBATCH --mem=16G 
#SBATCH -t 15:00:00          # Time limit (HH:MM:SS)
#SBATCH -J saida_porechop2      # Job name
#SBATCH --mail-user=saidasharifzade@yahoo.com      # Job email notification
#SBATCH --output=%x.%j.out
##SBATCH --reservation=uppmax2025-3-3_1

# Load modules
module load bioinfo-tools
module load Porechop 

export INPUT_DIR=/home/saidas/2_Beganovic_2023/DNA_reads
export OUTPUT_DIR=/home/saidas/GA_results/Porechop2
mkdir -p $OUTPUT_DIR

# Copy files to temporary directory for processing
cp $INPUT_DIR/SRR24413066.fastq.gz $INPUT_DIR/SRR24413072.fastq.gz $SNIC_TMP/
cd $SNIC_TMP

# Process each sample
for i in 66 72
do 
  porechop -i $SNIC_TMP/SRR244130$i.fastq.gz \
           -b $SNIC_TMP/_trimmed_demultiplexed_reads_$i \
           --discard_middle \
           --threads 2       
done

# Copy the output files back to the results director
cp -r $SNIC_TMP/_trimmed_demultiplexed_reads_* $OUTPUT_DIR/
