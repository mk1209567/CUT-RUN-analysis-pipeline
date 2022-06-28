#!/bin/bash
#SBATCH --partition cpu_short
#SBATCH --nodes 1
#SBATCH --ntasks-per-node 1
#SBATCH --cpus-per-task 2
#SBATCH --mem 16G
#SBATCH --time 00-03:00:00
module load samtools
sample='sample'

echo "[info] Filtering reads longer than 120bp... "
samtools view -h ../align/dup.marked/$sample.bam | LC_ALL=C awk -f ../pkgs/filter_below.awk | samtools view -Sb - > ../align/dup.marked.below120bp/$sample.bam
samtools view -h ../align/dedup/$sample.bam | LC_ALL=C awk -f ../pkgs/filter_below.awk | samtools view -Sb - > ../align/dedup.below120bp/$sample.bam
echo "[info] Filtering reads aligned to chrM, chr*random, and chrUn, and keep reads with mapping quality above 40... "
samtools view -h ../align/dup.marked.below120bp/${sample}.bam | sed '/chrM/d;/chrEBV/d;/random/d;/chrUn/d' | samtools view -Shb -q40 - > ../align/dup.marked.below120bp.cleaned/${sample}.bam

echo "[info] Creating bam index files... ""$sample".bam
samtools index ../align/dup.marked.below120bp/$sample.bam
samtools index ../align/dedup.below120bp/$sample.bam
samtools index ../align/dup.marked.below120bp.cleaned/${sample}.bam

echo "filtering for $sample: complete"