import os

import sys



reads_dir = sys.argv[1]

for r,dirs,files in os.walk(sys.argv[1]):

    for file in files:
        if file.endswith(".bam"):
            fullid = os.path.splitext(file)[0]

            out = open("tmp.sbatch",'w')

            out.write("#!/bin/bash" + "\n")

            out.write("#SBATCH --job-name=Qualimap-%s" % fullid+ "\n") 

            out.write("#SBATCH --partition batch" + "\n")

            out.write("#SBATCH --account bblock" + "\n")

            out.write("#SBATCH --ntasks=1" + "\n")

            out.write("#SBATCH --cpus-per-task=3" + "\n")

            out.write("#SBATCH -t 12:00:00" + "\n")

            out.write("#SBATCH --mem 24000" + "\n")

            out.write("\n")

            cmd = "qualimap bamqc -bam %s.bam -outfile %s.pdf" % (fullid, fullid)

            out.write(cmd)

            out.close()

            os.system("sbatch tmp.sbatch")



            #code you will enter in terminal: 
            # python script.py ./ 
