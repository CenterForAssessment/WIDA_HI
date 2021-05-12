###################################################################################
###                                                                             ###
###   WIDA Hawaii Learning Loss Analyses -- 2020 Baseline Growth Percentiles    ###
###                                                                             ###
###################################################################################

###   Load packages
require(SGP)

###   Load data and remove years that will not be used.
load("Data/WIDA_HI_SGP_LONG_Data.Rdata")

###   Add single-cohort baseline matrices to SGPstateData
load("Data/WIDA_HI_Baseline_Matrices.Rdata")
SGPstateData[["WIDA_HI"]][["Baseline_splineMatrix"]][["Coefficient_Matrices"]] <- WIDA_HI_Baseline_Matrices

#####
###   Run BASELINE SGP analysis - create new WIDA_HI_SGP object with historical data
#####

###   Temporarily set names of prior scores from sequential/cohort analyses
data.table::setnames(WIDA_HI_SGP_LONG_Data,
	c("SCALE_SCORE_PRIOR", "SCALE_SCORE_PRIOR_STANDARDIZED"),
	c("SS_PRIOR_COHORT", "SS_PRIOR_STD_COHORT"))

SGPstateData[["WIDA_HI"]][["Assessment_Program_Information"]][["CSEM"]] <- NULL

WIDA_HI_SGP <- abcSGP(
        sgp_object = WIDA_HI_SGP_LONG_Data,
        steps = c("prepareSGP", "analyzeSGP", "combineSGP", "outputSGP"),
        sgp.percentiles = FALSE,
        sgp.projections = FALSE,
        sgp.projections.lagged = FALSE,
        sgp.percentiles.baseline = TRUE,  #  baseline SGPs for 2021 comparisons
        sgp.projections.baseline = FALSE, #  Calculated in next step
        sgp.projections.lagged.baseline = FALSE,
        save.intermediate.results = FALSE,
        parallel.config = list(
					BACKEND = "PARALLEL",
					WORKERS=list(BASELINE_PERCENTILES=8))
)

###   Re-set and rename prior scores (one set for sequential/cohort, another for skip-year/baseline)
data.table::setnames(WIDA_HI_SGP@Data,
  c("SCALE_SCORE_PRIOR", "SCALE_SCORE_PRIOR_STANDARDIZED", "SS_PRIOR_COHORT", "SS_PRIOR_STD_COHORT"),
  c("SCALE_SCORE_PRIOR_BASELINE", "SCALE_SCORE_PRIOR_STANDARDIZED_BASELINE", "SCALE_SCORE_PRIOR", "SCALE_SCORE_PRIOR_STANDARDIZED"))

###   Save results
save(WIDA_HI_SGP, file="Data/WIDA_HI_SGP.Rdata")