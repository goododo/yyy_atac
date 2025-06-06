
#!/bin/bash

#批量调用MACS2 peak calling

INPUTDIR=~/ycheng/results/bam
OUTDIR=~/ycheng/results/macs2
mkdir -p "$OUTDIR"

for BAM in $INPUTDIR/*.bam; do
    BASENAME=$(basename "$BAM" .bam)
    SAMPLE_OUTDIR=$OUTDIR/$BASENAME
    mkdir -p "$SAMPLE_OUTDIR"

    echo "🧬 调用 peaks: $BASENAME"

    macs2 callpeak -t "$BAM" \
      -f BAM \
      -n "$BASENAME" \
      --outdir "$SAMPLE_OUTDIR" \
      --nomodel --shift -37 --extsize 73 \
      -g mm -B
done

echo "✅  所有样本 peak calling 完成！"

