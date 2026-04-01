###########################################
###Start here in R on personal computer ####
###########################################

library(ggplot2)

pca_coords<-read.table("PCAcoordsSept52023.txt", header=T)
pca_coords
head(pca_coords)
#ID         pc1        pc2         pc3        pc4
#1 GOU11toSOSP_sorted.bam -0.06456565 0.01932665 0.009375798 0.01608592
#2 GOU12toSOSP_sorted.bam -0.07143810 0.02939813 0.010153532 0.02155620
#3 GOU13toSOSP_sorted.bam -0.06324695 0.02089875 0.006120344 0.01805042
#4 GOU14toSOSP_sorted.bam -0.06296960 0.02454635 0.008970476 0.01721452
#5 GOU15toSOSP_sorted.bam -0.06559230 0.02506620 0.008735028 0.02152418
#6 GOU16toSOSP_sorted.bam -0.06418040 0.02128104 0.007132590 0.01756640

#Manually merge PCA results w/ information about the sample, then re-import
pca_coords_merged<-read.csv("Tracks_Oct22_2024_PCAcoords_82_merged.csv", header=T)


##### PLOT PCA RESULTS #####

## read the file you outputted in the previous step
#pca <- read.table("./recodeSNPs.txt",sep="",header=TRUE)


##COLORS
plot_colors<-c("#d53e4f", "#386cb0")

pca_scatter1 <- ggplot() +
  #this line tells ggplot to plot the points comparing pc1 and pc2
  #change fill=Species to depending on how you'd like to color the points (e.g. subspecies, upland/coastal, etc.)
  #alpha changes transparency, shape=21 gives a filled circle
  geom_hline(aes(yintercept=0),color="gray") +
  geom_vline(aes(xintercept=0),color="gray") +
  geom_point(data=pca_coords_merged,aes(x=pc1,y=pc2,fill=Population, color=Population, shape=Type),
             size=6, alpha=0.75, stroke=0.2) +
  #these next two lines plot a horizontal and vertical zero line (isn't necesary, I just like the way it looks)
  #these makes the axis labels, change the percentage values to match your percent variation explained
  labs(x = "PC1 (2.58%)", y = "PC2 (2.50%)") +
  ggtitle("")+
  scale_color_manual(values=plot_colors) +
  scale_fill_manual(values=plot_colors) +
  scale_shape_manual(values=c(23, 21))+
  #this is a general theme package in ggplot2 that removes gridlines, adds thick axis lines, and makes the background white
  theme_classic() +
  #this is a long string that further customizes the theme (telling ggplot2 what colors to make the axis lines, the type of font for the axis text, etc.)
  #to see the color legend for your points, remove the first part of this line (legend.position="none",) 
  theme(axis.line.x=element_line(color="black"),axis.line.y=element_line(color="black"),  axis.title.x=element_text(face="bold",size=12),axis.title.y=element_text(face="bold",size=12),axis.text=element_text(size=10), panel.border=element_rect(color="black", fill=NA, size=1), legend.position = "right")

pca_scatter1

ggsave("PCA_82_fulldataset_Nov2024.png", dpi=600)

pca_scatter2 <- ggplot() +
  #this line tells ggplot to plot the points comparing pc1 and pc2
  #change fill=Species to depending on how you'd like to color the points (e.g. subspecies, upland/coastal, etc.)
  #alpha changes transparency, shape=21 gives a filled circle
  geom_hline(aes(yintercept=0),color="gray") +
  geom_vline(aes(xintercept=0),color="gray") +
  geom_point(data=pca_coords_merged2,aes(x=pc2,y=pc3,fill=Population, color=Population, shape=Type),size=6, alpha=0.75, stroke=0.2) +
  #these next two lines plot a horizontal and vertical zero line (isn't necesary, I just like the way it looks)
  #these makes the axis labels, change the percentage values to match your percent variation explained
  labs(x = "PC2 (1.32%)", y = "PC3 (1.26%)") +
  scale_color_manual(values=plot_colors) +
  scale_fill_manual(values=plot_colors) +
  scale_shape_manual(values=c(21, 23))+
  #this is a general theme package in ggplot2 that removes gridlines, adds thick axis lines, and makes the background white
  theme_classic() +
  #this is a long string that further customizes the theme (telling ggplot2 what colors to make the axis lines, the type of font for the axis text, etc.)
  #to see the color legend for your points, remove the first part of this line (legend.position="none",) 
  theme(axis.line.x=element_line(color="black"),axis.line.y=element_line(color="black"),  axis.title.x=element_text(face="bold",size=12),axis.title.y=element_text(face="bold",size=12),axis.text=element_text(size=10), legend.position = "right")
pca_scatter2
ggsave("PCA_84_fulldataset_PC2_3_nov202023.png", dpi=600)


pca_scatter_color_by_coverage <- ggplot() +
  #this line tells ggplot to plot the points comparing pc1 and pc2
  #change fill=Species to depending on how you'd like to color the points (e.g. subspecies, upland/coastal, etc.)
  #alpha changes transparency, shape=21 gives a filled circle
  geom_hline(aes(yintercept=0),color="gray") +
  geom_vline(aes(xintercept=0),color="gray") +
  geom_point(data=pca_coords2,aes(x=pc1,y=pc2,fill=coverage),size=6, shape=21, alpha=0.75, stroke=0.2) +
  #these next two lines plot a horizontal and vertical zero line (isn't necesary, I just like the way it looks)
  #these makes the axis labels, change the percentage values to match your percent variation explained
  labs(x = "PC1 (3.92%)", y = "PC2 (3.55%)") +
  #scale_color_manual(values=fig_colors) +
  #scale_fill_manual(values=fig_colors) +
  scale_fill_viridis_c(option = "magma" )+ 
  #limits=c(0, 6))+
  # scale_shape_manual(values=c(21, 22, 23, 24, 25))+
  #this is a general theme package in ggplot2 that removes gridlines, adds thick axis lines, and makes the background white
  theme_classic() +
  #this is a long string that further customizes the theme (telling ggplot2 what colors to make the axis lines, the type of font for the axis text, etc.)
  #to see the color legend for your points, remove the first part of this line (legend.position="none",) 
  theme(axis.line.x=element_line(color="black"),axis.line.y=element_line(color="black"),  axis.title.x=element_text(face="bold",size=12),axis.title.y=element_text(face="bold",size=12),axis.text=element_text(size=10), legend.position = "right")
pca_scatter_color_by_coverage

