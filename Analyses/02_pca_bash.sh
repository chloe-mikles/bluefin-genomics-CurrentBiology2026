#!/bin/bash
#SBATCH --job-name=pca
#SBATCH --account=bblock
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --time=24:00:00
#SBATCH --mem=64G
#SBATCH --cpus-per-task=2
#SBATCH --partition=batch
#SBATCH --output=pca_%j.out
#SBATCH --error=pca_%j.err
#SBATCH --mail-type=Fail,End
#SBATCH --mail-user=csmikles@stanford.edu

# Load R module (if needed)
module load R/4.3.0

# Run R script
Rscript pca_analysis.R
