# clean-fastq
A workflow designed to clean fastq files for the SEACONNECT project



# remove PHIX

The viral genome of phiX is used as a control in Illumina sequencing. While the viral libraries do not have MIDs on them, some phiX reads always creep through, possibly because the clusters “borrow” the signals from closely surrounding clusters that do. These phiX reads need to be removed.

