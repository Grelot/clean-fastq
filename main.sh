snakemake -s 00-scripts/snakefile -j 8 --use-singularity --configfile 01-infos/diplodus_rawdata_config.yaml
## clean all files
rm 02-fastq/* 03-illumina_filter/* 04-phix_filter/* 05-trimmed/*
rm -Rf 10-logs/*
rm -Rf .snakemake