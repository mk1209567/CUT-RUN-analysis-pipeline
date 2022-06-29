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
7. [deeptools](https://deeptools.readthedocs.io/en/develop/)

If you are using Slurm, you probably could use *module* load to activate these tools, which is included in my scripts. If not, you could download these tools from their source. After installed, make sure you change the direction of your tools correctly in each script.
## Steps:
Following is the step to do CUT&RUN analysis and the corresponding script name. The scripts are all under pipeline folder.
### 1. FastQC (fastqc.sh)
- FastQC is a commly used tools to generate quality metrics for your raw sequence data.
### 2. Remove adaptor (double_trim.sh)
- After FastQC, we will also get a sense of the contamination caused by adaptor. We will use Trimmomatic to remove adaptors. Note that Trimmomatic package comes with different adaptor sequences, you should choose the one match your library prep.
- Because of the nature of CUT&RUN assay, it's required to do additional trimming. I will use kseq_trimmer in pkgs folder which is suggested by ...
### 3. Alignment (bowtie_align.sh)
-  Align reads to the reference genome. To use bowtie2, reference sequence needs to be indexed. We could either do bowtie2-build <genome.fa> to create indexes or we could download indexes for common references (e.g., hg38, hg19, mm10) directly from [here](http://bowtie-bio.sourceforge.net/bowtie2/index.shtml). 
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
- The output of narrowPeak file and summits.bed file could be visualized using [IGV browser](https://software.broadinstitute.org/software/igv/).
### 7. Heatmap (bamcoverage_cpm.sh --> plot_heatmap.sh)
- Besides viewing bed file directly, we could plot heatmap to see the enrichment of each sample in desired genomic region.
- To be able to compare enrichment difference between samples, we use deeptools to normalize mapped-reads to CPM (count per million) for each sample.
- Then, we could plot heatmap to see the enrichment of each sample in desired genomic region. Note that you could decide how many samples to plot and which bed file to use as desired genomic regions.
## Final Notes:
As an associate Bioinformatician, I do find it useful when reading others step-by-step pipeline instead of using the one-step pipeline. I wish my documentation could also help others better understand the key component of sequencing analysis. Feel free to contact me about any questions or suggestions. I will continue to improve my pipeline and utilize workflow management system in the future.
## Referemces:
1. CUT&RUN Processing Pipeline – 4DN Data Portal. (n.d.-c). 4D Nucleome Data Portal. https://data.4dnucleome.org/resources/data-analysis/cut-and-run-pipeline
2. Zheng, Y. et al. (2020). CUT&Tag Data Processing and Analysis Tutorial. CUTTag_tutorial. https://yezhengstat.github.io/CUTTag_tutorial/
3. Yu et al., CUT&RUNTools 2.0: a pipeline for single-cell and bulk-level CUT&RUN and CUT&Tag data analysis, Bioinformatics, 2021
4. Andrews, S. (2010). FastQC:  A Quality Control Tool for High Throughput Sequence Data
5. Bolger, A. M., Lohse, M., & Usadel, B. (2014). Trimmomatic: A flexible trimmer for Illumina Sequence Data.
6. Langmead B, Salzberg S. Fast gapped-read alignment with Bowtie 2. Nature Methods. 2012, 9:357-359.
7. Picard Tools - By Broad Institute. (n.d.). Picard. http://broadinstitute.github.io/picard/
8. Danecek, P. et al. (2021). Twelve years of SAMtools and BCFtools. GigaScience, 10(2). https://doi.org/10.1093/gigascience/giab008
9. Zhang, Y. et al. (2008). Model-based Analysis of ChIP-Seq (MACS). Genome Biology, 9(9). https://doi.org/10.1186/gb-2008-9-9-r137
10. Ramírez, et al. “deepTools2: a next generation web server for deep-sequencing data analysis.” Nucleic Acids Research (2016): gkw257.
