#!#!/usr/bin/env python3

import subprocess, sys, os

    #   MAIN FUNCTION
def main(reads, output, savename, build, humandb, globdir, reference=None):
    #   CHECK FILE PATHS
    if output[-1] != "/":
        output += "/"
    # reference file is valid
    if reference and not os.path.isfile(reference):
        raise ValueError(f"Provided reference file does not exist :{reference_file}")

    #   RUN R FILTER SCRIPTS
    try:
        print("###############     SUMMARISING REPEAT DATA     ###############")
        cmd = [os.path.join(globdir,"Source/summaries/summaries.R"),
                               "-d", globdir,
                                "-r", reads, 
                                "-o", output,
                                 "-s", savename,
                                "-b",build,
                                "-H", humandb]
        if reference:
            cmd.extend(["-R",reference])
            
        subprocess.check_call(cmd, shell=False)
        print(savename + " summary files can be found in directory: " + output)
    except:
        sys.exit(print("Error:	Failed to summarize repeat data"))

