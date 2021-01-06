
#### Overview ####

# Script examines the estimation of heritability of larval growth using MCMCglmm
# It explores:
# (1) two different priors (uniformative and slightly informative) and 
# (2) the inclusion of fixed and random effects.

#### Libraries ####
library(MCMCglmm)

#### Read-in data ###
jr <- readRDS("~/Github/2018OAExp_larvae/input_files/JarHeritabilityData.RDS")
ped1 <- jr$ped
ind <- readRDS("~/Github/2018OAExp_larvae/input_files/IndHeritabilityData.RDS")

#### Subset Data ####

# Control Parents - Control Offspring 
jr_cc <- subset(jr$pheno, jr$pheno$JarTrt == "Control" & jr$pheno$ParentTrt == 400)
dam_cc <- data.frame(id=unique(jr_cc$damID),dam=NA,sire=NA)
sire_cc <- data.frame(id=unique(jr_cc$sireID),dam=NA,sire=NA)
ped_cc <- rbind(dam_cc,sire_cc,data.frame(id=jr_cc$animal,dam=jr_cc$damID,sire=jr_cc$sireID))

# Control Parents - Exposed Offspring
jr_ce <- subset(jr$pheno, jr$pheno$JarTrt == "Exposed" & jr$pheno$ParentTrt == 400)
#ped_ce <- jr$ped[c(which(jr$ped$id %in% jr_ce$damID),which(jr$ped$id %in% jr_ce$sireID),which(jr$ped$id %in% jr_ce$animal)),]

# Exposed Parents - Control Offspring 
jr_ec <- subset(jr$pheno, jr$pheno$JarTrt == "Control" & jr$pheno$ParentTrt == 2600)
#ped_ec <- jr$ped[c(which(jr$ped$id %in% jr_ec$damID),which(jr$ped$id %in% jr_ec$sireID),which(jr$ped$id %in% jr_ec$animal)),]

# Exposed Parents - Exposed Offspring
jr_ee <- subset(jr$pheno, jr$pheno$JarTrt == "Exposed" & jr$pheno$ParentTrt == 2600)
#ped_ee <- jr$ped[c(which(jr$ped$id %in% jr_ee$damID),which(jr$ped$id %in% jr_ee$sireID),which(jr$ped$id %in% jr_ee$animal)),]


#### Difference datasets (setting up measure of plasticity heritability) ####

## TO DO

#### Estimating Heritability ####

## Assumptions of the animal model
 # 1 - The Y trait is normally distributed (this assumption can be drop using 
 #     generalized models)
# 2 - The breeding values ai are normally distributed and correlated among 
 #     related individuals.
 # 3 - The function of the pedigree is to structure the correlation between 
 #     individuals by taking into account their kinship.
# 4 - The residuals ei are normally distributed and uncorrelated. They also
 #     are independent from the breeding values (e.g. no environment-genotype interaction).

## Things to remember 
 # Scale the phenotypes otherwise estimate of the priors can be errorneous

#scale phenotype
jr_cc$GrowthScale <- scale(jr_cc$Growth)

#### Model 1 - Simple model no added fixed or random effects and uninformative prior ####
 ## Estimate heritability of larvae growth (jar-level) in  
  # absence of treatment (i.e. control-control).

## Inverse gamme prior - classic uninformative prior used in animal model
 # This prior doesn't inform posterior distribution estimates, meaning estimates
 # shouls be largely determined by the data (usefull when we do not have strong a priori
 # expectations).
prior1 <- list(R = list(V=1, nu=0.002), G = list(G1 = list(V=1, nu=0.002)))

# Simple model with no fixed effects or additional random effects
model_mcmc  <- MCMCglmm(GrowthScale ~ 1,
                        random = ~ animal,
                        family = "gaussian",
                        prior = prior1,
                        pedigree = ped_cc,
                        data = jr_cc,
                        nitt = 1000000,
                        burnin = 10000,
                        thin = 200)

# Check outputs

# Traces for fixed effects
plot(model_mcmc$Sol)
# Traces for random effects
plot(model_mcmc$VCV)

## Auto-correlation among lag steps
autocorr.diag(model_mcmc$Sol)
autocorr.diag(model_mcmc$VCV)

## Effective sample size
effectiveSize(model_mcmc$Sol)
effectiveSize(model_mcmc$VCV)

## Test of model convergence

heidel.diag(model_mcmc$VCV)

## Summary of model
summary(model_mcmc)

## Calculate heritability for heritability from variance components
h2_mcmc_object  <- model_mcmc$VCV[, "animal"] /
  (model_mcmc$VCV[, "animal"] + model_mcmc$VCV[, "units"])

## Summarise results from that posterior
h2_m1_mcmc  <- data.frame(mean = mean(h2_mcmc_object),
                       lower = quantile(h2_mcmc_object, 0.025),
                       upper = quantile(h2_mcmc_object, 0.975),
                       method = "MCMC",
                       stringsAsFactors = FALSE,row.names = NULL)


#### Model 2 - Changing to slightly more informative prior #### 
prior2<-list(R=list(V=1,nu=1),
                G=list(G1=list(V=1,nu=1,alpha.mu=0,alpha.V=1000)))
#'Fisher' prior

# Simple model with no fixed effects or additional random effects
model2_mcmc  <- MCMCglmm(GrowthScale ~ 1,
                        random = ~ animal,
                        family = "gaussian",
                        prior = prior2,
                        pedigree = ped_cc,
                        data = jr_cc,
                        nitt = 1000000,
                        burnin = 10000,
                        thin = 200)

# Traces for fixed effects
plot(model2_mcmc$Sol)
# Traces for random effects
plot(model2_mcmc$VCV)

## Auto-correlation among lag steps
autocorr.diag(model2_mcmc$Sol)
autocorr.diag(model2_mcmc$VCV)

## Effective sample size
effectiveSize(model2_mcmc$Sol)
effectiveSize(model2_mcmc$VCV)

## Test of model convergence

heidel.diag(model2_mcmc$VCV)

## Summary of model
summary(model2_mcmc)

## Calculate heritability for heritability from variance components
h2_mcmc_object  <- model2_mcmc$VCV[, "animal"] /
  (model2_mcmc$VCV[, "animal"] + model2_mcmc$VCV[, "units"])

## Summarise results from that posterior
h2_m2_mcmc  <- data.frame(mean = mean(h2_mcmc_object),
                       lower = quantile(h2_mcmc_object, 0.025),
                       upper = quantile(h2_mcmc_object, 0.975),
                       method = "Model 2",
                       stringsAsFactors = FALSE,row.names = NULL)
h2_m2_mcmc
#### Model 3 - Adding fixed effects - dam and sire ####

model3_mcmc  <- MCMCglmm(GrowthScale ~ 1 + damID + sireID,
                         random = ~ animal,
                         family = "gaussian",
                         prior = prior2,
                         pedigree = ped_cc,
                         data = jr_cc,
                         nitt = 1000000,
                         burnin = 10000,
                         thin = 200)

## Diagnostics
plot(model3_mcmc$Sol)
plot(model3_mcmc$VCV)

effectiveSize(model3_mcmc$Sol)
effectiveSize(model3_mcmc$VCV)

heidel.diag(model3_mcmc$VCV)

# Summary
summary(model3_mcmc)

## Calculate heritability for heritability from variance components
h2_mcmc_object  <- model3_mcmc$VCV[, "animal"] /
  (model3_mcmc$VCV[, "animal"] + model3_mcmc$VCV[, "units"])

## Summarise results from that posterior
h2_m3_mcmc  <- data.frame(mean = mean(h2_mcmc_object),
                       lower = quantile(h2_mcmc_object, 0.025),
                       upper = quantile(h2_mcmc_object, 0.975),
                       method = "Model 3",
                       stringsAsFactors = FALSE,row.names = NULL)

# Fisher prior (same as prior2) but with more random effects

#### Model 4 - Including dam and sire as random effects ####

prior3<-list(R=list(V=1,nu=1),
             G=list(G1=list(V=1,nu=1,alpha.mu=0,alpha.V=1000),
                    G2=list(V=1,nu=1,alpha.mu=0,alpha.V=1000),
                    G3=list(V=1,nu=1,alpha.mu=0,alpha.V=1000)))

model4_mcmc  <- MCMCglmm(GrowthScale ~ 1,
                         random = ~ animal + damID + sireID,
                         family = "gaussian",
                         prior = prior3,
                         pedigree = ped_cc,
                         data = jr_cc,
                         nitt = 1000000,
                         burnin = 10000,
                         thin = 200)

plot(model4_mcmc$Sol)
plot(model4_mcmc$VCV)

effectiveSize(model4_mcmc$Sol)
effectiveSize(model4_mcmc$VCV)

autocorr.diag(model4_mcmc$VCV)
heidel.diag(model4_mcmc$VCV)

# Summary
summary(model4_mcmc)

#### Model 5 - Including Egg Diameter and Jar Chemistry as fixed effects ####
model5_mcmc  <- MCMCglmm(GrowthScale ~ 1 + EggDiamum + JarpCO2_SW,
                         random = ~ animal,
                         family = "gaussian",
                         prior = prior2,
                         pedigree = ped_cc,
                         data = jr_cc,
                         nitt = 1000000,
                         burnin = 10000,
                         thin = 200)

plot(model5_mcmc$Sol)
plot(model5_mcmc$VCV)

effectiveSize(model5_mcmc$Sol)
effectiveSize(model5_mcmc$VCV)

autocorr.diag(model5_mcmc$VCV)
heidel.diag(model5_mcmc$VCV)

# Summary
summary(model5_mcmc)

## Calculate heritability for heritability from variance components
h2_mcmc_object  <- model5_mcmc$VCV[, "animal"] /
  (model5_mcmc$VCV[, "animal"] + model5_mcmc$VCV[, "units"])

## Summarise results from that posterior
h2_mcmc  <- data.frame(mean = mean(h2_mcmc_object),
                       lower = quantile(h2_mcmc_object, 0.025),
                       upper = quantile(h2_mcmc_object, 0.975),
                       method = "MCMC",
                       stringsAsFactors = FALSE,row.names = NULL)
h2_mcmc


#### Model 6 -  Includes eggdiam and pCO2 as fixed effects and damID as random effect
prior2.2 <- list(R = list(V=1, nu=0.002), G = list(G1 = list(V=1,nu=1,alpha.mu=0,alpha.V=1000),
                                                 G2 = list(V=1,nu=1,alpha.mu=0,alpha.V=1000)))

model6_mcmc  <- MCMCglmm(GrowthScale ~ 1 + EggDiamum + JarpCO2_SW,
                         random = ~ animal + damID,
                         family = "gaussian",
                         prior = prior2.2,
                         pedigree = ped_cc,
                         data = jr_cc,
                         nitt = 5000000,
                         burnin = 10000,
                         thin = 500)

plot(model6_mcmc$Sol)
plot(model6_mcmc$VCV)

autocorr.diag(model6_mcmc$VCV)
heidel.diag(model6_mcmc$VCV)

summary(model6_mcmc)

h2_mcmc_object  <- model6_mcmc$VCV[, "animal"] /
  (model6_mcmc$VCV[, "animal"] + model6_mcmc$VCV[, "damID"] + model6_mcmc$VCV[, "units"])

## Summarise results from that posterior
h2_mcmc  <- data.frame(mean = mean(h2_mcmc_object),
                       lower = quantile(h2_mcmc_object, 0.025),
                       upper = quantile(h2_mcmc_object, 0.975),
                       method = "MCMC",
                       stringsAsFactors = FALSE,row.names = NULL)
h2_mcmc
