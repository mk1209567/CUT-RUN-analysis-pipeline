#!/bin/bash
#SBATCH --partition cpu_dev
#SBATCH --nodes 1
#SBATCH --ntasks-per-node 1
#SBATCH --cpus-per-task 1
#SBATCH --mem 8G
#SBATCH --time 00-06:00:00
filePath=/gpfs/scratch/kl3741/cutrun/align/dup.marked.below120bp.cleaned
samtools merge -f $filePath/E2_ESR1.bam $filePath/HBR35_S17_L002.bam $filePath/HBR41_S23_L002.bam
samtools merge -f $filePath/E2_IgG.bam $filePath/HBR36_S18_L002.bam $filePath/HBR42_S24_L002.bam
samtools merge -f $filePath/EtOH_ESR1.bam $filePath/HBR38_S20_L002.bam $filePath/HBR44_S26_L002.bam
samtools merge -f $filePath/EtOH_IgG.bam $filePath/HBR39_S21_L002.bam $filePath/HBR45_S27_L002.bam
echo 'bam files merging: Done'