# Script information ------------------------------------------------------

# generate the tabs & figs for the report for pil.27.8c9a (WGHANSA 2022)

# Authors: Laura Wise (lwise@ipma.pt)

# Date: 2024/11/21

# Load packages -----------------------------------------------------------

library(tidyverse)
library(gt)

# Load data ---------------------------------------------------------------

#load reference points
load("./boot/initial/data/pil278c9a_refPoints.RData")


load("./output/stf/STF_pil27.8c9a.RData") 

# table for report
tbl_stf_inputs <- bind_cols(Age=c(0:6),
          Numbers=as.vector(pil.stock_stf@stock.n[,ac(final_year)]),
          'Stock weights'=as.vector(pil.stock_stf@stock.wt[,ac(final_year)]),
          'Catch weights'=as.vector(pil.stock_stf@catch.wt[,ac(final_year)]),
          Maturity=round(as.vector(pil.stock_stf@mat[,ac(final_year)]),3),
          M=as.vector(pil.stock_stf@m[,ac(final_year)]),
          F=round(as.vector(pil.stock_stf@harvest[,ac(final_year)]),3))%>%
  gt::gt()%>%
  gt::tab_header(
    title = paste0('Year = ',final_year))%>%
  gt::tab_source_note(
    source_note = paste0("Recruitment in ",final_year+1," = ",round(mean_rec,0)))%>%
  gt::tab_source_note(
    source_note = paste0("Stock weights, catch weights, maturity and mortality are the same as in ", final_year))

colnames(stf_final) <- c("B2024","F2024","Catch2024","B2025","F","Catch2025","B2026","Catch2026","ChangeB","ChangeC","ChangeA","ChangeQ")

stf_table <- stf_final%>%
  filter(F == pil278c9a_ref.pts$Fpa #Fpa = adopted Fmsy scenario
         | F == pil278c9a_ref.pts$Flim #Flim scenario
         | F == stf_final[which.min(abs(stf_final[ , 7] - pil278c9a_ref.pts$Blim)),'F'] #F scenario that will lead to Blim in final_year+2
         | F == stf_final[which.min(abs(stf_final[ , 7] - pil278c9a_ref.pts$Bpa)),'F'] #F scenario that will lead to Bpa in final_year+2
         | round(Catch2025) %in% c(30000,35000,40000,45000,50000) #F scenarios that will lead to HCR with cap
         | F == Ftg #F scenario of the HCR without any cap
         | F == Fstatus_quo #F scenario where F equal status quo in final_year
           )

tbl_stf_outputs <- stf_table[,c(6,5,7:9,12:11)]%>%
  gt::gt()%>%
  gt::tab_header(
    title= "B1+ 2025 = 453 035 tonnes; Catch 2024 = 46 095 tonnes ; F 2024 = 0.104")%>%
  gt::cols_label(
    F = gt::html("F (2025)"),
    Catch2025 = gt::html("Catch (2025)"),
    B2026 = gt::html("Biomass 1+ (2026)"),
    ChangeB = gt::html("% Biomass 1+ change"),
    ChangeA = gt::html("% Advice change"),
    ChangeQ = gt::html("% Quota change")
  )%>%
  gt::tab_footnote(
    footnote = gt::md("Biomass 1+ in 2026 relative to Biomass 1+ in 2025 (453 035 tonnes)."),
    locations = gt::cells_column_labels(
      columns = ChangeB))%>%
  gt::tab_footnote(
    footnote = gt::md("Advised catches in 2025 compared to sum quotas in SP+PT in 2024 (44 450 tonnes)"),
    locations = gt::cells_column_labels(
      columns = ChangeA))%>%
  gt::tab_footnote(
    footnote = gt::md("Advised catches in 2025 compared to advised catches in 2024 (38 992 tonnes)"),
    locations = gt::cells_column_labels(
      columns = ChangeQ))%>%
  gt::fmt_number(columns = starts_with("B"),decimals = 0,use_seps = F)%>%
  gt::fmt_number(columns = starts_with("C"),decimals = 0,use_seps = F)%>%
  gt::fmt_number(columns = starts_with("F"),decimals = 3,use_seps = F)


# For new sub-section of STF section in report


inputForecastNew <- as.data.frame(tbl_stf_inputs)%>%mutate(Year = final_year)

tables_template <- new.env()
#load("D:/GitHUB/ices-taf/2023_pil27.8c9a_assessment/report/tablesSTF.RData", envir = tables_template)
load("C:/Users/Laura Wise/Documents/ices-taf/2023_pil27.8c9a_assessment/report/tablesSTF.RData", envir = tables_template)

inputForecastOld <- with(tables_template,as.data.frame(tbl_stf_inputs))
inputForecastOld$Year <- final_year-1

# Table and Figure that compares forecast inputs of previous year and this year
inputs <-
  bind_rows(inputForecastNew,inputForecastOld) %>%
  mutate_all(as.numeric) %>%
  mutate(Numbers = as.numeric(Numbers)/1e6)%>%
  pivot_longer(cols= 2:7,names_to = 'Variable',values_to = 'Value')%>%
  filter(Variable !='M')%>%
  mutate(Year = as.factor(Year),
         Variable = factor(Variable,levels=c('Numbers','Stock weights','Catch weights','Maturity','F')))

inputs%>%ggplot(aes(x=Age,y=Value,group=Year,colour=Year))+
  geom_line()+
  facet_grid(Variable ~ ., scales = 'free_y')+
  theme_bw()
ggsave('./report/stf/compareForecastInputs.png')


load("C:/Users/Laura Wise/Documents/ices-taf/2023_pil27.8c9a_assessment/output/stf/STF_pil27.8c9a.RData", envir = tables_template)

# Table and Figure that compares forecast of previous year natage in TAC year with
# this year assessment natage in intermediate yera (final year of assessment)

pil.stockOld <- with(tables_template,pil.stock_fwd)
natage <- data.frame(Age = 0:6,Assessment = inputForecastNew$Numbers,Forecast=as.vector(round(stock.n(pil.stockOld)[,ac(final_year)],0)))

natage%>%
gt::gt()%>%gt::gtsave("./report/stf/tab_NageAssessment_Forecast.rtf")

natage%>%
  mutate_all(as.numeric) %>%
  pivot_longer(cols=-1,names_to = 'Type',values_to = 'Numbers')%>%
  mutate(Numbers = as.numeric(Numbers)/1e6)%>%
  ggplot(aes(Age,Numbers,colour=Type)) + geom_line()+
  theme_bw()
ggsave('./report/stf/compareNatage.png')


stfOld <- with(tables_template,stf_final)

tribble(
  ~Variable, ~Year, ~LastYear, ~ThisYear,
  "Recruitment", "Intermediate", as.numeric(stock.n(pil.stockOld)[1,ac(final_year-1)]), as.numeric(stock.n(pil.stock_fwd)[1,ac(final_year)]),
  "Recruitment", "TAC", as.numeric(stock.n(pil.stockOld)[1,ac(final_year)]), as.numeric(stock.n(pil.stock_fwd)[1,ac(final_year+1)]),
  "Catch", "Intermediate", as.numeric(catch(pil.stockOld)[1,ac(final_year-1)]), as.numeric(catch(pil.stock_fwd)[1,ac(final_year)]),
  "Catch", "TAC", round(stfOld$Catch_2024[stfOld$F==pil278c9a_ref.pts$Fpa],0), round(stf_final$Catch2025[stf_final$F==pil278c9a_ref.pts$Fpa],0),
  "F target", "Intermediate", as.numeric(icesAdvice::icesRound(fbar(pil.stockOld)[,ac(final_year-1)])), as.numeric(icesAdvice::icesRound(fbar(pil.stock_fwd)[1,ac(final_year)])),
  "F target", "TAC", pil278c9a_ref.pts$Fpa, pil278c9a_ref.pts$Fpa
        )%>%
  gt::gt()%>%gt::gtsave("./report/stf/tab_compareRecCatchF.rtf")

# Table comparing natage from old assessment and new assessment
nbrs <- as.data.frame(round(drop(stock.n(pil.stock_fwd)[,ac((final_year-3):(final_year-1))]/stock.n(pil.stockOld)[,ac((final_year-3):(final_year-1))]),2))
bio <- as.data.frame(round(drop((stock.n(pil.stock_fwd)[,ac((final_year-3):(final_year-1))]*stock.wt(pil.stock_fwd)[,ac((final_year-3):(final_year-1))])/(stock.n(pil.stockOld)[,ac((final_year-3):(final_year-1))]*stock.wt(pil.stockOld)[,ac((final_year-3):(final_year-1))])),2))

bind_cols(nbrs,bio)%>%
  gt::gt()%>%gt::gtsave("./report/stf/tab_newOldAssessment.rtf")

save(tbl_stf_inputs, tbl_stf_outputs, stf_table, inputs, natage, rec, file="report/stf/tablesSTF.RData")

# End of script -----------------------------------------------------------

rm(list=ls())

