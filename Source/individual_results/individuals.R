#!/usr/bin/env Rscript

#       IMPORT LIBRARIES
suppressPackageStartupMessages(library(optparse))
suppressPackageStartupMessages(library(reshape2))
suppressPackageStartupMessages(library(dplyr))
suppressPackageStartupMessages(library(plyr))

#       DEFINE ARGUMENTS FOR SCRIPT
option_list <- list(
  make_option(c("-d", "--dir"), type="character", action="store", default=NA, help="Path of global directory", metavar="character"),
  make_option(c("-r", "--reads"), type="character", action="store", default=NA, help="Read file path", metavar="character"),
  make_option(c("-o", "--out"), type="character", action="store", default=NA, help="output file path and name", metavar="character"),
  make_option(c("-s", "--savename"), type="character", action="store", help="Indicate job name", metavar="character"),
  make_option(c("-R", "--reference"), type="character", action="store", help="Previously built Reference file", metava="character", default=FALSE),
  make_option(c("-S","--min_sd"), type="integer", action="store", help="Nr. of SD deviations from mean length", metavar="int", default=3),
  make_option(c("-D","--min_diff"), type="integer", action="store", help="Nr. of repeat units from mean length", metavar="int", default=3),
  make_option(c("-L","--min_length"), type="integer", action="store", help="Minimum length of repeat", metavar="int", default=25)
)

opt <- parse_args(OptionParser(option_list=option_list))

#       ARGUMENT CHECK
if (length(opt) != 9){
  stop("Please ensure all aruments are supplied", call.=FALSE)
} 
## small routine, put all code in main. 
## CREATE PER SAMPLE FILTERED LIST OF ANNOTATED REPEATS
output = paste0(opt$out, opt$savename)
# read in (filtered) experimental data:
df = read.csv(file=opt$reads, sep="\t", header = TRUE)
names(df) <- c("Call_ID", "Sample_ID", "Chr", "Start", "End", "GT", "Ref_Units", "All1", "All2")
# read in precompute reference data
ref = read.csv(file=opt$reference, sep="\t", header = TRUE)
# merge both
df <- merge(df, ref[c("Call_ID", "Med_Units", "Mean_Units", "SD","Instability_Rating","Status", "Gene", "Region")], by="Call_ID")
write.table(df, paste0(output, "_all_samples_full.csv"), sep="\t",col.names = TRUE, row.names = FALSE, quote = FALSE)


# assign a large SD to SD == NA
df$SD[is.na(df$SD)] <- 100000

# select significant rows in df WHERE either : 
#   - df$All1 > min(min_length, df$Mean_Units + min_sd * df$SD)
#   - df$All2 > min(min_length, df$Mean_Units + min_sd * df$SD)

print(paste0("Extracting repeats over ",opt$min_length," units or over ",opt$min_sd,"*SD deviations or over ",opt$min_diff," units from the mean over the refset"))
df_sign = subset(df, pmax(df$All1,df$All2) > pmax(opt$min_length, df$Med_Units + opt$min_diff,df$Med_Units + opt$min_sd * df$SD))

write.table(df_sign, paste0(output, "_all_samples_hard_cutoff.csv"), quote = FALSE, col.names = TRUE, row.names = FALSE, sep="\t")

# create output files per sample: 
for (sample in unique(df$Sample_ID)){
  df_sample = subset(df_sign, df_sign$Sample_ID == sample)
  write.table(df_sample, paste0(output, "_sign_", sample, ".csv"), quote = FALSE, col.names = TRUE, row.names = FALSE, sep="\t")
}


    

