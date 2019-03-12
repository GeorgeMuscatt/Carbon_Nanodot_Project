## Install Software -------------------------------
# source("http://bioconductor.org/biocLite.R")
# biocLite("flowCore")
##

## Initialise R: ##

## Load Libraries ---------------------------------
library(flowCore)
library(tidyverse)
library(mclust) 

# Set the working directory ----------------------
setwd("~/Documents/Data/Scripts/Intelligate")


## Import and pre-process data: ##

# Load FlowFrames from file into FlowSet ---------
fs <- read.flowSet(path = "~/Desktop/Project/R_Script_Full_Time_Series/R_Script_Full_Time_Series", pattern = ".fcs", alter.names = TRUE, phenoData = list(name = "SAMPLE ID", Filename = "$FIL"))

# Create Raw DataFrames --------------------------

# create empty list to hold each DataFrame 
dflist <- list(length(fs))

# loop over the FlowSet and assign a DataFrame containing the expression values to each position in the list
for (i in 1:(length(fs))) {
  dflist[[i]] <- data.frame(as.data.frame(exprs(fs[[i]])))
  dflist[[i]] <- na.omit(dflist[[i]]) # remove NA values
  for (j in 1:length(fs@colnames)) {dflist[[i]] <- dflist[[i]][dflist[[i]][,j] !="-Inf",]} # remove any "-Inf" values
}

# Create Log-transformed DataFrames --------------------------

# log-transform all channels (except time in column 1)
fs_log <- transform(fs, transformList(fs@colnames[2:16], log)) 

# create empty list to hold each DataFrame 
dflist_log <- list(length(fs_log))

# loop over the FlowSet and assign a DataFrame containing the log-transformed expression values to each position in the list
for (i in 1:(length(fs_log))) {
  dflist_log[[i]] <- data.frame(as.data.frame(exprs(fs_log[[i]])))
  dflist_log[[i]] <- na.omit(dflist_log[[i]]) # remove NA values
  for (j in 1:length(fs_log@colnames)) {dflist_log[[i]] <- dflist_log[[i]][dflist_log[[i]][,j] !="-Inf",] # removing the negative values that gave "-Inf" after log-transforming 
  dflist_log[[i]] <- dflist_log[[i]][dflist_log[[i]][,j] > 1,]} # remove outliers by only keeping expression values greater than 1
} 

