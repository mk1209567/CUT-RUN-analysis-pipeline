# CUT-RUN-analysis-pipeline
Analysis pipeline for CUT&amp;RUN assay including alignment, QC, deduplication, and peakcalling
## Introduction:
- This is an analysis workflow for processing CUT&RUN data. It contains multiple shell scripts that can be run under Slurm managment system. Each script represents a key step in CUT&RUN analysis workflow. Currently, this pipeline conduct the process step by step, which provide a easy way to understand the analysis. It will continue to improve and incorporate workflow management system like Snakemake in the future. All the script files are stored under "pipeline" folder.
- I also provide the structure of how I store input, output, and the intermediate data. Those files within are for display purpose only. They are empty files just to show what's the workflow and output going to be like when following this pipeline. In the future, I would continue to add real example files.
## Requirements:
1. FastQC
2. Trimmomatic
3. Bowtie2
4. Picard
3. Samtools
5. MACS2
If you are using Slurm, you probably could use module load to activate these tools, which is included in my scripts. If not, you could download these tools from their source. After installed, make sure you change the direction of your tools correctly in each script.
## Steps:
Following is the step to do CUT&RUN analysis and the corresponding script name. The scripts are all under pipeline folder.
###
