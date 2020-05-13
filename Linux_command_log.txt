# Requirements
## Install several softwares through conda
conda install bioconda::seqkit
conda install bioconda::csvtk
conda create -n hisat2 bioconda::hisat2
conda create -n htseq bioconda::htseq

  
# Download the reference genome
## Hd-rR strain (assembly ASM223467v1)
wget https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/002/234/675/GCF_002234675.1_ASM223467v1/GCF_002234675.1_ASM223467v1_genomic.fna.gz

  
# Check quality of fastq files
## A total of 118 pairs were checked
seqkit stats -a *.fastq.gz -T | csvtk pretty -t
