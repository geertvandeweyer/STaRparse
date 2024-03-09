#!#!/usr/bin/env python3

import subprocess, sys, os

    #   MAIN FUNCTION
def main(reads, output, savename, build, humandb, globdir):
    #   CHECK FILE PATHS
    if output[-1] != "/":
        output += "/"

    #   RUN R FILTER SCRIPTS
    try:
        print("###############     SUMMARISING REPEAT DATA     ###############")
        subprocess.check_call([os.path.join(globdir,"Source/summaries/summaries.R"),
                               "-d", globdir,
                                "-r", reads, 
                                "-o", output,
                                 "-s", savename,
                                "-b",build,
                                "-h", humandb], shell=False)
        print(savename + " summary files can be found in directory: " + output)
    except:
        sys.exit(print("Error:	Failed to summarize repeat data"))

