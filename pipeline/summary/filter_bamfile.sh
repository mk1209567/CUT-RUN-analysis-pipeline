#!/bin/bash
#SBATCH --partition cpu_dev
#SBATCH --nodes 1
#SBATCH --ntasks-per-node 1
#SBATCH --cpus-per-task 4
#SBATCH --mem 32G
#SBATCH --time 00-03:00:00
module load sambamba samtools

sample=$1
samplePath='/gpfs/scratch/kl3741/cutrun/align/bam'
filteredPath='/gpfs/scratch/kl3741/cutrun/align/bam_filtered'
sambamba-0.6.8 view --nthreads 4 --filter "mapping_quality >= 30 and ref_name != 'chrM'" \
                                 --format bam \
                                 -o ${filteredPath}/${sample}.bam \
                                 ${samplePath}/${sample}.bam
sambamba-0.6.8 sort --nthreads 4 --memory-limit 32GB \
                                 ${filteredPath}/${sample}.bam
rm ${filteredPath}/${sample}.bam ${filteredPath}/${sample}.sorted.bam.bai

