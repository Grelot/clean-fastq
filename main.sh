snakemake -s 00-scripts/snakeMake -j 8 --singularity-args "-B .:/workf,/entrepot/donnees/seaconnect/gbs_diplodus/tiny/:/02-raw" --use-singularity