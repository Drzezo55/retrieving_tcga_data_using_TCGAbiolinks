# Use an R base image with Bioconductor support
FROM rocker/r-ver:4.3.1

# Install system dependencies
RUN apt-get update && apt-get install -y \
    libcurl4-openssl-dev \
    libxml2-dev \
    libssl-dev \
    && apt-get clean

# Install Bioconductor and TCGAbiolinks
RUN R -e "install.packages('BiocManager'); BiocManager::install('TCGAbiolinks')"

# Copy your R script into the container
COPY tcga_download.R /tcga_download.R

# Set working directory
WORKDIR /GDCdata

# Run the script when the container starts
CMD ["Rscript", "/tcga_download.R"]

