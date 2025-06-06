#!/bin/bash

# Step 6: Convert final cleaned BAM to BigWig
# Requirements: deeptools (bamCoverage), samtools

input_dir="/home/qcao02/ycheng/results"
output_dir="/home/qcao02/ycheng/results/bigwig_inhouse"
mkdir -p "$output_dir"

samples=("ctrl-1" "ctrl-2" "treated-1" "treated-2")

echo "🚀 Starting bam ➝ BigWig conversion..."

for sample in "${samples[@]}"; do
    echo "⚙️  Processing $sample..."
    bam="${input_dir}/${sample}/${sample}_final_sorted.bam"
    bw="${output_dir}/${sample}.bw"

    bamCoverage \
        -b "$bam" \
        -o "$bw" \
        --normalizeUsing CPM \
        --binSize 10 \
        --extendReads \
        -p 4

    echo "✅ Done: $bw"
done

echo "🎯 All BigWig files generated in $output_dir"

