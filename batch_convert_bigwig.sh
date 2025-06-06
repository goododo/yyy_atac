#!/bin/bash

# 将 public 数据中的 MACS2 pileup.bdg 转换为 BigWig


echo "🔁 Converting public MACS2 .bdg → BigWig..."

# 路径设置
macs2_dir="/home/qcao02/ycheng/results/macs2"
chrom_sizes="/home/qcao02/ycheng/mm10.chrom.sizes"

# 遍历每个样本的 MACS2 目录
for sample_dir in ${macs2_dir}/*; do
    [ -d "$sample_dir" ] || continue  # 跳过非目录
    sample_name=$(basename "$sample_dir")
    bdg_file="${sample_dir}/${sample_name}_treat_pileup.bdg"
    bw_file="/home/qcao02/ycheng/results/${sample_name}.bw"

    if [[ -f "$bdg_file" ]]; then
        echo "⚙️  Processing $sample_name..."
        bedtools sort -i "$bdg_file" > "${bdg_file}.sorted"
        bedGraphToBigWig "${bdg_file}.sorted" "$chrom_sizes" "$bw_file"
        rm "${bdg_file}.sorted"
    else
        echo "❌ Missing file: ${bdg_file}, skipping..."
    fi
done

echo "✅ Conversion complete. BigWig files saved to ~/ycheng/results/"

