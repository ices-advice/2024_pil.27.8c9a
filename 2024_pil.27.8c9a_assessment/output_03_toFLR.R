# Script information ------------------------------------------------------

# create FLStock from stock assessment output for pil.27.8c9a (WGHANSA)

# Authors: Laura Wise
# Date: 2024

# Load libraries --------------------------------------------------------------

library(ss3om)
library(tidyverse)

# Load FLR object from folder containing the output of the SS3 run ------------

dir <- "model/run"

ass.yr <- lubridate::year(Sys.Date())

# To create an FLStock object from a model run, we can call function readFLSss3

pil.stock <- ss3om::readFLSss3(dir, name = "pil.27.8c9a", desc = paste0('Advice for ', ass.yr+1))

out <- readOutputss3(dir, repfile = "Report.sso", compfile = "CompReport.sso")

# Changes needed  -------------------------------------------------------------

#mat(pil.stock) <- (mat(pil.stock)*catch.wt(pil.stock))/stock.wt(pil.stock)

mat(pil.stock)[1,] <- 0.0 #to remove NA's

# for the STF we assume that maturity in the last year is the mean of the last 6 years
mat(pil.stock)[,ac(out$endyr)] <- rowMeans(mat(pil.stock)[,ac((out$endyr-6):(out$endyr-1))])

# Min, Max Fbar

pil.stock@range[['minfbar']] <- 2
pil.stock@range[['maxfbar']] <- 5

# Harvest should take in consideration Fbar

selectivity <- out$ageselex%>%
  dplyr::filter(Fleet == 1 & Factor == "Asel2" & Yr %in% out$startyr:out$endyr)%>%
  dplyr::select("Yr",matches("[0-9]+"))

f.apical <- out$derived_quants%>%
  dplyr::filter(grepl("F_\\d", Label))%>%
  dplyr::select(Label,Value)%>%
  tidyr::separate(Label, into = c("Variable","Yr"),sep = "_",remove = TRUE,extra="drop")

harvest <- f.apical$Value*selectivity[,c("0","1","2","3","4","5","6")]%>%
  dplyr::mutate(refF = rowMeans(dplyr::select(.,"2","3","4","5")))
harvest$Year <- f.apical$Yr

harvest=FLQuant(unname(as.matrix(t(harvest[,-c(8:9)]))),quant="age",units="f")
dimnames(harvest)[[2]]=as.character(out$startyr:(out$endyr))
dimnames(harvest)[[1]]=as.character(min(out$agebins):max(out$agebins))

harvest(pil.stock) <- harvest

units(m.spwn(pil.stock)) <- "f"

# Discards.wt should be zero
discards.wt(pil.stock) <- discards.n(pil.stock)

# save the objects created ------------------------------------------------

save(pil.stock, file="output/toFLR/pilStock.RData")

# End of script -----------------------------------------------------------

rm(list = ls())


