# Script information ------------------------------------------------------

# Title: Stock assessment and short term forecast for pil.27.8c9a (WGHANSA)
#        4) Extract results of interest, write TAF output tables

# Before running the script in folder data we have: 
#         folders with the assessment run and the retros
# After running the script in folder model we have: 
#         folders with the corresponding outputs (including reference points)

# Authors: Laura Wise (lwise@ipma.pt)

# Date: 2024

# Load libraries ----------------------------------------------------------

library(icesTAF)

# Working directory and folders -------------------------------------------

# check working directory

getwd()

# create output folder and sub-folders using the function mkdir from icesTAF

mkdir("output")
mkdir("output/run")
mkdir("output/retro")
mkdir("output/toFLR")
mkdir("output/stf")

# Outputs from stock assessment -------------------------------------------

source("output_01_run.R")

# Outputs from retro ------------------------------------------------------

source("output_02_retro.R")

# Outputs: create FLR objects ---------------------------------------------

source("output_03_toFLR.R")

# Outputs from stf --------------------------------------------------------

source("output_04_stf.R")

# Session info ------------------------------------------------------------

sessionInfo()

# End of script -----------------------------------------------------------

rm(list = ls())