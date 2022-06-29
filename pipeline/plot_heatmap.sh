#!/bin/bash
#SBATCH --partition cpu_dev
#SBATCH --nodes 1
#SBATCH --ntasks-per-node 1
#SBATCH --cpus-per-task 2
#SBATCH --mem 8G
#SBATCH --time 00-06:00:00
module load deeptools
samplePath='../align/bigwig'
summitPath='../align/peakcalling/macs2.narrow.control'
heatmapPath='../align/heatmap'
#-S represent different samples; -R represent genomic regions
echo "[info] generate heatmaps for CPM-normalized bigwig file... "
computeMatrix reference-point -S $samplePath/sample1_CPM.bw \
                                 $samplePath/sample2_CPM.bw \
                                 $samplePath/sample3_CPM.bw \
                                 $samplePath/sample4_CPM.bw \
                              -R $summitPath/sample_macs2_narrow_summits.bed \
                              --skipZeros -o $heatmapPath/sample.mat.gz \
                              -p 2 -a 1000 -b 1000 --referencePoint center
plotHeatmap -m $heatmapPath/sample.mat.gz \
            -out $heatmapPath/sample.heatmap.png \
            --sortUsing sum --xAxisLabel "" --yAxisLabel "Mean CPM" \
            --heatmapHeight 10 --legendLocation none \
            --samplesLabel "IgG_vehicle" "IgG_treatment" "TF_vehicle" "TF_treatment" \
            --regionsLabel "treatment_induced-peaks" --plotTitle "CUT&RUN Analysis for sample-set"
echo 'plot Heatmap: done'