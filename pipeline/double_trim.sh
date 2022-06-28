#!/bin/bash
#SBATCH --partition cpu_dev
#SBATCH --nodes 1
#SBATCH --ntasks-per-node 1
#SBATCH --cpus-per-task 1
#SBATCH --mem 8G
#SBATCH --time 00-03:00:00
module load trimmomatic
trimdir1='../data_trimmed/trimdir1'
trimdir2='../data_trimmed/trimdir2'
dataPath='../data'
sample='sample'
java -jar /gpfs/share/apps/trimmomatic/0.36/trimmomatic-0.36.jar PE -phred33 \
                        ${dataPath}/${sample}_R1_001.fastq.gz \
                        ${dataPath}/${sample}_R2_001.fastq.gz \
                        ${trimdir1}/${sample}_1.paired.fastq.gz ${trimdir1}/${sample}_1.unpaired.fastq.gz \
                        ${trimdir1}/${sample}_2.paired.fastq.gz ${trimdir1}/${sample}_2.unpaired.fastq.gz \
                        ILLUMINACLIP:/gpfs/share/apps/trimmomatic/0.36/adapters/TruSeq3-PE.fa:2:15:4:4:true \
                        LEADING:20 TRAILING:20 SLIDINGWINDOW:4:15 MINLEN:25 > ../log/trim/${sample}_trim1.log 2>&1
echo "Trimmomatic trimming: complete"

kseq_test='../pkgs/kseq_test'
len=51
$kseq_test $trimdir1/${sample}_1.paired.fastq.gz $len $trimdir2/${sample}_1.paired.fastq.gz
$kseq_test $trimdir1/${sample}_2.paired.fastq.gz $len $trimdir2/${sample}_2.paired.fastq.gz
echo "kseq_trim complete"