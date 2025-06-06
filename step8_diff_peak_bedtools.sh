#!/usr/bin/env bash

echo "🔍 开始差异 peaks 分析：使用 bedtools 计算特异性和重叠 peaks"

# 设置路径
CTRL_PEAK=../results/macs2_pooled/ctrl/ctrl_pooled_peaks.narrowPeak
TREATED_PEAK=../results/macs2_pooled/treated/treated_pooled_peaks.narrowPeak
OUTDIR=../results/diff_peaks

mkdir -p $OUTDIR

# treated 特异性 peaks
bedtools intersect -v -a $TREATED_PEAK -b $CTRL_PEAK > $OUTDIR/treated_specific.bed

# ctrl 特异性 peaks
bedtools intersect -v -a $CTRL_PEAK -b $TREATED_PEAK > $OUTDIR/ctrl_specific.bed

# shared peaks
bedtools intersect -u -a $CTRL_PEAK -b $TREATED_PEAK > $OUTDIR/shared_peaks.bed

echo "✅ 差异 peaks 分析完成，结果保存在 $OUTDIR"

