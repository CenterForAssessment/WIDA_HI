##############################################################################
###                                                                        ###
###    Create LONG WIDA Hawaii data from 2020-2021 base file               ###
###                                                                        ###
##############################################################################

### Utility functions

strhead <- function (s, n) {
    if (n < 0)
        substr(s, 1, nchar(s) + n)
    else substr(s, 1, n)
}

### Load packages
require(data.table)

### Load data
tmp_2020_2021 <- fread("Data/Base_Files/HI_Summative_StudRR_File_2021-05-12.csv", na.strings=c("NULL", "NA"))

### Subset data
variables.to.keep <- c("District Name", "District Number", "School Number", "School Name", "State Student ID", "Composite (Overall) Scale Score", "Composite (Overall) Proficiency Level", "Grade")
WIDA_HI_Data_LONG_2021 <- tmp_2020_2021[,variables.to.keep, with=FALSE][,YEAR:="2021"]

### Rename variables
old.names <- c("District Name", "District Number", "School Number", "School Name", "State Student ID", "Composite (Overall) Scale Score", "Composite (Overall) Proficiency Level", "Grade")
new.names <- c("DISTRICT_NAME", "DISTRICT_NUMBER", "SCHOOL_NUMBER", "SCHOOL_NAME", "ID", "SCALE_SCORE", "ACHIEVEMENT_LEVEL_ORIGINAL", "GRADE")
setnames(WIDA_HI_Data_LONG_2021, old.names, new.names)

### Tidy up variables
WIDA_HI_Data_LONG_2021[,ID:=as.character(ID)]
WIDA_HI_Data_LONG_2021[,SCALE_SCORE:=as.numeric(SCALE_SCORE)]
WIDA_HI_Data_LONG_2021[,ACHIEVEMENT_LEVEL_ORIGINAL:=as.character(ACHIEVEMENT_LEVEL_ORIGINAL)]
WIDA_HI_Data_LONG_2021[,ACHIEVEMENT_LEVEL:=strhead(ACHIEVEMENT_LEVEL_ORIGINAL, 1)]
WIDA_HI_Data_LONG_2021[!is.na(ACHIEVEMENT_LEVEL), ACHIEVEMENT_LEVEL:=paste("WIDA Level", ACHIEVEMENT_LEVEL)]
WIDA_HI_Data_LONG_2021[,GRADE:=as.character(as.numeric(GRADE))]
WIDA_HI_Data_LONG_2021[,CONTENT_AREA:="READING"]
WIDA_HI_Data_LONG_2021[,VALID_CASE:="VALID_CASE"]

### Final tidy up
setcolorder(WIDA_HI_Data_LONG_2021, c("VALID_CASE", "CONTENT_AREA", "YEAR", "GRADE", "ID", "SCALE_SCORE", "ACHIEVEMENT_LEVEL", "ACHIEVEMENT_LEVEL_ORIGINAL", "SCHOOL_NUMBER", "SCHOOL_NAME", "DISTRICT_NUMBER", "DISTRICT_NAME"))
setkey(WIDA_HI_Data_LONG_2021, VALID_CASE, CONTENT_AREA, YEAR, ID, SCALE_SCORE)
setkey(WIDA_HI_Data_LONG_2021, VALID_CASE, CONTENT_AREA, YEAR, ID)
WIDA_HI_Data_LONG_2021[which(duplicated(WIDA_HI_Data_LONG_2021, by=key(WIDA_HI_Data_LONG_2021)))-1, VALID_CASE := "INVALID_CASE"]

### Save results
save(WIDA_HI_Data_LONG_2021, file="Data/WIDA_HI_Data_LONG_2021.Rdata")
