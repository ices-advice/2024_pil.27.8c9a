# Script information ------------------------------------------------------

# Title: Stock assessment and short term forecast for pil.27.8c9a (WGHANSA)
#        1) TAF bootstrap procedure to set up required data and software

# See also: https://github.com/ices-taf/doc/wiki/Creating-a-TAF-analysis 

# Authors: Laura Wise (lwise@ipma.pt) 

# Date: 2024

# Load libraries ----------------------------------------------------------

library(icesTAF)

# Check the working directory ---------------------------------------------

getwd()

# Create repository and R project -----------------------------------------

# Clone the github repository created by ICES secretariat
# The cloned repository is in D:/GitHUB/ices-taf/2024_pil.27.8c9a_assessment
# Create an R project in that folder

# Make the skeleton -------------------------------------------------------

# create initial directories and R scripts for a new TAF analysis
# 2024_pil.27.8c9a_assessment    
# ¦--bootstrap   
# ¦   --initial 
# ¦       --data
# ¦--data.R      
# ¦--model.R     
# ¦--output.R    
# °--report.R    

taf.skeleton()

# Upload initial data -----------------------------------------------------

# Include data in the folder: 2024_pil.27.8c9a_assessment\bootstrap\initial\data
# It can be done by-hand or copying it using the following command file.copy

ss3_folder <- "D:/IPMA/SARDINE/WGHANSA2024/WGHANSA-2/SS3/01"
rep_folder <- "D:/IPMA/SARDINE/WGHANSA2024/WGHANSA-2/repository"
new_folder <- "./boot/initial/data"


## Include all five input files needed to run Stock Synthesis
# Starter file
file.copy(file.path(ss3_folder,'starter.ss'),new_folder,overwrite = T)

# Control file
file.copy(file.path(ss3_folder,'sardine.ctl'),new_folder,overwrite = T)

# Data file
file.copy(file.path(ss3_folder,'sardine.dat'),new_folder,overwrite = T)

# Weight at age file
file.copy(file.path(ss3_folder,'wtatage.ss'),new_folder,overwrite = T)

# Forecast file
file.copy(file.path(ss3_folder,'forecast.ss'),new_folder,overwrite = T)

## Include auxiliary files
# Data input description table
file.copy(file.path(rep_folder,"DataInputTable.csv"),new_folder,overwrite = T)

# ICES cls file
file.copy(file.path(rep_folder,"ices-journal-of-marine-science.csl"),new_folder,overwrite = T)

# Reference points
file.copy(file.path(rep_folder,"pil278c9a_refPoints.RData"),new_folder,overwrite = T)

# Sardine figure
file.copy(file.path(rep_folder,"Sardina_pilchardus_Gervais.jpg"),new_folder,overwrite = T)

# ICES TAF Word template for report automation
file.copy(file.path(rep_folder,"sec_08_template.docx"),new_folder,overwrite = T)

# Model structure
file.copy(file.path(rep_folder,"ss3ModelStructure.csv"),new_folder,overwrite = T)

# Main outputs from previous assessment
file.copy(file.path(rep_folder,"Table_summary.csv"),new_folder,overwrite = T)

# input data for this new assessment
file.copy(file.path(rep_folder,"update.csv"),new_folder,overwrite = T)

# Last years run
dir.create("boot/initial/data/SS3_LastYearRun")

file.copy(file.path(paste0(rep_folder,'/SS3_LastYearRun'),list.files(paste0(rep_folder,'/SS3_LastYearRun'))),
file.path(paste0(new_folder,'/SS3_LastYearRun')), overwrite=T)


# Document data and create the data.bib file ------------------------------

# use function draft.data() to create the data.bib file
# ?draft.data

# NOTE that the columns of the csv files should be separated by comma (",")

# data for stock assessment (5 different file)

draft.data(originator="WGHANSA", 
           year=2024, 
           title="Forecast input file", 
           period="1978-2024",
           source="file",
           data.files=c("forecast.ss"), 
           data.scripts=NULL, # we need to set this to NULL or it will automatically take all the files with extension .R
           file="boot/data.bib",
           append=T)


draft.data(originator="WGHANSA", 
           year=2024, 
           title="Starter input file", 
           period="1978-2024",
           source="file",
           data.files=c("starter.ss"), 
           data.scripts=NULL, # we need to set this to NULL or it will automatically take all the files with extension .R
           file="boot/data.bib",
           append=T)

draft.data(originator="WGHANSA", 
           year=2024, 
           title="Control input file", 
           period="1978-2024",
           source="file",
           data.files=c("sardine.ctl"), 
           data.scripts=NULL, # we need to set this to NULL or it will automatically take all the files with extension .R
           file="boot/data.bib",
           append=T)

draft.data(originator="WGHANSA", 
           year=2024, 
           title="Data input file", 
           period="1978-2024",
           source="file",
           data.files=c("sardine.dat"), 
           data.scripts=NULL, # we need to set this to NULL or it will automatically take all the files with extension .R
           file="boot/data.bib",
           append=T)

draft.data(originator="WGHANSA", 
           year=2024, 
           title="Weight at age input file", 
           period="1978-2024",
           source="file",
           data.files=c("wtatage.ss"), 
           data.scripts=NULL, # we need to set this to NULL or it will automatically take all the files with extension .R
           file="boot/data.bib",
           append=T)

# data with stock assessment results from previous year

draft.data(originator="WGHANSA", 
           year=2024, 
           title="ICES summary table for pil.27.8c9a from WGHANSA 2023", 
           period="1978-2023",
           source="file",
           data.files=c("Table_summary.csv"), 
           data.scripts=NULL, # we need to set this to NULL or it will automatically take all the files with extension .R
           file="boot/data.bib",
           append=T)

# table with ss3 Model structure

draft.data(originator="WGHANSA", 
           year=2023, 
           title="Summary table of Model structure", 
           source="file",
           data.files=c("ss3ModelStructure.csv"), 
           data.scripts=NULL, # we need to set this to NULL or it will automatically take all the files with extension .R
           file="boot/data.bib",
           append=T)

# table with Data input description

draft.data(originator="WGHANSA", 
           year=2024, 
           title="Data input description table", 
           source="file",
           data.files=c("DataInputTable.csv"), 
           data.scripts=NULL, # we need to set this to NULL or it will automatically take all the files with extension .R
           file="boot/data.bib",
           append=T)

# ICES section 8 for sardine ()

draft.data(originator="WGHANSA", 
           title="ICES TAF Word template for report automation", 
           source="file",
           data.files=c("sec_08_template.docx"), 
           data.scripts=NULL, # we need to set this to NULL or it will automatically take all the files with extension .R
           file="boot/data.bib",
           append=T)

# ICES csl file to format references 

draft.data(originator="WGHANSA", 
           title="ICES cls file", 
           source="file",
           data.files=c("ices-journal-of-marine-science.csl"), 
           data.scripts=NULL, # we need to set this to NULL or it will automatically take all the files with extension .R
           file="boot/data.bib",
           append=T)

# Sardine (Sardina pilchardus) downloaded from internet ---------------

draft.data(originator = "Gervais et Boulart",
           title = "Image sardine (Sardina pilchardus)",
           period = FALSE,
           source = "https://upload.wikimedia.org/wikipedia/commons/7/78/Sardina_pilchardus_Gervais.jpg",
           data.files = "Sardina_pilchardus_Gervais.jpg",
           data.scripts = NULL,
           file = "boot/data.bib", 
           append=T)

# reference points
draft.data(originator = "IBPIS 2021",
           title = "Reference points for Iberian sardine",
           period = FALSE,
           source = "file",
           data.files = "pil278c9a_refPoints.RData",
           data.scripts = NULL,
           file = "boot/data.bib", 
           append=T)

# input update
draft.data(originator = "WGHANSA",
           title = "update data for 2024 assessment",
           period = FALSE,
           source = "file",
           data.files = "update.csv",
           data.scripts = NULL,
           file = "boot/data.bib", 
           append=T)

# Upload software ---------------------------------------------------------

# create the folder "2024_pil.27.8c9a_assessment\boot\initial\software"

if (!dir.exists("boot/initial/software")){
  dir.create("boot/initial/software")
}

# # copy the SS3 executable file to the folder "2024_pil.27.8c9a_assessment\boot\initial\software"

file.copy(file.path(ss3_folder,'ss3.exe'),
          to="./boot/initial/software/ss3.exe",
          overwrite=T) # SS3 executable for windows


# Document software and create the software.bib file ----------------------

# use function draft.software to create the software.bib file

# ?draft.software

# document the SS3 model

draft.software(package=c("boot/initial/software/ss3.exe"), 
               author = "Richard D. Methot Jr., Chantel R. Wetzel, Ian G. Taylor, Kathryn L. Doering,
Elizabeth F. Gugliotti, and Kelli F. Johnson", 
               year = 2023, 
               title = "SS3 executable (for Windows)",
               version = "3.30.23",
               source = NULL, 
               file = "boot/software.bib", 
               append = FALSE)


# Process the data.bib and software.bib metafiles -------------------------

# the function taf.bootstrap() processes:
#   the data.bib file and creates/copies all the data files into the folder "bootstrap/data"
#   and 
#   the software.bib file and creates/copies the software into the folder bootstrap/software
# ?taf.bootstrap

# apply taf.bootstrap

taf.bootstrap(taf=TRUE)


# Session info ------------------------------------------------------------

sessionInfo()

# End of script -----------------------------------------------------------

