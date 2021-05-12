##############################################################################
###                                                                        ###
###    Create LONG WIDA Hawaii data from 2018-2019 and 2019-2020 base file ###
###                                                                        ###
##############################################################################

### Load packages
require(data.table)


### Load data
tmp_2018_2019 <- fread("Data/Base_Files/access_2018-19.csv", na.strings=c("NULL", "NA"))
tmp_2019_2020 <- fread("Data/Base_Files/access_2019-20.csv", na.strings=c("NULL", "NA"))


### Stack data
WIDA_HI_Data_LONG <- rbindlist(list(tmp_2018_2019, tmp_2019_2020))

### Remove ACCESS-ALT data
WIDA_HI_Data_LONG <- WIDA_HI_Data_LONG[scale_score_overall <= 500]

### Subset data
variables.to.keep <- c("district_name", "area_name", "complex_name", "school_code", "school_name", "student_id", "school_year", "scale_score_overall", "proficiency_overall_k", "proficiency_status", "mode_listening", "test_grade")
WIDA_HI_Data_LONG <- WIDA_HI_Data_LONG[,variables.to.keep, with=FALSE]

### Rename variables
old.names <- c("district_name", "area_name", "complex_name", "school_code", "school_name", "student_id", "school_year", "scale_score_overall", "proficiency_overall_k", "proficiency_status", "mode_listening", "test_grade")
new.names <- c("DISTRICT_NAME", "COMPLEX_AREA_NAME", "COMPLEX_NAME", "SCHOOL_NUMBER", "SCHOOL_NAME", "ID", "YEAR", "SCALE_SCORE", "ACHIEVEMENT_LEVEL_ORIGINAL", "ACHIEVEMENT_LEVEL", "TEST_MODE", "GRADE")

setnames(WIDA_HI_Data_LONG, old.names, new.names)


### Tidy up variables
WIDA_HI_Data_LONG[,ID:=as.character(ID)]
WIDA_HI_Data_LONG[,YEAR:=as.character(YEAR)]
WIDA_HI_Data_LONG[,SCALE_SCORE:=as.numeric(SCALE_SCORE)]
WIDA_HI_Data_LONG[,ACHIEVEMENT_LEVEL:=as.character(ACHIEVEMENT_LEVEL)]
WIDA_HI_Data_LONG[!is.na(ACHIEVEMENT_LEVEL), ACHIEVEMENT_LEVEL:=paste("WIDA Level", ACHIEVEMENT_LEVEL)]
WIDA_HI_Data_LONG[TEST_MODE=="O", TEST_MODE:="Online"]
WIDA_HI_Data_LONG[TEST_MODE=="P", TEST_MODE:="Paper"]
WIDA_HI_Data_LONG[GRADE=="K", GRADE:="0"]
WIDA_HI_Data_LONG[,GRADE:=as.character(as.numeric(GRADE))]

WIDA_HI_Data_LONG[,CONTENT_AREA:="READING"]
WIDA_HI_Data_LONG[,VALID_CASE:="VALID_CASE"]


### Final tidy up
setcolorder(WIDA_HI_Data_LONG, c("VALID_CASE", "CONTENT_AREA", "YEAR", "GRADE", "ID", "SCALE_SCORE", "ACHIEVEMENT_LEVEL", "ACHIEVEMENT_LEVEL_ORIGINAL", "SCHOOL_NUMBER", "SCHOOL_NAME", "DISTRICT_NAME", "COMPLEX_AREA_NAME", "COMPLEX_NAME", "TEST_MODE"))
setkey(WIDA_HI_Data_LONG, VALID_CASE, CONTENT_AREA, YEAR, ID)


### Save results
save(WIDA_HI_Data_LONG, file="Data/WIDA_HI_Data_LONG.Rdata")
