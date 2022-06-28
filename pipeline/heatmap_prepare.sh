#!/bin/bash
#SBATCH --partition cpu_dev
#SBATCH --nodes 1
#SBATCH --ntasks-per-node 1
#SBATCH --cpus-per-task 1
#SBATCH --mem 8G
#SBATCH --time 00-03:00:00

#This script will sort bam files and then generate CPM-normalized bigwig file
module load samtools deeptools
sampleName=$1 #sample filename
samplePath='/gpfs/scratch/kl3741/cutrun/align/dup.marked.below120bp.cleaned'
outPath='/gpfs/scratch/kl3741/cutrun/align/bigwig'
samtools index $samplePath/${sampleName}.bam                                                                                                              
bamCoverage -b $samplePath/${sampleName}.bam \
            --normalizeUsing CPM \
            -o $outPath/${sampleName}_CPM.bw        
echo "heatmap preparation complete for $sampleName"