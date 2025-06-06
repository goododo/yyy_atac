#!/bin/bash

# 设置路径
input_dir="/home/qcao02/ycheng/results"
blacklist="/home/qcao02/ycheng/tools/mm10-blacklist.v2.bed"
samples=("ctrl-1" "ctrl-2" "treated-1" "treated-2")

for sample in "${samples[@]}"; do
    echo "🔧 Processing ${sample}..."

    sample_dir="${input_dir}/${sample}"
    sorted_bam="${sample_dir}/${sample}_sorted.bam"

    # 去除 chrM
    echo "  🧽 Removing chrM..."
    samtools view -h "${sorted_bam}" | grep -v -w "chrM" | samtools view -@ 4 -b -o "${sample_dir}/${sample}_noChrM.bam"
    samtools index "${sample_dir}/${sample}_noChrM.bam"

    # 去除 duplicates（使用 Picard）
    echo "  🧼 Removing duplicates..."
    java -jar /home/qcao02/anaconda3/pkgs/picard-2.27.5-hdfd78af_0/share/picard-2.27.5-0/picard.jar MarkDuplicates \
      INPUT="${sample_dir}/${sample}_noChrM.bam" \
      OUTPUT="${sample_dir}/${sample}_dedup.bam" \
      METRICS_FILE="${sample_dir}/${sample}_dedup_metrics.txt" \
      REMOVE_DUPLICATES=true \
      ASSUME_SORTED=true \
      VALIDATION_STRINGENCY=SILENT
    samtools index "${sample_dir}/${sample}_dedup.bam"

    # 去除 blacklist 区域
    echo "  🚫 Removing blacklist regions..."
    bedtools intersect -nonamecheck -v \
      -abam "${sample_dir}/${sample}_dedup.bam" \
      -b "${blacklist}" \
      > "${sample_dir}/${sample}_final.bam"
    samtools sort -o "${sample_dir}/${sample}_final_sorted.bam" "${sample_dir}/${sample}_final.bam"
    samtools index "${sample_dir}/${sample}_final_sorted.bam"

    # 清理中间文件
    rm "${sample_dir}/${sample}_noChrM.bam" "${sample_dir}/${sample}_noChrM.bam.bai"
    rm "${sample_dir}/${sample}_dedup.bam" "${sample_dir}/${sample}_dedup.bam.bai"
    rm "${sample_dir}/${sample}_final.bam"

    echo "✅ ${sample} done."
done

echo "🎯 All samples processed!"

