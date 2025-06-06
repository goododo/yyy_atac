#!/usr/bin/env bash

echo "开始 step7：pooled peak calling"

MERGED_DIR=../results/bam_merged
PEAK_DIR=../results/macs2_pooled
mkdir -p "$MERGED_DIR" "$PEAK_DIR"

GROUP_NAMES=("ctrl" "treated" "2cell_early" "2cell" "4cell" "8cell" "icm")
GROUP_BAMS=(
"../results/ctrl-1/ctrl-1_sorted.bam ../results/ctrl-2/ctrl-2_sorted.bam"
"../results/treated-1/treated-1_sorted.bam ../results/treated-2/treated-2_sorted.bam"
"../results/bam/GSM1933921_2cell_early_re1.bam ../results/bam/GSM1933922_2cell_early_re2.bam"
"../results/bam/GSM1933924_2cell_re1.bam ../results/bam/GSM1933925_2cell_re2.bam"
"../results/bam/GSM1625847_4cell_re1.bam ../results/bam/GSM1933927_4cell_re2.bam"
"../results/bam/GSM1933928_8cell_re1.bam ../results/bam/GSM1933929_8cell_re2.bam"
"../results/bam/GSM1933930_icm_re1.bam ../results/bam/GSM2156963_icm_re2.bam"
)

GENOME_SIZE="1.87e9"

for i in "${!GROUP_NAMES[@]}"; do
    group="${GROUP_NAMES[$i]}"
    bams="${GROUP_BAMS[$i]}"
    echo "🔄 正在处理组：$group"

    mkdir -p "$PEAK_DIR/$group"
    merged_bam="$MERGED_DIR/${group}_merged.bam"

    echo "🔄 合并 BAM 文件：$bams"
    samtools merge -f "$merged_bam" $bams || {
        echo "❌ samtools merge 失败，跳过 $group"
        continue
    }

    samtools index "$merged_bam"

    echo "📈 运行 MACS2 peak calling"
    macs2 callpeak \
        -t "$merged_bam" \
        -f BAM \
        -n "${group}_pooled" \
        --outdir "$PEAK_DIR/$group" \
        --nomodel --shift -37 --extsize 73 \
        -g "$GENOME_SIZE" -B

    echo "✅ 完成组：$group"
done

echo "🎉 所有组完成"

