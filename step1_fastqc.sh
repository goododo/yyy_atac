#!/bin/bash

# Define input and output directories
input_dir="/data/project/yyy250327/kr-a001"   # 输入数据的路径
output_dir="/home/qcao02/ycheng/results"      # 输出结果的路径

# Define the sample groups (control and treated)
samples=("ctrl-1" "ctrl-2" "treated-1" "treated-2")

# Loop over each sample group
for group in "${samples[@]}"; do
    # Define input FASTQ paths for paired-end files (R1 and R2)
    R1="${input_dir}/${group}/SQ25012766-kr-a001-${group}_combined_R1.fastq.gz"
    R2="${input_dir}/${group}/SQ25012766-kr-a001-${group}_combined_R2.fastq.gz"

    # Define output directory for each sample
    sample_output="${output_dir}/${group}"

    mkdir -p "${sample_output}"

    # Run FastQC (Quality Check) for each paired-end file (R1 and R2)
    echo "Running FastQC for ${group}..."
    fastqc ${R1} -o ${sample_output}
    fastqc ${R2} -o ${sample_output}

done

echo "FastQC analysis completed for all samples."

