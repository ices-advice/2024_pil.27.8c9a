# Script information ------------------------------------------------------

# generate the outputs from stock assessment for pil.27.8c9a 

# Authors: Laura Wise (lwise@ipma.pt)

# Date: 2024

# Load packages -----------------------------------------------------------

library(icesTAF)
library(r4ss)
library(tidyverse)
library(lubridate)

# Setup and read in files -----------------------------------------------------

# set assessment year (interim year)

ass.yr <- lubridate::year(Sys.Date())

# directory with output files

dir.spaly <- file.path("model/run")

# directory to save plots and tables

res.plots <- file.path("output/run")

# read in ss3 files 

inputs <- r4ss::SS_read(dir = dir.spaly, verbose = TRUE)

# Create the standard ss3 plots -----------------------------------------------

spaly <- r4ss::SS_output(dir = dir.spaly,forecast=FALSE)

r4ss::SS_plots(replist = spaly, dir = res.plots)

# End of script -----------------------------------------------------------

rm(list=ls())




