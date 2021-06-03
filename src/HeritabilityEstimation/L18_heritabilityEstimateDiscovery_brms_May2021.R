# Script for running several animal models on the Discovery cluster


# Description: In this script I run X models 


#### Libraries ####
library(AGHmatrix)
library(dplyr,verbose = F)
library(brms,verbose = F)
library(rstan,verbose = F)
options(mc.cores = parallel::detectCores())
rstan_options(auto_write = TRUE)

#### working directory ####
setwd("~/Github/2018OAExp_larvae/") # Local
#setwd("~/2018OAExp_larvae/") # HPC

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
ped_ind_parents <- ped_ind[1:26,]
ped_ind_cc <- ped_ind[ped_ind$id %in% cc$animal,]
ped_ind_cc <- rbind(ped_ind_parents,ped_ind_cc)

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

## Format for brms
# Individuals
ped_ind_alt <- ped_ind_cc 
ped_ind_alt[is.na(ped_ind_alt)] <-  0
A_ind_alt  <- Amatrix(ped_ind_alt)
# Jar
ped_jar_alt <- ped_jar
ped_jar_alt[is.na(ped_jar_alt)] <-  0
A_jar_alt  <- Amatrix(ped_jar_alt)
# Family
ped_family_alt <- ped_family
ped_family_alt[is.na(ped_family_alt)] <-  0
A_family_alt  <- Amatrix(ped_family_alt)

print("Starting BRMS model......")
start <- Sys.time()
model <- brm(GrowthScale ~ (1|gr(animal,cov=A)) + (1|damID) + (1|JarID),
                    data = cc,
                    family = gaussian(),
                    data2 = list(A = A_ind_alt),
                    chains = 6,
                    control = list(adapt_delta=0.99,stepsize=0.001, max_treedepth=15),
                    cores = 6,
                    warmup=5000,iter = 20000,thin=20)
end <- Sys.time()
print(paste0("Time completed: ",start))
diff <- end-start
meta <- list(model="brms",
              response=c("Growth_scaled"),
              fixed_factor=c("ParentTrt + JarTrt"),
              random_factor=c("(1|gr(animal,cov=A)) + (1|damID) + (1|JarID)"),
              time_complete=c(date()),
              run_time=diff)
mod <- list(meta,model)
print("Saving BRMS model......")
saveRDS(mod,paste0("results/",substr(Sys.time(),1,10),"_BRMS_cc_growth_model.RDS"))
