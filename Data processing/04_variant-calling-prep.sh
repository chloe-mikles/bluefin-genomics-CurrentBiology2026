###########################
##Variant Calling in GATK
##Bam files from mapping script above are indexed and sorted already
##Calling variants in all subspecies mapped to SOSP
##########################

##Prepare the genome for GATK: index it (fai and dict files)
java -Xmx48g -jar /programs/picard-tools-2.8.2/picard.jar CreateSequenceDictionary R= Thunnus_thynnus_Haplotype1_Scaffolds_all.fasta O= ABFT_RefGen.dict 
samtools faidx ABFT_RefGen.fasta

################################
# add read group information
# use samtools view -H sample.bam | grep '@RG' 
# samtools command above will print required fields for the AddOrReplaceReadGroups below
################################
module load legacy/.base
module load legacy/scg4
#

module load java/17.0.6
module load picard

#For each individual: RGPU is unique to each sample. Run "picard_AddOrReplaceReadGroups.sh", 10 samples at a time. 
picard AddOrReplaceReadGroups INPUT=DUP-1.bam OUTPUT=DUP-1_RG.bam RGLB=DUP-1 RGPL=illumina RGPU=AAGTCGCAAT+GTCTCAGAGT RGSM=DUP-1.bam 

  
##################
# mark duplicates#
##################

#run MarkDuplicates.py
#java -Xmx48g -jar /programs/picard-tools-2.8.2/picard.jar MarkDuplicates INPUT=MAX1toSOSP_sortedRG.bam OUTPUT=MAX1toSOSP_sortedRGmark.bam METRICS_FILE=MAX1_sort.metrics.txt MAX_FILE_HANDLES_FOR_READ_ENDS_MAP=1000 &
picard MarkDuplicates INPUT=%s_RG.bam OUTPUT=%s_sortedRGmark.bam METRICS_FILE=%s_sort.metrics.txt MAX_FILE_HANDLES_FOR_READ_ENDS_MAP=1000 #&" % (fullid, fullid, fullid)

# since running HaplotypeCaller, don't need to realign or fix mates unless there is an error in ValidateSamFile, Make sure picard.jar is in directory you are working in. May need to module load java/17.0.6
picard ValidateSamFile I=%s_sortedRGmark.bam MODE=SUMMARY #(fullid)
picard ValidateSamFile I=MED-1_sortedRGmark.bam MODE=SUMMARY

##################
# Index #
##################

# index .bam files for HaplotypeCaller
#For each individual


java -Xmx48g -jar /programs/picard-tools-2.8.2/picard.jar BuildBamIndex I=MAX1toSOSP_sortedRGmark.bam
picard BuildBamIndex I=%s_sortedRGmark.bam #% (fullid)

