#!/bin/bash
#SBATCH --partition cpu_short
#SBATCH --nodes 1
#SBATCH --ntasks-per-node 1
#SBATCH --cpus-per-task 2
#SBATCH --mem 16G
#SBATCH --time 00-03:00:00
module load samtools
aligndir='../align'
picard="java -jar /gpfs/scratch/kl3741/picard/build/libs/picard.jar"
sample='sample'

echo "[info] Filtering unmapped fragments... "
samtools view -bh -f 3 -F 4 -F 8 $aligndir/bam/${sample}.bam > $aligndir/bam/${sample}.step1.bam

echo "[info] Sorting BAM... "
$picard SortSam INPUT=$aligndir/bam/${sample}.step1.bam \
                OUTPUT=$aligndir/bam/${sample}.sorted.bam \
                SORT_ORDER=coordinate \
                VALIDATION_STRINGENCY=SILENT
rm -rf $aligndir/bam/${read}.step1.bam

echo "[info] Marking duplicates... "
$picard MarkDuplicates INPUT=$aligndir/bam/${sample}sorted.bam \
                       OUTPUT=$aligndir/dup.marked/${sample}.bam \
                       VALIDATION_STRINGENCY=SILENT \
                       METRICS_FILE=picard_metrics/metrics.${sample}.txt 2> ../log/picard/${sample}.mark.dup.log

echo "[info] Removing duplicates... "
samtools view -bh -F 1024 $aligndir/dup.marked/${sample}.bam > $aligndir/dedup/${read}.bam
echo "$sample picard mark_dup and dedup: complete"