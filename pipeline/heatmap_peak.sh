#!/bin/bash
#SBATCH --partition cpu_dev
#SBATCH --nodes 1
#SBATCH --ntasks-per-node 1
#SBATCH --cpus-per-task 2
#SBATCH --mem 8G
#SBATCH --time 00-06:00:00

#This script will create a heatmap for scores associated with genomic regions with the CPM-normed bigwig files...
#The genomic regions in this script will be the summit locations of the peaks called from the treatment sample
module load deeptools
cores=2
samplePath='/gpfs/scratch/kl3741/cutrun/align/bigwig'
summitPath='/gpfs/scratch/kl3741/cutrun/align/peakcalling/macs2.narrow_q001_dup.marked.below120bp_control'
heatmapPath='/gpfs/scratch/kl3741/cutrun/align/heatmap'

#-S represent different samples; -R represent genomic regions
#-S sample 1, 2, 3, 4,..., you could reduce or increase the number of sample you want to plot together
computeMatrix reference-point -S $samplePath/EtOH_IgG_CPM.bw \
                                 $samplePath/E2_IgG_CPM.bw \
                                 $samplePath/EtOH_ESR1_CPM.bw \
                                 $samplePath/E2_ESR1_CPM.bw \
                              -R $summitPath/HBR35_S17_L002_macs2_narrow_summits.bed \
                              --skipZeros -o $heatmapPath/ave.mat.gz -p $cores -a 1000 -b 1000 --referencePoint center
echo 'compute Matrix: done'
plotHeatmap -m $heatmapPath/ave.mat.gz -out $heatmapPath/ave.heatmap.png --sortUsing sum --xAxisLabel "" --yAxisLabel "Mean CPM" --heatmapHeight 10 --legendLocation none \
--samplesLabel "IgG EtOH" "IgG E2" "ESR1 EtOH" "ESR1 E2" --regionsLabel "peaks" --plotTitle "4/4/22 CUTnRUN analysis"
#above are some parameters you could adjust for your heatmap's labels
echo 'plot Heatmap: done'