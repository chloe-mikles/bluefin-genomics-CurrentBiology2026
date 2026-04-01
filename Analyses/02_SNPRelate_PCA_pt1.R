#Chloe Mikles
##PCA for whole genome resequencing 
##ABFT WGS

#note*** this first part is run in SCG to generate genofile, PCA coords file, missing.txt

############################
#Using R in terminal for PCA#
############################


#Load R on computing cluster. 
if (!requireNamespace("BiocManager", quietly = TRUE))
  install.packages("BiocManager")
BiocManager::install("SNPRelate")

#Libraries needed
library(dplyr)
library(ggplot2)
library(SNPRelate)
library(data.table)

## add info on samples (sample ID, subspecies)
abft_info <- read.table("samples_ids.txt",sep=" ",header=TRUE)

## load SNP from .vcf file in working directory
## vcf.fn = input vcf file
## out.fn = output .gds name
snpgdsVCF2GDS(vcf.fn="ABFT_FilteredMerged_WGS_Data_Aug_2025.vcf", out.fn="abft_full_08182025.gds",method = c("biallelic.only"),compress.annotation="ZIP.max", snpfirstdim=FALSE, verbose=TRUE)

## opens the .gds file
genofile <- snpgdsOpen("./abft_full_08182025.gds")

## summarizes the info in the .gds file (num of individuals, num of SNPs)
snpgdsSummary("./abft_full_08182025.gds", show=TRUE)
# number of SNPs

#missing data
miss <- snpgdsSampMissRate(genofile, sample.id=NULL, snp.id=NULL, with.id=TRUE)
miss <- as.data.frame(miss)
miss <- setDT(miss,keep.rownames=TRUE)[]
write.table(miss, "PCA_missing1.txt", sep="\t", quote=F, row.names = T)

colnames(miss) <- c("ID","missing")
#miss2$ID <- as.numeric(miss2$ID) (only use this if the sample names are numeric)
miss_merge <- merge(miss,abft_info,by="ID")
miss_output <- select(miss_merge,ID,missing)
write.table(miss_merge,"WGSNP_new_missing.txt",sep="\t",quote=FALSE,row.names=TRUE)



#Runs PCA with all samples
pca <- snpgdsPCA(gdsobj = genofile,autosome.only=FALSE)


#Get PC percentages
pc.percent <- pca$varprop*100
head(pc.percent)


## pull sample ID + first four PC axes
pca_coords <- data.frame(ID = pca$sample.id,
                         pc1 = pca$eigenvect[,1],    # the first eigenvector
                         pc2 = pca$eigenvect[,2],    # the second eigenvector
                         pc3 = pca$eigenvect[,3],
                         pc4 = pca$eigenvect[,4],
                         stringsAsFactors = FALSE)
write.table(pca_coords,"ABFT_Aug19_2025_PCAcoords.txt",sep="\t",quote=FALSE,row.names=TRUE)


