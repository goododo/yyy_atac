#!/bin/bash

# 脚本路径：~/ycheng/scripts/step5_macs2_callpeak.sh
# 功能：对清洗后的 inhouse 数据调用 MACS2 peaks（paired-end）

input_dir="/home/qcao02/ycheng/results"
output_dir="/home/qcao02/ycheng/results/macs2_inhouse"
mkdir -p "$output_dir"

samples=("ctrl-1" "ctrl-2" "treated-1" "treated-2")

echo "🔍 Starting MACS2 peak calling on cleaned inhouse BAMs..."

for sample in "${samples[@]}"; do
    echo "⚙️  Processing $sample..."

    bam="${input_dir}/${sample}/${sample}_final_sorted.bam"
    sample_out="${output_dir}/${sample}"
    mkdir -p "$sample_out"

    macs2 callpeak \
        -t "$bam" \
        -f BAM \
        -n "$sample" \
        --outdir "$sample_out" \
        --nomodel \
        --shift -37 \
        --extsize 73 \
        -g mm \
        -B \
        --keep-dup all

    echo "✅ $sample peak calling done. Output in $sample_out"
done

echo "🎯 All MACS2 peak calling complete!"

