##########################################################################################
###
### Script for calculating SGPs for 2019-2020 WIDA/ACCESS Hawaii
###
##########################################################################################

### Load SGP package

require(SGP)


### Load Data

load("Data/WIDA_HI_Data_LONG.Rdata")

### Modify SGPstateData temporarily
SGPstateData[["WIDA_HI"]][["Growth"]][["System_Type"]] <- "Cohort Referenced"

### Run analyses

WIDA_HI_SGP <- abcSGP(
		WIDA_HI_Data_LONG,
		steps=c("prepareSGP", "analyzeSGP", "combineSGP", "visualizeSGP", "outputSGP"),
		sgp.percentiles=TRUE,
		sgp.projections=TRUE,
		sgp.projections.lagged=TRUE,
		sgp.percentiles.baseline=FALSE,
		sgp.projections.baseline=FALSE,
		sgp.projections.lagged.baseline=FALSE,
		get.cohort.data.info=TRUE,
		sgp.target.scale.scores=TRUE,
		plot.types=c("growthAchievementPlot", "studentGrowthPlot"),
		sgPlot.demo.report=TRUE,
		parallel.config=list(BACKEND="PARALLEL", WORKERS=list(PERCENTILES=4, BASELINE_PERCENTILES=4, PROJECTIONS=4, LAGGED_PROJECTIONS=4, SGP_SCALE_SCORE_TARGETS=4, GA_PLOTS=1, SG_PLOTS=1)))


### Save results

save(WIDA_HI_SGP, file="Data/WIDA_HI_SGP.Rdata")
