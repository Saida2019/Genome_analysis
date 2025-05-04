# Set the library path to a directory where you have write access
lib_path <- "/home/saidas/Rlibs"
if (!dir.exists(lib_path)) {
  dir.create(lib_path)
}

# Specify the library path when loading packages
.libPaths(c(lib_path, .libPaths()))

# Install BiocManager if it isn't already installed
if (!requireNamespace("BiocManager", quietly = TRUE)) {
  install.packages("BiocManager", lib = lib_path)
}

# Install DESeq2 in the specified directory
if (!requireNamespace("DESeq2", quietly = TRUE)) {
  BiocManager::install("DESeq2", lib = lib_path)
}

# Install ggplot2 and pheatmap if they aren't already installed
if (!requireNamespace("ggplot2", quietly = TRUE)) {
  install.packages("ggplot2", lib = lib_path)
}
if (!requireNamespace("pheatmap", quietly = TRUE)) {
  install.packages("pheatmap", lib = lib_path)
}

# Load the required libraries
library(DESeq2, lib.loc = lib_path)
library(ggplot2, lib.loc = lib_path)
library(pheatmap, lib.loc = lib_path)

# Set the working directory to your FeatureCounts folder
setwd("/proj/uppmax2025-3-3/GA_Saida/FeatureCounts")

# List all the FeatureCounts files (adjust if needed)
files <- list.files(pattern = "_counts.txt$")

# Define a function to read and extract counts
read_counts <- function(file) {
  df <- read.table(file, header = TRUE, comment.char = "#")
  df <- df[, c("Geneid", ncol(df))]  # Take gene column + last column (the counts)
  colnames(df)[2] <- gsub("_counts.txt", "", file)  # Clean up column names
  return(df)
}

# Read and merge all the files
count_list <- lapply(files, read_counts)
merged_counts <- Reduce(function(x, y) merge(x, y, by = "Geneid"), count_list)

# Prepare the count matrix
rownames(merged_counts) <- merged_counts$Geneid
count_matrix <- as.matrix(merged_counts[, -1])

# Create metadata (species information)
col_data <- data.frame(
  row.names = colnames(count_matrix),
  species = c("HP126", "HP126", "HP126", "R7", "R7", "R7")  # Adjust based on your samples
)

# DESeq2 analysis
dds <- DESeqDataSetFromMatrix(countData = count_matrix,
                              colData = col_data,
                              design = ~ species)

# Run DESeq2
dds <- DESeq(dds)
res <- results(dds)

# Save the results to a CSV file
write.csv(as.data.frame(res), "/home/saidas/GA_results/DESeq2/deseq2_results_HP126_vs_R7.csv")

# Generate PCA plot
pca <- plotPCA(dds, intgroup = "species")
ggsave("/home/saidas/GA_results/DESeq2/pca_plot.png", pca)

# Generate Heatmap plot
heatmap_data <- rlog(dds)
heatmap_plot <- pheatmap(assay(heatmap_data), cluster_rows = TRUE, cluster_cols = TRUE)
ggsave("/home/saidas/GA_results/DESeq2/heatmap.png", heatmap_plot)

# Generate Volcano plot
volcano_plot <- ggplot(as.data.frame(res), aes(x = log2FoldChange, y = -log10(pvalue))) + 
  geom_point() + 
  theme_minimal()
ggsave("/home/saidas/GA_results/DESeq2/volcano_plot.png", volcano_plot)

