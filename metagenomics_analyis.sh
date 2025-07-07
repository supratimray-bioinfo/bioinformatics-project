#!/bin/bash
#Quality checking of reads
fastqc SRR1647260_R1.fastq.gz SRR1647260_R2.fastq.gz
#Trimming of raw reads
Trimmomatic PE -phred33 SRR1647260_R1.fastq.gz SRR1647260_R2.fastq.gz \
paired_SRR1647260_1.fastq.gz unpaired_SRR1647260_1.fastq.gz \
paired_SRR1647260_2.fastq.gz unpaired_SRR1647260_2.fastq.gz \
ILLUMINACLIP: adapters/NexteraPE-PE. fa:2:30:10:2:true MINLEN:60
#Mapping FASTQ file to a reference database
bowtie2 -x hg/hg19 -1 paired_SRR1647260_1.fastq.gz -2 paired_SRR1647260_2.fastq.gz -
S SRR1647260.sam
#Conversion of SAM file BAM file
samtools view -bS SRR1647260.sam >  SRR1647260.bam
#Extracting unmapped reads
samtools view -b -f 4 SRR1647260.bam >  SRR1647260_unmapped.bam
#Sorting of BAM file
samtools sort -n SRR1647260_unmapped.bam -o SRR1647260_unmapped_sorted.bam
#Conversion of bam file to FASTQ files
samtools fastq -1 SRR1647260_R1.fastq -2 SRR1647260_R2.fastq -0 /dev/null -s /dev/null
-n SRR1647260_unmapped_sorted.bam
#Taxonomic profiling using Metaphlan
metaphlan SRR1647260_R1. fastq, SRR1647260_R2.fastq --input_type fasta >
SRR1647260_profile.txt -t rel_ab_w_read_stats --bowtie2out SRR1647260.bowtie2.bz2
