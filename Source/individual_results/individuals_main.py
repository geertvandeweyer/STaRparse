#!#!/usr/bin/env python3

import subprocess, sys, os

    #   MAIN FUNCTION
def main(reads, output, savename, globdir, reference):
    #   CHECK FILE PATHS
    if output[-1] != "/":
        output += "/"
    # reference file is valid
    if not os.path.isfile(reference):
        raise ValueError(f"Provided reference file does not exist :{reference}")

    #   RUN R FILTER SCRIPTS
    try:
        print("###############     EXTRACT SAMPLE REPEAT DATA     ###############")
        cmd = [os.path.join(globdir,"Source/individual_results/individuals.R"),
                               "-d", globdir,
                                "-r", reads, 
                                "-o", output,
                                "-s", savename,
                                "-R", reference,
        ]
            
        subprocess.check_call(cmd, shell=False)
        print(savename + " repeat files can be found in directory: " + output)
    except:
        sys.exit(print("Error:	Failed to extract sample-level repeat data"))

