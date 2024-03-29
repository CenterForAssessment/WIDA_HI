##########################################################################################
###
### Script for calculating SGPs for 2021-2022 WIDA/ACCESS Hawaii
###
##########################################################################################

### Load SGP package
require(SGP)


### Load Data
load("Data/WIDA_HI_SGP.Rdata")
load("Data/WIDA_HI_Data_LONG_2022.Rdata")

###   Add single-cohort baseline matrices to SGPstateData
SGPstateData <- SGPmatrices::addBaselineMatrices("WIDA_HI", "2022")

### Run analyses
WIDA_HI_SGP <- updateSGP(
		WIDA_HI_SGP,
		WIDA_HI_Data_LONG_2022,
		steps=c("prepareSGP", "analyzeSGP", "combineSGP", "visualizeSGP", "outputSGP"),
		sgp.percentiles=TRUE,
		sgp.projections=TRUE,
		sgp.projections.lagged=TRUE,
		sgp.percentiles.baseline=TRUE,
		sgp.projections.baseline=TRUE,
		sgp.projections.lagged.baseline=TRUE,
		get.cohort.data.info=TRUE,
		sgp.target.scale.scores=TRUE,
		plot.types=c("growthAchievementPlot", "studentGrowthPlot"),
		sgPlot.demo.report=TRUE,
		parallel.config=list(BACKEND="PARALLEL", WORKERS=list(PERCENTILES=4, BASELINE_PERCENTILES=4, PROJECTIONS=4, LAGGED_PROJECTIONS=4, SGP_SCALE_SCORE_TARGETS=4, GA_PLOTS=1, SG_PLOTS=1)))


### Save results
save(WIDA_HI_SGP, file="Data/WIDA_HI_SGP.Rdata")
