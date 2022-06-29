#!/bin/bash
#SBATCH --partition cpu_dev
#SBATCH --nodes 1
#SBATCH --ntasks-per-node 1
#SBATCH --cpus-per-task 1
#SBATCH --mem 8G
#SBATCH --time 00-03:00:00

#This script will sort bam files and then generate CPM-normalized bigwig file
echo "[info] sort final bam files and generate CPM-normalized bigwig file... "
module load samtools deeptools
sample='sample'
samplePath='../align/dup.marked.below120bp.cleaned'
outPath='../align/bigwig'
samtools index $samplePath/${sample}.bam                                                                                                              
bamCoverage -b $samplePath/${sample}.bam \
            --normalizeUsing CPM \
            -o $outPath/${sampleName}_CPM.bw        
echo "heatmap preparation complete for $sample"