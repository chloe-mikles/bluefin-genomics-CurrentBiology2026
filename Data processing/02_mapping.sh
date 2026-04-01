#!/bin/bash

# Define the prefix
prefix="GOM"

# Reference genome
ref_genome="/labs/bblock/csm245/23059Bbl/23059Bbl_N23101/Thunnus_thynnus_Haplotype1_Scaffolds_all.fasta"

# Output directory
output_dir="/labs/bblock/csm245/23059Bbl/23059Bbl_N23101/"

# Create output directory if it doesn't exist
mkdir -p $output_dir

# Find all files starting with "Bal"
for sample_file in /labs/bblock/csm245/23059Bbl/23059Bbl_N23101/${prefix}*_trimmed_R1.fastq.gz
do
    # Extract the sample name (e.g., Bal1, Bal2, etc.)
    sample=$(basename $sample_file _trimmed_R1.fastq.gz)
    
    # Create a temporary SBATCH script
    cat << EOF > tmp_${sample}.sbatch
#!/bin/bash
#
#SBATCH --job-name=Align_${sample}
#SBATCH --account=bblock
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --partition=batch
#SBATCH --time=48:00:00
#SBATCH --mail-type=FAIL,END
#SBATCH --mail-user=csmikles@stanford.edu

# Load BWA and Samtools modules
module load bwa
module load samtools

# Step 2: Map reads using BWA with cleaned fastp output
bwa mem -t 16 -M -R "@RG\tID:${sample}\tSM:${sample}" ${ref_genome} \
/labs/bblock/csm245/23059Bbl/23059Bbl_N23101/${sample}_trimmed_R1.fastq.gz \
/labs/bblock/csm245/23059Bbl/23059Bbl_N23101/${sample}_trimmed_R2.fastq.gz \
> ${output_dir}/${sample}.sam

# Step 3: Convert SAM to BAM and sort it
samtools view -bS ${output_dir}/${sample}.sam > ${output_dir}/${sample}.bam
samtools sort ${output_dir}/${sample}.bam -o ${output_dir}/${sample}_sorted.bam

# Step 4: Index the sorted BAM file
samtools index ${output_dir}/${sample}_sorted.bam

# Step 5: Cleanup
rm ${output_dir}/${sample}.sam
rm ${output_dir}/${sample}.bam  # Remove the unsorted BAM file
EOF

    # Submit the job
    sbatch tmp_${sample}.sbatch

    # Remove the temporary script
    rm tmp_${sample}.sbatch
done


#commit w chmod +x "file name" - run with ./"filename"
