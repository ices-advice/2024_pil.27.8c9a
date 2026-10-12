# Script information ------------------------------------------------------

# Title: Stock assessment and short term forecast for pil.27.8c9a (WGHANSA)
#        4) Prepare tables and figures for the report

# Before running the script in folder output we have: 
#         XXXX
# After running the script in folder report we have: 
#         XXXX

# Authors: Laura Wise (lwise@ipma.pt)
# Date: 2024


# Load libraries ----------------------------------------------------------

library(icesTAF)

# Working directory and folders -------------------------------------------

#check working directory

getwd()

# create model folder and subfolders using the function mkdir from icesTAF

mkdir("report")
mkdir("report/run")
mkdir("report/retro")
mkdir("report/stf")

# Create report figs and tabs ---------------------------------------------

source("report_01_run.R")
source("report_02_retro.R")
source("report_03_stf.R")

# Session info ------------------------------------------------------------

sessionInfo()

# End of script -----------------------------------------------------------

