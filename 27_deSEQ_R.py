# Load necessary libraries
library(DESeq2)
library(tibble)
library(ggplot2)
library(pheatmap)
if (!requireNamespace("BiocManager", quietly = TRUE))
  install.packages("BiocManager")

BiocManager::install("EnhancedVolcano")
library(EnhancedVolcano)

# Set working directory
setwd("/Users/saidasharifova/Documents/Classes_Spring_Semester_2025/Genome_analysis/Labs/project/FeatureCounts")

# Count files

files <- c(
  "SRR24516459_HP126_counts.txt",
  "SRR24516460_HP126_counts.txt",
  "SRR24516461_HP126_counts.txt",
  "SRR24516462_R7_counts.txt",
  "SRR24516463_R7_counts.txt",
  "SRR24516464_R7_counts.txt"
)

# Sample names

sample_names <- gsub("_counts.txt", "", files)

# Read count files and create count matrix 

counts_list <- lapply(files, function(file) {
  data <- read.table(file, header = TRUE, skip = 1, row.names = 1)
  return(data[, ncol(data), drop = FALSE])  # Extract the last column (count data)
})

# Combine count data into a matrix

count_matrix <- do.call(cbind, counts_list)
colnames(count_matrix) <- sample_names

# Create sample info (metadata)

sample_info <- data.frame(
  row.names = sample_names,
  condition = c(rep("HP126", 3), rep("R7", 3))
)

# Define sample groups

hp126_samples <- c("SRR24516459_HP126", "SRR24516460_HP126", "SRR24516461_HP126")
r7_samples <- c("SRR24516462_R7", "SRR24516463_R7", "SRR24516464_R7")


#FILTERING DATA

# Filter count matrix to keep genes that are present in R7 but missing in HP126
#This condition identifies genes that have non-zero counts in at least one of the HP126 samples.

count_matrix_filtered <- count_matrix[
  rowSums(count_matrix[, hp126_samples] > 0) > 0, 
]

# Convert count matrix to matrix

count_matrix_filtered <- as.matrix(count_matrix_filtered)

# Filtered sample info (metadata)

sample_info_filtered <- data.frame(condition = sample_info$condition)
rownames(sample_info_filtered) <- colnames(count_matrix_filtered)

# DESeq2 dataset with the filtered count data

dds_filtered <- DESeqDataSetFromMatrix(countData = count_matrix_filtered, colData = sample_info_filtered, design = ~condition)

# DESeq2 differential expression analysis

dds_filtered <- DESeq(dds_filtered)


#NORMALIZED COUNT

# Check normalized counts
normalized_counts <- counts(dds_filtered, normalized = TRUE)

# Variance stabilizing transformation (VST) for PCA plot
vsd <- vst(dds_filtered, blind = FALSE)

#PRINCIPAL COMPONENT ANALYSIS

# PCA Plot
pca_plot <- plotPCA(vsd, intgroup = "condition") + ggtitle("PCA: HP126 vs R7") + 
  theme(aspect.ratio = 1/1.5)  # Adjust aspect ratio as needed
print(pca_plot)


#HEATMAP

# Heatmap of top 50 most variable genes
top_genes <- head(order(rowVars(assay(vsd)), decreasing = TRUE), 50)

pheatmap(assay(vsd)[top_genes, ], annotation_col = sample_info_filtered, show_rownames = FALSE, main = "Top 50 Variable Genes")

# Differential expression analysis (HP126 vs R7)
res <- results(dds_filtered, contrast = c("condition", "HP126", "R7"))

# Apply shrinkage using apeglm
res_shrink <- lfcShrink(dds_filtered, coef = "condition_R7_vs_HP126", type = "apeglm")

# Convert results to a data frame
res_df <- as.data.frame(res_shrink)


################
# We can sort by adjusted p-value (padj) if we want
sorted_res_df <- res_df[order(res_df$padj), ]
################

#VOLCANO PLOT

# Volcano plot
res_df$significant <- ifelse(res_df$pvalue < 0.05 & abs(res_df$log2FoldChange) > 1, "significant", "not_significant")

############

# To check the number of significant and non_significant genes we can do:
res_df_new <- res_df
res_df_new$significant <- ifelse(res_df_new$pvalue < 0.05 & abs(res_df_new$log2FoldChange) > 1, 
                                 "significant", "not_significant")
table(res_df_new$significant)

############

# Plot Volcano Plot
EnhancedVolcano(res_df,
                lab = rownames(res_df),
                x = "log2FoldChange",
                y = "pvalue",
                pCutoff = 0.05,
                FCcutoff = 1.0,
                title = "Volcano Plot: R7 vs HP126",
                subtitle = "Differential Expression",
                caption = "Log2 FC vs P-value",
                labSize = 3,
                col = c("red", "blue")[as.factor(res_df$significant)])


# Save DESeq2 results to CSV

write.csv(res_df, "DESeq2_R7_vs_HP126_results.csv")

# Filter upregulated genes (log2FC > 0 and significant)

upregulated_genes <- res_df[res_df$log2FoldChange > 1 & res_df$significant == "significant", ]
nrow(upregulated_genes)

# Add gene names from rownames (if needed)

upregulated_genes$gene <- rownames(upregulated_genes)

# Save full results with gene names

write.csv(upregulated_genes, "upregulated_genes_HP126.csv", row.names = FALSE)
write.csv(upregulated_genes$gene, "upregulated_gene_names_only.csv", row.names = FALSE)



# Save the DESeq2 analysis results for further use
save.image("DESeq_filtered_Final.RData")

