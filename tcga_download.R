# Install TCGAbiolinks
BiocManager::install("TCGAbiolinks")
library(TCGAbiolinks)
project_name <- "TCGA-LAML"
query <- GDCquery(project = project_name,
                  data.category = "Transcriptome Profiling",
                  data.type = "Gene Expression Quantification",
                  experimental.strategy = "RNA-Seq",
                  workflow.type = "STAR - Counts")

metadata <- query[[1]][[1]]
GDCdownload(query, method = "api")
# Get main directory where data is stored
main_dir <- file.path("GDCdata", project_name)
# Get file list of downloaded files
file_list <- file.path("GDCdata", project_name,list.files(main_dir,recursive = TRUE))  
test_tab <- read.table(file = file_list[1], sep = '\t', header = TRUE)
# Delete header lines that don't contain usefull information
test_tab <- test_tab[-c(1:4),]
# STAR counts and tpm datasets
tpm_data_frame <- data.frame(test_tab[,1])
count_data_frame <- data.frame(test_tab[,1])

# Append cycle to get the complete matrix
for (i in c(1:length(file_list))) {
  # Read table
  test_tab <- read.table(file = file_list[i], sep = '\t', header = TRUE)
  # Delete not useful lines
  test_tab <- test_tab[-c(1:4),]
  # Column bind of tpm and counts data
  tpm_data_frame <- cbind(tpm_data_frame, test_tab[,7]) # 7 refers to the location where tpm present
  count_data_frame <- cbind(count_data_frame, test_tab[,4]) # 4 refers to the location where count present 
  # Print progres from 0 to 1
  print(i/length(file_list))
}


