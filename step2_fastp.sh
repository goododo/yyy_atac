#!/bin/bash

# Define input and output directories
input_dir="/data/project/yyy250327/kr-a001"   # 输入数据的路径
output_dir="/home/qcao02/ycheng/results"      # 输出结果的路径

# Define the sample groups (control and treated)
samples=("ctrl-1" "ctrl-2" "treated-1" "treated-2")

# Loop over each sample group
for group in "${samples[@]}"; do
    # Define input FASTQ paths
    R1="${input_dir}/${group}/SQ25012766-kr-a001-${group}_combined_R1.fastq.gz"
    R2="${input_dir}/${group}/SQ25012766-kr-a001-${group}_combined_R2.fastq.gz"

    # Define output directory for each sample
    sample_output="${output_dir}/${group}"

    mkdir -p "${sample_output}"

    # Run fastp for adapter trimming and quality filtering
    echo "Running fastp on ${group}..."
    fastp -i ${R1} -I ${R2} -o ${sample_output}/${group}_R1.trimmed.fastq.gz \
        -O ${sample_output}/${group}_R2.trimmed.fastq.gz --detect_adapter_for_pe \
        -j ${sample_output}/${group}.fastp.json -h ${sample_output}/${group}.fastp.html

    echo "${group} fastp finished."
done



echo "FastP trimming and quality filtering completed for all samples."
