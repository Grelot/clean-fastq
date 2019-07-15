
# clean-fastq

[![Snakemake](https://img.shields.io/badge/snakemake-5.5.2-brightgreen.svg)](https://snakemake.bitbucket.io)



A workflow designed to clean `fastq files` for the [SEACONNECT project](https://reefish.umontpellier.fr/index.php?article9/total-seaconnect)


# Installation

## Prerequisites

* [singularity](https://github.com/sylabs/singularity)
* [snakemake](https://snakemake.bitbucket.io)

## Singularity containers

### Install Singularity
See [https://www.sylabs.io/docs/](https://www.sylabs.io/docs/) for instructions to install Singularity.

### Programs
Following programs are installed into our container:
- [fastq_illumina_filter](http://cancan.cshl.edu/labmembers/gordon/fastq_illumina_filter/) keeps reads that were NOT filtered by illumina sequencer.
- [fastp](https://github.com/OpenGene/fastp) provides fast all-in-one preprocessing for `fastq` files.
- [bbduk](https://jgi.doe.gov/data-and-tools/bbtools/) filters or trims reads for adapters and contaminants using k-mers.


### Download (or build) the container

```
singularity pull --name cleanfastq.simg ..........................
```
alternatively, if you are administrator on your machine, you can build a local image:
```
sudo singularity build cleanfastq.simg Singularity.cleanfastq
```
### Run the Obitools container

```
singularity run cleanfastq.simg
```
it should output:
```
Opening container...ubuntu xenial: fastq_illumina_filter, bbduck, fastp
```


# The pipeline 

## Filter illumina fastq

Illumina sequencers perform an internal quality filtering procedure called chastity filter, and reads that pass this filter are called PF for pass-filter. According to Illumina, chastity is defined as the ratio of the brightest base intensity divided by the sum of the brightest and second brightest base intensities. Clusters of reads pass the filter if no more than 1 base call has a chastity value below 0.6 in the first 25 cycles. This filtration process removes the least reliable clusters from the image analysis results. We used fastq_illumina_filter to remove reads which failed to pass the chastity filter. 

## Remove adapters and contaminants

- The viral genome of phiX is used as a control in Illumina sequencing. While the viral libraries do not have MIDs on them, some phiX reads always creep through, possibly because the clusters “borrow” the signals from closely surrounding clusters that do. We removed these phiX reads.

- Adapter sequences should be removed from reads because they interfere with downstream analyses, such as alignment of reads to a reference. The adapters contain the sequencing primer binding sites, the index sequences, and the sites that allow library fragments to attach to the flow cell lawn. We trimmed Illumina Truseq and Nextera adapters sequences from reads sequence. 

## Quality filtering

We proceed base trimming and read discarding based on quality phred score information provided by `fastq` files with the program fastp.

Modify the fastp section of the [config file](tiny_config.yaml) to change default parameters

```
fastp:
  n_base_limit: 0
  qualified_quality_phred: 18
  unqualified_percent_limit: 40
  length_required: 76
  cut_tail_window_size: 4
  cut_tail_mean_quality: 18
  poly_g_min_len: 10
```
### IUPAC ambiguous base calling removal
We Removed reads with more than 0 `N` bases
```
n_base_limit: 0
```

### Quality trimming


In the context of sequencing, Phred-scaled quality scores are used to represent how confident we are in the assignment of each base call by the sequencer. The Phred quality score _`(Q)`_ is logarithmically related to the error probability _`(E)`_.

_`Q = -10 \log E `_

Here is a table of how to interpret a range of Phred Quality Scores. 

| Phred Quality Score | Error  | Accuracy (1 - Error) | 
| ------------------- | ------ | -------------------- |
| 10                  | 10%    | 90%                  |
| 20                  | 1%     | 99%                  |
| 30                  | 0.1%   | 99.9%                |
| 40                  | 0.01%  | 99.99%               |    

- We filtered bases with Phred Quality Score under 18 and we discard a reads when at least 40% of these bases have a Phred Quality Score under 18.
- We trimmed from 3' tail of the reads windows of 4 bases with mean Phred Quality Score below 18.
```
qualified_quality_phred: 18
unqualified_percent_limit: 40
cut_tail_window_size: 4
cut_tail_mean_quality: 18
```

### polyG tail trimming
We trimmed 3' tail polyG sequences with a length greater than 10 bases from reads sequence.
``` 
poly_g_min_len: 10
```


### Length filtering
We removed trimmed reads with a length below 76 bases.
```
length_required: 76
```


# Running the pipeline

To do a test on tiny data
```
snakemake -s 00-scripts/snakefile -j 8 --use-singularity --configfile 01-infos/tiny_config.yaml
```

Run the pipeline on _diplodus Sargus_ `fastq` raw data
```
snakemake -s 00-scripts/snakefile -j 8 --use-singularity --configfile 01-infos/diplodus_rawdata_config.yaml
```
