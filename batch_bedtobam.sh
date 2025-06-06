#!/bin/bash

#功能：将bedgraph批量转换为bam
INPUTDIR=/home/fengyan02/atac_data/atac_land/bedGraph
OUTDIR=~/ycheng/results/bam
GENOME=~/ycheng/mm10.chrom.sizes

mkdir -p "$OUTDIR"

for FILE in $INPUTDIR/*.bedGraph; do
    BASENAME=$(basename "$FILE" .bedGraph)
    BAMFILE=$OUTDIR/${BASENAME}.bam
    echo "🔄 正在转换: $FILE → $BAMFILE"
    bedtools bedtobam -i "$FILE" -g "$GENOME" > "$BAMFILE"
    if [[ -f "$BAMFILE" ]]; then
        echo "✅ 成功: $BAMFILE"
    else
        echo "❌ 失败: $FILE"
    fi
done

echo "🎉 所有文件转换完成"


