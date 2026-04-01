import os

import sys


#module load legacy/.base
#module load legacy/scg4

reads_dir = sys.argv[1]

for r,dirs,files in os.walk(sys.argv[1]):

    for file in files:
        if file.endswith("_RG.bam"):
            fullid =file.split("_RG")[0]

            out = open("tmp.sbatch",'w')

            out.write("#!/bin/bash" + "\n")

            out.write("#SBATCH --job-name=HaplotypeCaller-%s" % fullid+ "\n") 

            out.write("#SBATCH --partition batch" + "\n")

            out.write("#SBATCH --account bblock" + "\n")

            out.write("#SBATCH --ntasks=1" + "\n")

            out.write("#SBATCH --cpus-per-task=3" + "\n")

            out.write("#SBATCH -t 48:00:00" + "\n")

            out.write("#SBATCH --mem 48000" + "\n")

            out.write("\n")

            cmd = "java -jar /scg/apps/legacy/gatk/gatk-3.8/GenomeAnalysisTK.jar -T HaplotypeCaller -R Thunnus_thynnus_Haplotype1_Scaffolds_all.fasta -nct 24 -mmq 30 --emitRefConfidence GVCF -I %s_RG.bam -o %s.g.vcf" % (fullid, fullid)
         
            out.write(cmd)

            out.close()

            os.system("sbatch tmp.sbatch")



            #code you will enter in terminal: 
            # python script.py ./ 
   
