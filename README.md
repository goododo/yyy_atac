# ATAC-seq analysis for yyy's project
## ✅ ycheng's part
### 1. Convert NACS2 pileup.bdg to BigWig
batch_convert_bigwig.sh

### 2. Comvert bedGraph to bam files
batch_bedtobam.sh

### 3. FastQC analysis
step1_fastqc.sh

### 4. FastP trimming and quality filtering
step2_fastp.sh

### 5. Bowtie2 alignment - .fastq.gz to .bam
step3_bowtie2_align.sh

### 6. Processing samples -  remove chrM, duplicates, and blocklist regions
step4_post_mapping_cleanup.sh

### 7. Peaks calling
step5_macs2_callpeak.sh
batch_macs2_callpeak.sh

### 8. Convert final cleaned BAM to BigWig
step6_bam_to_bigwig.sh

### 9. Pooled peak calling
step7_pooled_peak_calling.sh

### 10. Differentiation peaks analysis
step8_diff_peak_bedtools.sh

## ✅ GAO's part (in R)
### 1. Counting and plotting





