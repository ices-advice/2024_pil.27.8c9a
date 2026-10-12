# Script information ------------------------------------------------------

# run stock assessment for pil.27.8c9a 
# settings: spaly

# Authors: Laura Wise (lwise@ipma.pt)

# Date: 2024

# Load packages -----------------------------------------------------------
library(icesTAF)
library(r4ss)

# Get input files --------------------------------------------------------

cp("boot/data/sardine.dat", "model/run")
cp("boot/data/sardine.ctl", "model/run")
cp("boot/data/forecast.ss", "model/run")
cp("boot/data/starter.ss", "model/run")
cp("boot/data/wtatage.ss", "model/run")

# Get model executable ----------------------------------------------------
cp("boot/software/ss3.exe", "model/run")

# Save main directory
wd <- "~/ices-taf/2024_pil27.8c9a_assessment"

# Run SS from r (need to change directory to run SSs)
setwd("model/run")

system("./ss3.exe")

setwd(wd)
 
#setwd(rprojroot::find_rstudio_root_file())

# End of script -----------------------------------------------------------

rm(list=ls())

