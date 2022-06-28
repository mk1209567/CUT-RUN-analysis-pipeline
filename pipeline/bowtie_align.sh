#!/bin/bash
#SBATCH --partition cpu_short,cpu_medium,cpu_long
#SBATCH --nodes 1
#SBATCH --ntasks-per-node 1
#SBATCH --cpus-per-task 8
#SBATCH --mem 64G
#SBATCH --time 00-12:00:00
module load bowtie2 samtools
trimdir2='../data_trimmed/trimdir2'
build='hg38'
sample='sample'
bowtie2 -p 8 --dovetail --very-sensitive --phred33 -x ../assemblise/$build/genome \
                    -1 $trimdir2/${sample}_1.paired.fastq.gz -2 $trimdir2/${sample}_2.paired.fastq.gz \
                    2> ../log/bowtie2/${sample}.bowtie2.log | samtools view -bS - > ../align/bam/${sample}.bam
echo "bowtie align for $sample: complete"