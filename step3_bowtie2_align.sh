#!/bin/bash

# 设置路径
input_dir="/home/qcao02/ycheng/results"
output_dir="/home/qcao02/ycheng/results"
genome_fa="/home/qcao02/ycheng/mm10.fa"
index_prefix="/home/qcao02/ycheng/mm10_index/mm10"

# 创建索引目录并构建索引（只需执行一次）
mkdir -p /home/qcao02/ycheng/mm10_index
if [ ! -f "${index_prefix}.1.bt2" ]; then
    echo "Building bowtie2 index..."
    bowtie2-build ${genome_fa} ${index_prefix}
fi

# 定义样本
samples=("ctrl-1" "ctrl-2" "treated-1" "treated-2")

# 循环每个样本进行比对
for sample in "${samples[@]}"; do
    trimmed_R1="${input_dir}/${sample}/${sample}_R1.trimmed.fastq.gz"
    trimmed_R2="${input_dir}/${sample}/${sample}_R2.trimmed.fastq.gz"
    out_bam="${output_dir}/${sample}/${sample}.bam"

    echo "Aligning ${sample}..."
    bowtie2 -x ${index_prefix} -1 ${trimmed_R1} -2 ${trimmed_R2} \
        --very-sensitive --no-mixed --no-discordant -X 700 \
        | samtools view -bS - > ${out_bam}

    echo "Sorting and indexing ${sample}..."
    samtools sort -o ${output_dir}/${sample}/${sample}_sorted.bam ${out_bam}
    samtools index ${output_dir}/${sample}/${sample}_sorted.bam

    rm ${out_bam}  # 删除未排序 BAM，节省空间
done

echo "Bowtie2 alignment completed."

