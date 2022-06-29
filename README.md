# CUT-RUN-analysis-pipeline
Analysis pipeline for CUT&amp;RUN assay including alignment, QC, deduplication, and peakcalling
## Introduction:
- This is an analysis workflow for processing CUT&RUN data. It contains multiple shell scripts that can be run under Slurm managment system. Each script represents a key step in CUT&RUN analysis workflow. Currently, this pipeline conduct the process step by step, which provide a easy way to understand the analysis. It will continue to improve and incorporate workflow management system like Snakemake in the future. All the script files are stored under "pipeline" folder.
- I also provide the structure of how I store input, output, and the intermediate data. Those files within are for display purpose only. They are empty files just to show what's the workflow and output going to be like when following this pipeline. In the future, I would continue to add real example files.
## Requirements:
1. [FastQC](https://www.bioinformatics.babraham.ac.uk/projects/fastqc/)
2. [Trimmomatic](https://github.com/usadellab/Trimmomatic)
3. [Bowtie 2](http://bowtie-bio.sourceforge.net/bowtie2/manual.shtml)
4. [Picard](https://broadinstitute.github.io/picard/)
5. [Samtools](http://www.htslib.org/)
6. [MACS2](https://github.com/macs3-project/MACS)

If you are using Slurm, you probably could use *module* load to activate these tools, which is included in my scripts. If not, you could download these tools from their source. After installed, make sure you change the direction of your tools correctly in each script.
## Steps:
Following is the step to do CUT&RUN analysis and the corresponding script name. The scripts are all under pipeline folder.
### 1. FastQC (fastqc.sh)
- FastQC is a commly used tools to generate quality metrics for your raw sequence data.
### 2. Remove adaptor (double_trim.sh)
- After FastQC, we will also get a sense of the contamination caused by adaptor. We will use Trimmomatic to remove adaptors. Note that Trimmomatic package comes with different adaptor sequences, you should choose the one match your library prep.
- Because of the nature of CUT&RUN assay, it's required to do additional trimming. I will use kseq_trimmer in pkgs folder which is suggested by ...
### 3. Alignment (bowtie_align.sh)
-  Align reads to the reference genome. To use bowtie2, reference sequence needs to be indexed. We could either do bowtie2-build <genome.fa> to create indexes or we could download indexes for common references (e.g., hg38, hg19, mm10) directly from their [website](http://bowtie-bio.sourceforge.net/bowtie2/index.shtml). 
- The output is a SAM file, which has alignment information for each read. SAM file is big and uncompressed. We would like to use samtools to convert it into binary format (BAM file).
### 4. Deduplication (picard_rmdup.sh)
- While doing CUT&RUN assay, it's possible to generate PCR duplicates which are artifacts originating from sequencing of identical copies amplified from the same DNA template. We will need to be aware of.
- I will generate two files. One is duplication marked BAM file, and the other one is deduplication BAM file. One can consider using either of them. Because the reads from CUT&RUN is generally small and have low duplication rate. It's okay to not deduplicate.
### 5. Filtering (filter.sh)
- After alignment, some reads are aligned to mitochondria chromosome(chrM), unlocalized sequences(chr*_random), and unplaced sequences (chrUn). We would like to remove these before peak calling.
- Also, we use samtools to remove low quality (q<40) aligned reads.
- The filtered BAM file is stored separately.
### 6. Peak-calling (MACS2_peakcalling.sh)
- Peak calling is a metthod used to identify areas in a genome that has been enriched with aligned reads.
- We used MACS2 to call peaks with or without control samples.
- The output of narrowPeak file and summits.bed file could be visualized using IGV browser.
### 7. Heatmap (to be continue)

## Final Notes:
As an associate Bioinformatician, I continue to learn and improve my biofiormatics pipeline. While learning, I do find it useful when reading others step-by-step pipeline instead of using the one-step pipeline. I wish my documentation could also help others better understand the key component of sequencing analysis. Feel free to contact me about any questions or suggestions.
## Referemces:
