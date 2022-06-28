#!/bin/bash
#SBATCH --partition cpu_short
#SBATCH --nodes 1
#SBATCH --ntasks-per-node 1
#SBATCH --cpus-per-task 2
#SBATCH --mem 8G
#SBATCH --time 00-03:00:00
module load macs2
sample='sample'
control='control_sample'
logdir="../log/peakcalling"
datadir="../align/dup.marked.below120bp.cleaned"
outdir_control='../align/peakcalling/macs2.narrow.control'
outdir_no_control='../align/peakcalling/macs2.narrow.no_control'

echo "[info] macs2 narrow peak calling with control ..."
macs2 callpeak -t $datadir/$sample.bam -c $datadir/$control.bam -g hs -f BAMPE -n \
                ${sample}_macs2_narrow --outdir $outdir_control -q 0.01 -B --SPMR --keep-dup all \
                2> $logdir/${sample}.macs2.narrow.log

echo "[info] macs2 narrow peak calling without control ..."
macs2 callpeak -t $datadir/$sample.bam -g hs -f BAMPE -n \
                ${sample}_macs2_narrow --outdir $outdir_no_control -q 0.01 -B --SPMR --keep-dup all \
                2> $logdir/${sample}.macs2.narrow.no_control.log

echo "macs2 narrow peak calling for $sample with/without control is done!!!"