# Script for running several animal models on the Discovery cluster


# Description: In this script I run X models 


#### Libraries ####
#library(AGHmatrix)
library(MCMCglmm,verbose = F)
#library(dplyr,verbose = F)
#library(brms,verbose = F)
#library(rstan,verbose = F)
#options(mc.cores = parallel::detectCores())
#rstan_options(auto_write = TRUE)

#### working directory ####
#setwd("~/Github/2018OAExp_larvae/") # Local
setwd("~/2018OAExp_larvae/") # HPC

#### Data #### 
print("Reading in data...")
# Jar (jr) and individual (ind) level observations 
# RData objects contain a list of two data.frames
# 1 - pheno: Dataframe consisting of all information associated with each individuals (or family)
# 2 - ped: pedigree table of all individuals
ind <- readRDS("input_files/IndHeritabilityData.RDS")
jr <- readRDS("input_files/JarHeritabilityData.RDS")
family <- readRDS("input_files/FamilyHeritabilityData.RDS")


# Individual
pheno_ind <- ind$pheno #Create data.frame for phenotype data
ped_ind <- ind$ped # Create data.frame for pedigree

# Jar
pheno_jar <- jr$pheno
ped_jar <- jr$ped

# Family
pheno_family <- family$pheno
ped_family <- family$ped

#### Splitting Data ####

# Subsetting individuals by different parent-offspring treatment combinations
ce <- subset(pheno_ind, pheno_ind$JarTrt == "Control" & pheno_ind$ParentTrt == "Control")
cc <- subset(pheno_ind, pheno_ind$JarTrt == "Exposed" & pheno_ind$ParentTrt == "Control")
ec <- subset(pheno_ind, pheno_ind$JarTrt == "Control" & pheno_ind$ParentTrt == "Exposed")
ee <- subset(pheno_ind, pheno_ind$JarTrt == "Exposed" & pheno_ind$ParentTrt == "Exposed")

# Subsetting by parent treatment 
off_control <- subset(pheno_ind, pheno_ind$ParentTrt == "Control")
off_exposed <- subset(pheno_ind, pheno_ind$ParentTrt == "Exposed")

#### Setting up relatedness matrices ####
print("Creating relatedness matrices...")
# Create relatedness matrix
## Format for MCMCglmm 
A_ind_mcmc <- MCMCglmm::inverseA(ped_ind)$Ainv
A_jar_mcmc <- MCMCglmm::inverseA(ped_jar)$Ainv
A_family_mcmc <- MCMCglmm::inverseA(ped_family)$Ainv
## Format for brms
# Individuals
#ped_ind_alt <- ped_ind
#ped_ind_alt[is.na(ped_ind_alt)] <-  0
#A_ind_alt  <- Amatrix(ped_ind_alt)
# Jar
#ped_jar_alt <- ped_jar
#ped_jar_alt[is.na(ped_jar_alt)] <-  0
#A_jar_alt  <- Amatrix(ped_jar_alt)
# Family
#ped_family_alt <- ped_family
#ped_family_alt[is.na(ped_family_alt)] <-  0
#A_family_alt  <- Amatrix(ped_family_alt)

#### Priors ####
print("Creating priors...")

# NOTE : the inverse wilshart prior requires two parameters to define the distribution,
#       V and nu. In the context of the bayesian prior, V is thought of as the prior
#       expectation and nu is the belief in that prior. In our case, using a small nu
#       (0.002) tells the model we have little belief in the prior (i.e. it is uninformative).

# Two random effectswith equal priors (G) and equivalent residual variation (R)
prior1.2 <- list(R = list(V=1, nu=0.002), G = list(G1 = list(V=1, nu=0.002),
                                                   G2 = list(V=1, nu=0.002)))
# Three random effects with equal priors (G) and equivalent residual variation (R)
prior1.3 <- list(R = list(V=1, nu=0.002), G = list(G1 = list(V=1, nu=0.002),
                                                   G2 = list(V=1, nu=0.002),
                                                   G3 = list(V=1, nu=0.002)))
# Four random effects with equal priors (G) and equivalent residual variation (R)
prior1.4<-list(R=list(V = 1, nu = 0.002),
                   G=list(G1=list(V = 1, nu = 0.002),
                          G2=list(V = 1, nu = 0.002),
                          G3=list(V = 1, nu = 0.002),
                          G4=list(V = 1, nu = 0.002)))

prior2.3 <- list(G = list(G1 = list(V = diag(2), n = 1.002),
                          G2 = list(V = diag(2), n = 1.002),
                          G3 = list(V = diag(2), n = 1.002)),
                 R = list(V = diag(2), n = 1.002))

#### MCMCglmm ####
# Defaults :
#       Iterations - 5000000
#       burnin - 50000
#       thin - 5000
# NOTE : This are pretty conservative settings in line with previous publications and appear to work in most scenarios I have
#         explored, but they DO take time to run.

## Model Functions ##

# Function for running a single response variable with MCMCglmm
MCMC_singleResponse <- function(pheno,A,response_variable,name=NULL){
  print(paste0("Starting MCMCglmm model - ",name,"...."))
  
  # Weird quark of mcmcglmm is doesn't like that there is a column in phenotype data called family, this needs to be removed
  if(sum(colnames(pheno) == "family")>0){pheno <- pheno[,which(colnames(pheno) != "family")]}
  
  start <- Sys.time()
  print(paste0("Time started: ",start))
  if(response_variable == "GrowthScale"){
    model  <- MCMCglmm(GrowthScale ~ 1,
                       random = ~ animal + damID + JarID,
                       family = "gaussian",
                       prior = prior1.3,
                       ginverse=list(animal=A),
                       data = pheno,
                       nitt = 5000000,
                       burnin = 50000,
                       thin = 5000)
    
    end <- Sys.time()
    print(paste0("Time completed: ",start))
    diff <- end-start
    meta <- list(model="MCMCglmm",
                 response=c("Growth_scaled"),
                 fixed_factor=c("ParentTrt + JarTrt"),
                 random_factor=c("(1|gr(animal,cov=A)) + (1|damID) + (1|JarID)"),
                 time_complete=c(date()),
                 run_time=diff)
  }
  if(response_variable == "PDR"){
    model  <- MCMCglmm(PDRScale ~ 1,
                       random = ~ animal + damID + JarID,
                       family = "gaussian",
                       prior = prior1.3,
                       ginverse=list(animal=A),
                       data = pheno,
                       nitt = 5000000,
                       burnin = 50000,
                       thin = 5000)
    
    end <- Sys.time()
    print(paste0("Time completed: ",start))
    diff <- end-start
    meta <- list(model="MCMCglmm",
                 response=c("PDR_scaled"),
                 fixed_factor=c("ParentTrt + JarTrt"),
                 random_factor=c("(1|gr(animal,cov=A)) + (1|damID) + (1|JarID)"),
                 time_complete=c(date()),
                 run_time=diff)
  }
  mod <- list(meta,model)
  print(paste0("Saving MCMCglmm model - ",name,"...."))
  saveRDS(mod,paste0("results/",substr(Sys.time(),1,10),"_MCMCglmm_",name,"_model.RDS"))
}

# Function for running bivariate response model on mcmglmm
MCMC_bivariateResponse <- function(pheno,A,name=NULL){
  print(paste0("Starting MCMCglmm model - ",name,"...."))
  
  # Weird quark of mcmcglmm is doesn't like that there is a column in phenotype data called family, this needs to be removed
  if(sum(colnames(pheno) == "family")>0){pheno <- pheno[,which(colnames(pheno) != "family")]}
  
  start <- Sys.time()
  print(paste0("Time started: ",start))
  model  <- MCMCglmm(cbind(GrowthScale,PDRScale) ~ trait - 1,
                     random = ~ us(trait):animal + us(trait):damID + us(trait):JarID,
                     rcov = ~us(trait):units,
                     family = c("gaussian", "gaussian"),
                     prior = prior2.3,
                     ginverse=list(animal=A),
                     data = pheno,
                     nitt = 5000000,
                     burnin = 50000,
                     thin = 5000)
  
  end <- Sys.time()
  print(paste0("Time completed: ",start))
  diff <- end-start
  meta <- list(model="MCMCglmm",
               response=c("Bivariate"),
               fixed_factor=c("ParentTrt + JarTrt"),
               random_factor=c("(1|gr(animal,cov=A)) + (1|damID) + (1|JarID)"),
               time_complete=c(date()),
               run_time=diff)
  
  mod <- list(meta,model)
  print(paste0("Saving MCMCglmm model - ",name,"...."))
  saveRDS(mod,paste0("results/",substr(Sys.time(),1,10),"_MCMCglmm_",name,"_model.RDS"))
}

#### Running the models

# Individual observations

# Growth
MCMC_singleResponse(cc,A_ind_mcmc,response_variable="GrowthScale","cc_growth")
MCMC_singleResponse(ce,A_ind_mcmc,response_variable="GrowthScale","ce_growth")
MCMC_singleResponse(ec,A_ind_mcmc,response_variable="GrowthScale","ec_growth")
MCMC_singleResponse(ee,A_ind_mcmc,response_variable="GrowthScale","ee_growth")
# PDR
MCMC_singleResponse(cc,A_ind_mcmc,response_variable="PDR","cc_PDR")
MCMC_singleResponse(ce,A_ind_mcmc,response_variable="PDR","ce_PDR")
MCMC_singleResponse(ec,A_ind_mcmc,response_variable="PDR","ec_PDR")
MCMC_singleResponse(ee,A_ind_mcmc,response_variable="PDR","ee_PDR")

# Family level observations
MCMC_bivariateResponse(cc,A_ind_mcmc,"cc_bi")
MCMC_bivariateResponse(ce,A_ind_mcmc,"ce_bi")
MCMC_bivariateResponse(ec,A_ind_mcmc,"ec_bi")
MCMC_bivariateResponse(ee,A_ind_mcmc,"ee_bi")

#### BRMS ####
## TO DO
# print("Starting BRMS model......")
# start <- Sys.time()
# print(paste0("Time started: ",start))
# model <- brm(GrowthScale ~ ParentTrt + JarTrt + (1|gr(animal,cov=A)) + (1|damID) + (1|JarID),
#                    data = pheno,
#                    family = gaussian(),
#                    data2 = list(A = A_alt),
#                    chains = 1,
#                    control = list(adapt_delta=0.9,stepsize=0.001, max_treedepth=10),
#                    cores = 6,
#                    warmup=750,iter = 1000,thin=10)
# end <- Sys.time()
# print(paste0("Time completed: ",start))
# diff <- end-start
# meta <- list(model="brms",
#              response=c("Growth_scaled"),
#              fixed_factor=c("ParentTrt + JarTrt"),
#              random_factor=c("(1|gr(animal,cov=A)) + (1|damID) + (1|JarID)"),
#              time_complete=c(date()),
#              run_time=diff)
# mod <- list(meta,model)
# print("Saving BRMS model......")
# saveRDS(mod,paste0("results/",substr(Sys.time(),1,10),"_BRMS_model.RDS"))

