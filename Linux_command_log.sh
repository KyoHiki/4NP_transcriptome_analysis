# Requirements
## Install several softwares through conda
conda install bioconda::seqkit
conda create -n hista2 bioconda::hisat2
  
  
# Download the reference genome
  
  
# Check quality of fastq files
seqkit stats F1_*.fastq.gz -T | csvtk pretty -t
