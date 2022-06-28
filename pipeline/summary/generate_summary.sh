#!/bin/bash
#SBATCH --partition cpu_dev
#SBATCH --nodes 1
#SBATCH --ntasks-per-node 1
#SBATCH --cpus-per-task 1
#SBATCH --mem 16G
#SBATCH --time 00-03:00:00
module load samtools

#generate summary report separately and combine them in the end
#1: generate summary report for fastq file (before and after trimming)
filepath='/gpfs/data/chaklab/data/epigenetic_data/autism/Simons/CUTnRUN/2022-04-27_hanna/fastq'
trimfilepath='/gpfs/scratch/kl3741/cutrun/fastq/trimdir2'
for i in {34..51}
do
sample="HBR${i}_S$(($i-18))_L002"
fastq_R1="${filepath}/${sample}_R1_001.fastq.gz"
fastq_R2="${filepath}/${sample}_R2_001.fastq.gz"
lines_R1=$(zcat "$fastq_R1" | wc -l)
reads_R1=$(echo "${lines_R1}/4" | bc)
lines_R2=$(zcat "$fastq_R2" | wc -l)
reads_R2=$(echo "${lines_R2}/4" | bc)
#watch out! trimmed fastq could be in different date folder
fastq_R1_trimmed="${trimfilepath}/2022-04-27/${sample}_1.paired.fastq.gz"
fastq_R2_trimmed="${trimfilepath}/2022-04-27/${sample}_2.paired.fastq.gz"
lines_R1_trimmed=$(zcat "$fastq_R1_trimmed" | wc -l)
reads_R1_trimmed=$(echo "${lines_R1_trimmed}/4" | bc)
lines_R2_trimmed=$(zcat "$fastq_R2_trimmed" | wc -l)
reads_R2_trimmed=$(echo "${lines_R2_trimmed}/4" | bc)

if [ $i -eq 34 ] ; then echo "#SAMPLE,R1 RAW READS,R2 RAW READS,R1 READS AFTER TRIM,R2 READS AFTER TRIM"; fi
echo "${sample},${reads_R1},${reads_R2},${reads_R1_trimmed},${reads_R2_trimmed}"
done > summary_fastq.csv

#2: generate summary report for bowtie2 alignment results (unfiltered and filtered bam)
samplePath='/gpfs/scratch/kl3741/cutrun/align/bam'
sortbamPath='/gpfs/scratch/kl3741/cutrun/align/sorted'
filteredPath='/gpfs/scratch/kl3741/cutrun/align/bam_filtered'
for i in {34..51}
do
sample="HBR${i}_S$(($i-18))_L002"
reads_input=$(samtools view -c "${samplePath}/${sample}.bam")
reads_mapped=$(samtools view -c "${sortbamPath}/${sample}.bam")
reads_chrM=$(samtools view "${samplePath}/${sample}.bam" | cut -f 3 | grep -c "chrM")
reads_filtered=$(samtools view -c "${filteredPath}/${sample}.sorted.bam")

reads_mapped_pct=$(echo "(${reads_mapped}/${reads_input})*100" | bc -l | cut -c 1-4)
reads_mapped_pct="${reads_mapped_pct}%"
reads_chrM_pct=$(echo "(${reads_chrM}/${reads_input})*100" | bc -l | cut -c 1-4)
reads_chrM_pct="${reads_chrM_pct}%"
reads_filtered_pct=$(echo "(${reads_filtered}/${reads_input})*100" | bc -l | cut -c 1-4)
reads_filtered_pct="${reads_filtered_pct}%"

if [ $i -eq 34 ] ; then echo "#SAMPLE,TOTAL READS,MAPPED READS,MAPPED READS %,CHR M READS %,MAPPED READS MQ30 %"; fi
echo "${sample},${reads_input},${reads_mapped},${reads_mapped_pct},${reads_chrM_pct},${reads_filtered_pct}"
done > summary_bowtie.csv

#3: generate summary report for duplication (before and after trimming)
picardfilePath='/gpfs/scratch/kl3741/cutrun/scripts/picard_metrics'
for i in {34..51}
do
sample="HBR${i}_S$(($i-18))_L002"
mapped_read_pair=$(sed -n 8p "${picardfilePath}/metrics.${sample}.txt" | cut -f 3)
dedup_read_pair=`expr $mapped_read_pair - $(sed -n 8p "${picardfilePath}/metrics.${sample}.txt" | cut -f 7)`
duplicates_percent=$(echo "$(sed -n 8p "${picardfilePath}/metrics.${sample}.txt" | cut -f 9) * 100" | bc -l | cut -c 1-4)%

if [ $i -eq 34 ] ; then echo "#SAMPLE,MAPPED READS,DEDUPLICATED READS,DUPLICATES %"; fi
echo "${sample},`expr ${mapped_read_pair} \* 2`,`expr ${dedup_read_pair} \* 2`,${duplicates_percent}"
done > summary_picard.csv

paste -d',' summary_fastq.csv summary_bowtie.csv | paste -d',' - summary_picard.csv | cut -d',' -f 6,12 --complement > summary_combine_report2.csv
rm summary_fastq.csv summary_bowtie.csv summary_picard.csv
echo 'summary report: done'