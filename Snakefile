__author__ = "Pierre-Edouard Guerin"
__license__ = "MIT"

rule all:
	input:
		expand("{folder}/{fastqf}.fastq.gz", fastqf=config["fastqFiles"],folder=config["fastqFolderPath"]),
		expand("02-fastq/{fastqf}.fastq", fastqf=config["fastqFiles"]),
		expand("03-illumina_filter/{fastqf}.i.fastq", fastqf=config["fastqFiles"]),
		expand("04-phix_filter/{fastqf}.i.p.fastq", fastqf=config["fastqFiles"]),
		expand("05-trimmed/{fastqf}.i.p.q.fastq.gz", fastqf=config["fastqFiles"]),
		expand("10-logs/fastqgz_gunzip/{fastqf}.log", fastqf=config["fastqFiles"]),
		expand("10-logs/fastq_illumina_filter/{fastqf}.log", fastqf=config["fastqFiles"]),
		expand("10-logs/phix_filter/{fastqf}.log", fastqf=config["fastqFiles"]),
		expand("10-logs/quality_filter/{fastqf}.log", fastqf=config["fastqFiles"]),
		expand("10-logs/quality_filter/{fastqf}.json", fastqf=config["fastqFiles"]),
		expand("10-logs/quality_filter/{fastqf}.html", fastqf=config["fastqFiles"]),

include: "00-rules/clean_fastq.smk"
