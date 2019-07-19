## To do a test on tiny data
snakemake -s 00-scripts/snakefile -j 8 --use-singularity --configfile 01-infos/tiny_config.yaml
## Run the pipeline on diplodus Sargus fastq raw data
snakemake -s 00-scripts/snakefile -j 8 --use-singularity --configfile 01-infos/diplodus_rawdata_config.yaml
## Run the pipeline on mullus Sargus fastq raw data
snakemake -s 00-scripts/snakefile -j 8 --use-singularity --configfile 01-infos/mullus_rawdata_config.yaml 

## Creating a workflow diagram INSTALLL graphviz
snakemake --dag | dot -Tsvg > dag.svg
## clean all files
rm 02-fastq/* 03-illumina_filter/* 04-phix_filter/* 05-trimmed/*
rm -Rf 10-logs/*
rm -Rf .snakemake