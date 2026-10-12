# Script information ------------------------------------------------------

# run retrospective analysis for pil.27.8c9a 

# Authors: Laura Wise (lwise@ipma.pt)

# Date: 2024

# Load packages -----------------------------------------------------------

library(r4ss)
library(icesTAF)
library(lubridate)

# Run retrospective analysis ----------------------------------------------

# copy files to the retro directory --

retro_dir <- "./model/retro"

r4ss::copy_SS_inputs(dir.old = "./model/run", dir.new = retro_dir,overwrite = TRUE) # copy over the stock synthesis model

# copy ss3 to the retro directory --

# Get model executable --
icesTAF::cp("boot/software/ss3.exe", "model/retro")

# do retros from the current year to -5 --
# this creates and runs all the retros

r4ss::retro(dir = retro_dir, oldsubdir = "", newsubdir = "", 
           years = 0:-5,exe = "ss3.exe")

# Set ass.yr
ass.yr <- year(Sys.Date())

# Change files of retros because automatic retro is not appropriate for our case --
# Were we have survey data until the interim year (y+1) and fishing mortality until the previous year (y).
# use function setRetros

setRetros <- function(dir.retro, ass.yr,retro){
  
  wd <- getwd()
  
  retro.yr <- ass.yr-as.numeric(substr(retro,7,7))
  
  # read input files 
  inputs <- r4ss::SS_read(dir = paste0("model/retro/",retro), verbose = TRUE)
  
  # change retro_yr to 0
  inputs$start$retro_yr <- 0
  
  #Save starter file
  SS_writestarter(inputs$start,dir=file.path(retro_dir,retro),overwrite=TRUE)
  
  # Change last year of data in the data file
  inputs$dat$endyr <- retro.yr
  
  # update Catch data
  inputs$dat$catch <- inputs$dat$catch[inputs$dat$catch$year <= retro.yr,] 
  
  # update CPUE data
  inputs$dat$CPUE <- inputs$dat$CPUE[inputs$dat$CPUE$year <= retro.yr,]
  
  #update age composition
  inputs$dat$agecomp <- inputs$dat$agecomp[inputs$dat$agecomp$year <= retro.yr,]
  inputs$dat$agecomp[length(inputs$dat$agecomp$year[inputs$dat$agecomp$fleet==1]),c("a0","a1","a2","a3","a4","a5","a6")] <- inputs$dat$agecomp[length(inputs$dat$agecomp$year[inputs$dat$agecomp$fleet==1])-1,c("a0","a1","a2","a3","a4","a5","a6")]
  inputs$dat$agecomp$fleet[inputs$dat$agecomp$year == retro.yr][1] <- -1
  
  r4ss::SS_writedat_3.30(inputs$dat,outfile = file.path(retro_dir,retro,"sardine.dat"),overwrite=TRUE,verbose=TRUE)
  
  #update block design
  inputs$ctl$Block_Design[[1]][4] <- retro.yr
  
  #update Main recruitment deviation Last year
  inputs$ctl$MainRdevYrLast <- retro.yr
  
  #update stdev_reporting specifications
  inputs$ctl$stddev_reporting_specs[8] <- retro.yr
  
  r4ss::SS_writectl_3.30(inputs$ctl,outfile = file.path(retro_dir,retro,"sardine.ctl"),overwrite = TRUE,verbose=TRUE)
  
  # Delete previous Report.sso file
  file.remove(paste0("model/retro/",retro,"/Report.sso"))
  
  #Run model with updated files
  
  r4ss::run(dir = paste0("model/retro/",retro),exe = "ss3.exe",show_in_console = T,verbose = T)

  #Check if model converged
  spaly <- r4ss::SS_output(dir = paste0("model/retro/",retro),forecast=FALSE)
  
  if (spaly$log_det_hessian>0){
    cat("TRUE \n")
  } else
    
  {
    #change the N iterations for tuning F in hybrid method
    inputs <- r4ss::SS_read(dir = paste0("model/retro/",retro), verbose = TRUE)
    
    inputs$ctl$F_iter <- inputs$ctl$F_iter + 1
    r4ss::SS_writectl_3.30(inputs$ctl,outfile = file.path(retro_dir,retro,"sardine.ctl"),overwrite = TRUE,verbose=TRUE)
    

    # Delete previous Report.sso file
    file.remove(paste0("model/retro/",retro,"/Report.sso"))
    
    #Run model with updated files
    r4ss::run(dir = paste0("model/retro/",retro),exe = "ss3.exe",show_in_console = T,verbose = T)
  }
  
  cat("Run Next retro \n")
}

setRetros(dir.retro = retro_dir,ass.yr = ass.yr,"retro-1")
setRetros(dir.retro = retro_dir,ass.yr = ass.yr,"retro-2")
setRetros(dir.retro = retro_dir,ass.yr = ass.yr,"retro-3")
setRetros(dir.retro = retro_dir,ass.yr = ass.yr,"retro-4")
setRetros(dir.retro = retro_dir,ass.yr = ass.yr,"retro-5")

# End of script -----------------------------------------------------------

rm(list=ls())

