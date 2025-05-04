
#!/bin/bash -l
#SBATCH -A uppmax2025-3-3
#SBATCH -M snowy             # Cluster name
#SBATCH -p core              # Partition (queue)
#SBATCH -n 2                 # Number of CPU cores
#SBATCH -t 01:00:00          # Time limit (HH:MM:SS)
#SBATCH -J project_saida_fqc      # Job name
#SBATCH --mail-user=saidasharifzade@yahoo.com      # email notification
#SBATCH --output=%x.%j.out

# Load modules

module load bioinfo-tools FastQC/0.11.9

export INPUT_DIR=/home/saidas/2_Beganovic_2023/DNA_reads/

cp $INPUT_DIR/*fastq.gz $SNIC_TMP/
cd $SNIC_TMP

export OUTPUT_DIR=/home/saidas/GA_results

# List of files to process
FASTQ_FILES=("SRR24413066.fastq.gz" "SRR24413072.fastq.gz" "SRR24413081.fastq.gz")

# Loop over each file and run Porechop
for fastq_file in "${FASTQ_FILES[@]}"; do
    echo "Processing $fastq_file"

    porechop \
        --input $INPUT_DIR/$fastq_file \
        --output $OUTPUT_DIR/$(basename $fastq_file .fastq.gz)_processed.fastq.gz \
        --adapter "AGATCGGAAGAGCACACGTCTGAACTCCAGTCAC" \                              # Specify adapter sequence (if needed)
        --discard_untrimmed \                                                         # Optionally discard untrimmed reads
        --threads 2                                                                   # Number of threads (adjust as needed)

    echo "Finished processing $fastq_file"
done

# Optional: Move the output files to a result directory
# cp $OUTPUT_DIR/*.fastq.gz /home/saidas/GA_results/

