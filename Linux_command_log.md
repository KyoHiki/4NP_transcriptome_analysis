# 1. Preparation of analysis
### Install several softwares through conda
```
conda install bioconda::seqkit
conda install bioconda::csvtk
conda create -n hisat2 bioconda::hisat2
conda create -n htseq bioconda::htseq
```
<br/>
<br/>
<br/>

### Download the reference genome
#### Hd-rR strain (assembly ASM223467v1)
```
wget https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/002/234/675/GCF_002234675.1_ASM223467v1/GCF_002234675.1_ASM223467v1_genomic.fna.gz
wget https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/002/234/675/GCF_002234675.1_ASM223467v1/GCF_002234675.1_ASM223467v1_genomic.gtf.gz
```
#### open gz files
```
gunzip GCF_002234675.1_ASM223467v1_genomic.fna.gz
gunzip GCF_002234675.1_ASM223467v1_genomic.fna.gz
```
<br/>
<br/>
<br/>


# 2. Check original RNA-Seq data
### Check quality of fastq files
#### A total of 118 pairs were checked
```seqkit stats -a *.fastq.gz -T | csvtk pretty -t```

<br/>
<br/>
<br/>

# 3. Mapping RNA-Seq reads to the reference
### Index the reference 
```
conda activate hisat2
hisat2-build ./Hd-rR/GCF_002234675.1_ASM223467v1_genomic.fna HdrR -p 20
```

> Headers:
>    len: 733566086  
>    gbwtLen: 733566087  
>    nodes: 733566087  
>    sz: 183391522  
>    gbwtSz: 183391522  
>    lineRate: 6  
>    offRate: 4  
>    offMask: 0xfffffff0  
>    ftabChars: 10  
>    eftabLen: 0  
>    eftabSz: 0  
>    ftabLen: 1048577  
>    ftabSz: 4194308  
>    offsLen: 45847881  
>    offsSz: 183391524  
>    lineSz: 64  
>    sideSz: 64  
>    sideGbwtSz: 48  
>    sideGbwtLen: 192  
>    numSides: 3820657  
>    numLines: 3820657  
>    gbwtTotLen: 244522048  
>    gbwtTotSz: 244522048  
>    reverse: 0  
>    linearFM: Yes  

<br/>

### Mapping via for loop
#### An example code is shown
```
F1_juv_C2_1=(./raw_RNASeq_data/HN00120498_F1juv/F1_juv_C2_49_1 ./raw_RNASeq_data/HN00120498_F1juv/F1_juv_C2_50_1 ./raw_RNASeq_data/HN00120498_F1juv/F1_juv_C2_51_1 ./raw_RNASeq_data/HN00120498_F1juv/F1_juv_C2_52_1 ./raw_RNASeq_data/HN00120498_F1juv/F1_juv_C2_53_1 ./raw_RNASeq_data/HN00120498_F1juv/F1_juv_C2_54_1 ./raw_RNASeq_data/HN00120498_F1juv/F1_juv_C2_55_1 　./raw_RNASeq_data/HN00120498_F1juv/F1_juv_C2_56_1)
F1_juv_C2_2=(./raw_RNASeq_data/HN00120498_F1juv/F1_juv_C2_49_2 ./raw_RNASeq_data/HN00120498_F1juv/F1_juv_C2_50_2 ./raw_RNASeq_data/HN00120498_F1juv/F1_juv_C2_51_2 ./raw_RNASeq_data/HN00120498_F1juv/F1_juv_C2_52_2 ./raw_RNASeq_data/HN00120498_F1juv/F1_juv_C2_53_2 ./raw_RNASeq_data/HN00120498_F1juv/F1_juv_C2_54_2 ./raw_RNASeq_data/HN00120498_F1juv/F1_juv_C2_55_2 　./raw_RNASeq_data/HN00120498_F1juv/F1_juv_C2_56_2)

for idx in "${!F1_juv_C2_1[@]}"; do 
  i=${F1_juv_C2_1[$idx]}
  j=${F1_juv_C2_2[$idx]}
    hisat2 -x HdrR -1 ${i}.fastq.gz -2 ${j}.fastq.gz -S ${i}.sam -p 20     # p is number of threads
done
```

<br/>

### Index sam files 
```
for xx in ${F1_juv_C2_1[@]}; do
   samtools sort -O bam -o ${xx}.sorted.bam ${xx}.sam -@20
   samtools index ${xx}.sorted.bam -@20
done
```
<br/>
<br/>
<br/>

# 4. Quantification expression levels
#### Activate HT-Seq 
```
conda activate htseq
```
#### HT-Seq count
```
for xx in ${F1_juv_C2_1[@]}; do
   htseq-count -f bam ${xx}.sorted.bam ./Hd-rR/GCF_002234675.1_ASM223467v1_genomic.gtf > ${xx}.txt
done
```
