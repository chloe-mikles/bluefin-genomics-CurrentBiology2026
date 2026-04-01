#!/bin/bash
#
#SBATCH --job-name=Trimming_with_fastp
#SBATCH --account=bblock
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --partition=batch
#SBATCH --time=23:00:00
#SBATCH --mail-type=FAIL,END
#SBATCH --mail-user=csmikles@stanford.edu

ml load fastp

# Specify the path to the directory containing the files
directory="/labs/bblock/csm245/24161Bbl/24161Bbl_N24101/Combined/SlopeSea"

# Set the common suffixes for the input files
suffix1="_combined_R1.fastq.gz"
suffix2="_combined_R2.fastq.gz"

# Loop through the files in the directory
for file1 in "$directory"/*"$suffix1"; do
  # Check if the corresponding file2 exists
  file2="${file1%"$suffix1"}$suffix2"
  if [ -f "$file2" ]; then
    # Extract the input prefix
    input_prefix="${file1%"$suffix1"}"

    echo "Running fastp on files: $file1 and $file2"
    
    # Run fastp on each pair of files
    fastp -i "$file1" -I "$file2" \
          -o "${input_prefix}_trimmed_R1.fastq.gz" \
          -O "${input_prefix}_trimmed_R2.fastq.gz" \
          --trim_front1 5 \
          --trim_front2 5 \
          --cut_front \
          --cut_tail \
          --qualified_quality_phred 10 \
          --length_required 50 \
          --dedup \
          --thread 8 \
          --json "${input_prefix}_fastp.json" \
          --html "${input_prefix}_fastp.html"
    
    # Optional: You can add any additional commands you need here
  else
    echo "Warning: Corresponding file $file2 does not exist."
  fi
done
