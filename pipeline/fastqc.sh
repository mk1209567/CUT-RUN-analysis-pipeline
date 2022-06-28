#!/bin/bash
#SBATCH --partition cpu_short,cpu_medium,cpu_large
#SBATCH --nodes 1
#SBATCH --ntasks-per-node 1
#SBATCH --cpus-per-task 4
#SBATCH --mem 32G
#SBATCH --time 00-03:00:00
module load fastqc
dataPath='../data'
sample="sample"
fastqc --threads 4 -o ../fastqFileQC/ ${dataPath}/${sample}_R*.fastq.gz