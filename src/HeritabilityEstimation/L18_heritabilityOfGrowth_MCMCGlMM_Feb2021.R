############################# Larval Phenotype heritability estimation ###################################

library(MCMCglmm,quietly = T)
library(reshape2,quietly = T)
library(ggplot2,quietly = T)
library(ggpubr,quietly = T)
library(cowplot,quietly = T)
library(dplyr,quietly = T)
library(knitr,quietly = T)
library(brms,quietly = T)
library(rstan,quietly = T)
options(mc.cores = parallel::detectCores())
rstan_options(auto_write = TRUE)

## Data 

# These datasets correspond to jar (jr) and individual (ind) based phenotypic estimates
# These are RDS files I made from Elise's original data using the script: 2018OAExp_larvae/src/dataFormatScript.R
# They contains lists with both the phenotype (pheno) and pedigree (ped) data.
jr <- readRDS("~/Github/2018OAExp_larvae/input_files/JarHeritabilityData.RDS")
ind <- readRDS("~/Github/2018OAExp_larvae/input_files/IndHeritabilityData.RDS")

# Individual data
pheno <- ind$pheno
hist(pheno$GrowthPerDay)

plot(GrowthPerDay~LarvaeAreaum2,data=pheno)
# Note: it is advisable to scale data prior to running it in MCMCglmm (need to find ref for this)
pheno$GrowthScale <-scale(pheno$GrowthPerDay)
pheno$Area <- scale(pheno$LarvaeAreaum2)

# Jar data
ped1 <- jr$ped
jrp <- jr$pheno
colnames(jrp)[colnames(jrp) == "SeaTable"] <- "JarSeatable"
jrp$GrowthScale <-scale(jrp$Growth)
jrp$Area <- scale(jrp$Area)


############################ Data Subsets ########################################

# Control Parents - Control Offspring 
cc <- subset(pheno, pheno$JarTrt == "Control" & pheno$ParentTrt == 400)
dam_cc <- data.frame(id=unique(cc$damID),dam=NA,sire=NA)
sire_cc <- data.frame(id=unique(cc$sireID),dam=NA,sire=NA)
ped_cc <- rbind(dam_cc,sire_cc,data.frame(id=cc$animal,dam=cc$damID,sire=cc$sireID))

ped_cc_brms <- ped_cc
ped_cc_brms$dam[ped_cc$dam == 0] <- NA
ped_cc_brms$sire[ped_cc$sire == 0] <- NA

jr_cc <- subset(jrp, jrp$JarTrt == "Control" & jrp$ParentTrt == 400)
dam_jr_cc <- data.frame(id=unique(jr_cc$damID),dam=NA,sire=NA)
sire_jr_cc <- data.frame(id=unique(jr_cc$sireID),dam=NA,sire=NA)
ped_jr_cc <- rbind(dam_jr_cc,sire_jr_cc,data.frame(id=jr_cc$animal,dam=jr_cc$damID,sire=jr_cc$sireID))

# Control Parents - Exposed Offspring 
ce <- subset(pheno, pheno$JarTrt == "Exposed" & pheno$ParentTrt == 400)
dam_ce <- data.frame(id=unique(ce$damID),dam=NA,sire=NA)
sire_ce <- data.frame(id=unique(ce$sireID),dam=NA,sire=NA)
ped_ce <- rbind(dam_ce,sire_ce,data.frame(id=ce$animal,dam=ce$damID,sire=ce$sireID))

ped_ce_brms <- ped_ce
ped_ce_brms$dam[ped_ce$dam == 0] <- NA
ped_ce_brms$sire[ped_ce$sire == 0] <- NA

jr_ce <- subset(jrp, jrp$JarTrt == "Exposed" & jrp$ParentTrt == 400)
dam_jr_ce <- data.frame(id=unique(jr_ce$damID),dam=NA,sire=NA)
sire_jr_ce <- data.frame(id=unique(jr_ce$sireID),dam=NA,sire=NA)
ped_jr_ce <- rbind(dam_jr_ce,sire_jr_ce,data.frame(id=jr_ce$animal,dam=jr_ce$damID,sire=jr_ce$sireID))

# Exposed Parents - Control Offspring 
ec <- subset(pheno, pheno$JarTrt == "Control" & pheno$ParentTrt == 2600)
dam_ec <- data.frame(id=unique(ec$damID),dam=NA,sire=NA)
sire_ec <- data.frame(id=unique(ec$sireID),dam=NA,sire=NA)
ped_ec <- rbind(dam_ec,sire_ec,data.frame(id=ec$animal,dam=ec$damID,sire=ec$sireID))

ped_ec_brms <- ped_ec
ped_ec_brms$dam[ped_ec$dam == 0] <- NA
ped_ec_brms$sire[ped_ec$sire == 0] <- NA

jr_ec <- subset(jrp, jrp$JarTrt == "Control" & jrp$ParentTrt == 2600)
dam_jr_ec <- data.frame(id=unique(jr_ec$damID),dam=NA,sire=NA)
sire_jr_ec <- data.frame(id=unique(jr_ec$sireID),dam=NA,sire=NA)
ped_jr_ec <- rbind(dam_jr_ec,sire_jr_ec,data.frame(id=jr_ec$animal,dam=jr_ec$damID,sire=jr_ec$sireID))

# Exposed Parents - Exposed Offspring 
ee <- subset(pheno, pheno$JarTrt == "Exposed" & pheno$ParentTrt == 2600)
dam_ee <- data.frame(id=unique(ee$damID),dam=NA,sire=NA)
sire_ee <- data.frame(id=unique(ee$sireID),dam=NA,sire=NA)
ped_ee <- rbind(dam_ee,sire_ee,data.frame(id=ee$animal,dam=ee$damID,sire=ee$sireID))

ped_ee_brms <- ped_ee
ped_ee_brms$dam[ped_ee$dam == 0] <- NA
ped_ee_brms$sire[ped_ee$sire == 0] <- NA

jr_ee <- subset(jrp, jrp$JarTrt == "Exposed" & jrp$ParentTrt == 2600)
dam_jr_ee <- data.frame(id=unique(jr_ee$damID),dam=NA,sire=NA)
sire_jr_ee <- data.frame(id=unique(jr_ee$sireID),dam=NA,sire=NA)
ped_jr_ee <- rbind(dam_jr_ee,sire_jr_ee,data.frame(id=jr_ee$animal,dam=jr_ee$damID,sire=jr_ee$sireID))



############################ Priors #########################################

#### Inverse-Wilshart Prior with standard parameterization (uninformative prior)

# NOTE : the inverse wilshart prior requires two parameters to define the distribution,
#       V and nu. In the context of the bayesian prior, V is thought of as the prior
#       expectation and nu is the belief in that prior. In our case, using a small nu
#       (0.002) tells the model we have little belief in the prior (i.e. it is uninformative).

# Two random effects
prior1.2 <- list(R = list(V=1, nu=0.002), G = list(G1 = list(V=1, nu=0.002),
                                                   G2 = list(V=1, nu=0.002)))
## Three random effects with equal priors
prior1.3 <- list(R = list(V=1, nu=0.002), G = list(G1 = list(V=1, nu=0.002),
                                                   G2 = list(V=1, nu=0.002),
                                                   G3 = list(V=1, nu=0.002)))

#### Cauchy priors - used when variance is near zero and for binomial data (see Chapter 8 in Hadley MCMCglmm course notes)
# Also : On the Use of Cauchy Prior Distributions for Bayesian Logistic Regression by Ghosh et al. 2018

## One random effect
prior2.1<-list(R=list(V=1,nu=1),
               G=list(G1=list(V=1,nu=1,alpha.mu=0,alpha.V=1000)))
## Two random effects with equal priors
prior2.2<-list(R=list(V=1,nu=1),
               G=list(G1=list(V=1,nu=1,alpha.mu=0,alpha.V=1000),
                      G2=list(V=1,nu=1,alpha.mu=0,alpha.V=1000)))
## Three random effects with equal priors
prior2.3<-list(R=list(V=1,nu=1),
               G=list(G1=list(V=1,nu=1,alpha.mu=0,alpha.V=1000),
                      G2=list(V=1,nu=1,alpha.mu=0,alpha.V=1000),
                      G3=list(V=1,nu=1,alpha.mu=0,alpha.V=1000)))
prior2.4<-list(R=list(V=1,nu=1),
               G=list(G1=list(V=1,nu=1,alpha.mu=0,alpha.V=1000),
                      G2=list(V=1,nu=1,alpha.mu=0,alpha.V=1000),
                      G3=list(V=1,nu=1,alpha.mu=0,alpha.V=1000),
                      G4=list(V=1,nu=1,alpha.mu=0,alpha.V=1000)))
## Five random effects with equal priors
prior2.5<-list(R=list(V=1,nu=1),
               G=list(G1=list(V=1,nu=1,alpha.mu=0,alpha.V=1000),
                      G2=list(V=1,nu=1,alpha.mu=0,alpha.V=1000),
                      G3=list(V=1,nu=1,alpha.mu=0,alpha.V=1000),
                      G4=list(V=1,nu=1,alpha.mu=0,alpha.V=1000),
                      G5=list(V=1,nu=1,alpha.mu=0,alpha.V=1000)))



############################ MODEL #######################################

# Function: Takes a phenotype, pedigree, and prior information and performs and
#           performs an bayesian model in MCMCglmm for a series of model conditions
#
# Returns : List with model object ('model'), model summary ('model_summary'),
#           summary of variance components ('variance_components'), and dataframe 
#           summarizing model type and heritabilities (`summary`)
#         
# Available models:
#           Model 1 - Full model (animal, dam, sire, Jar, and Seatable as rand effects) - 5 effects
#           Model 2 - Simple (animal as rand effects) - 1 effect
#           Model 3 - Dam and Jar (animal, dam, and Jar as rand effects) - 3 effects
#           Model 4 - Dam and Seatable (animal, dam, and Seatable as rand effects) - 3 effects
#           Model 5 - Dam (animal and dam as rand effects) - 2 effects
#           Model 6 - Dam and Jar and Seatable (animal, dam, jar, and Seatable as rand effects) - 3 effects
#
# Defaults :
#       Iterations - 5000000
#       burnin - 10000
#       thin - 1000
# NOTE : This are pretty conservative settings in line with previous publications and appear to work in most scenarios I have
#         explored, but they DO take time to run.
# Arguments
#   pheno : phenotype data.frame 
#   ped : pedigree matrix
#   prior : list of priors
#   model_name : User provided name which model they are running (Model1-Model5)
#   parentTrt : User provided parental condition
#   offspringTrt : User provided offspring condition

runModel <- function(pheno,ped,prior,responseVariable,model_name,priorName,parentTrt,offspringTrt,nitt=1000000,burnin=10000,thin=1000){
  
  pheno$Response <- pheno[,colnames(pheno) == responseVariable]
  
  print("Starting model....")
  if(model_name == "Model1"){
    model_mcmc  <- MCMCglmm(Response ~ 1,
                            random = ~ animal + damID + sireID + JarID + JarSeatable,
                            family = "gaussian",
                            prior = prior,
                            pedigree = ped,
                            data = pheno,
                            nitt = nitt,
                            burnin = burnin,
                            thin = thin)
  }
  if(model_name == "Model2"){
    model_mcmc  <- MCMCglmm(Response ~ 1,
                            random = ~ animal,
                            family = "gaussian",
                            prior = prior,
                            pedigree = ped,
                            data = pheno,
                            nitt = nitt,
                            burnin = burnin,
                            thin = thin)
  }
  if(model_name == "Model3"){
    model_mcmc  <- MCMCglmm(Response ~ 1,
                            random = ~ animal + damID + JarID,
                            family = "gaussian",
                            prior = prior,
                            pedigree = ped,
                            data = pheno,
                            nitt = nitt,
                            burnin = burnin,
                            thin = thin)
  }
  if(model_name == "Model4"){
    model_mcmc  <- MCMCglmm(Response ~ 1,
                            random = ~ animal + damID + JarSeatable,
                            family = "gaussian",
                            prior = prior,
                            pedigree = ped,
                            data = pheno,
                            nitt = nitt,
                            burnin = burnin,
                            thin = thin)
  }
  if(model_name == "Model5"){
    model_mcmc  <- MCMCglmm(Response ~ 1,
                            random = ~ animal + damID,
                            family = "gaussian",
                            prior = prior,
                            pedigree = ped,
                            data = pheno,
                            nitt = nitt,
                            burnin = burnin,
                            thin = thin)
  }
  if(model_name == "Model6"){
    model_mcmc  <- MCMCglmm(Response ~ 1,
                            random = ~ animal + damID + JarID + JarSeatable,
                            family = "gaussian",
                            prior = prior,
                            pedigree = ped,
                            data = pheno,
                            nitt = nitt,
                            burnin = burnin,
                            thin = thin)
  }
  print("Summarizing model....")
  model_sum <- summary(model_mcmc)
  
  print("Creating dataframe of variance components...")
  mt1 <- data.frame(model_mcmc$VCV)
  mt1$Pheno <- rowSums(mt1)
  mt1$animal_H2 <- mt1$animal / mt1$Pheno
  if(sum(colnames(mt1) == "damID") == 1){
    mt1$dam_H2 <- mt1$damID / mt1$Pheno
  }
  
  print("Creating Summary Table....")
  ### Used to create standard summary table
  eff <- c("animal","damID","sireID","JarID","JarSeatable","Pheno","animal_H2","dam_H2")
  values <- NULL
  for(i in eff){
    if(!is.na(match(i,colnames(mt1)))){
      values <- c(values,mean(mt1[,i]))
      values <- c(values,quantile(mt1[,i],0.025))
      values <- c(values,quantile(mt1[,i],0.975))
    }else{
      values <- c(values,NA)
      values <- c(values,NA)
      values <- c(values,NA)
    }
  }
  col_names <- paste0(rep(eff,each=3),c("_mean","_lower","_upper"))
  values <- data.frame(round(t(as.matrix(values)),5))
  colnames(values) <- col_names
  summary_table <- data.frame(model=model_name,Prior=priorName,ResponseVariable=responseVariable,Parent_Env=parentTrt,Offspring_Env=offspringTrt,values)
  
  return(list(model=model_mcmc,model_summary=model_sum,variance_output=mt1,summary=summary_table))
}

############################ Models ##############################################

### This will take time!

### NOTE : Always make sure that the number of random effects in the prior (i.e. the number after the decimal)
#          matches with the number of random effects in your model (i.e. Model1 has 5 random effects, sort the
#          prior also need 5 random effects).

#           Model 1 - Full model (animal, dam, sire, Jar, and Seatable as rand effects) - 5 effects
#           Model 2 - Simple (animal as rand effects) - 1 effect
#           Model 3 - Dam and Jar (animal, dam, and Jar as rand effects) - 3 effects
#           Model 4 - Dam and Seatable (animal, dam, and Seatable as rand effects) - 3 effects
#           Model 5 - Dam (animal and dam as rand effects) - 2 effects
#           Model 6 - Dam and Jar and Seatable (animal, dam, jar, and Seatable as rand effects) - 4 effects

# Control - Control
    cc_mod1 <- runModel(cc,ped_cc,prior2.5,"Area","Model1","Cauchy","Control","Control") # Individual
    cc_mod2 <- runModel(cc,ped_cc,prior2.1,"Area","Model2","Cauchy","Control","Control") # Individual
    cc_mod3 <- runModel(cc,ped_cc,prior2.3,"Area","Model3","Cauchy","Control","Control") # Individual
    cc_mod4 <- runModel(cc,ped_cc,prior2.3,"Area","Model3","Inv-Wilshart","Control","Control") # Individual - comparison with inv-wilshart prior
    cc_mod5 <- runModel(cc,ped_cc,prior2.3,"Area","Model4","Cauchy","Control","Control") # Individual
    cc_mod6 <- runModel(cc,ped_cc,prior2.2,"Area","Model5","Cauchy","Control","Control") # Individual
    cc_mod7 <- runModel(cc,ped_cc,prior2.4,"Area","Model6","Cauchy","Control","Control") # Individual
    cc_jrp_mod1 <- runModel(jr_cc,ped_jr_cc,prior2.3,"Area","Model4","Cauchy","Control","Control") # Family
    cc_jrp_mod2 <- runModel(jr_cc,ped_jr_cc,prior2.2,"Area","Model5","Cauchy","Control","Control") # Family
    cc_list <- list(mod1=cc_mod1,mod2=cc_mod2,mod3=cc_mod3,mod4=cc_mod4,mod5=cc_mod5,mod6=cc_mod6,mod7=cc_mod7,mod1_jr=cc_jrp_mod1,mod2_jr=cc_jrp_mod2)
    saveRDS(cc_list,"~/Desktop/GrowthHeritabilityEstimate_cc.RDS")
    remove(cc_mod1)
    remove(cc_mod2)
    remove(cc_mod3)
    remove(cc_mod4)
    remove(cc_mod6)
    remove(cc_mod7)
    remove(cc_jrp_mod1)
    remove(cc_jrp_mod2)
    remove(cc_list)
    
# Control - Exposed
    ce_mod1 <- runModel(ce,ped_ce,prior2.5,"Area","Model1","Cauchy","Control","Exposed") # Individual
    ce_mod2 <- runModel(ce,ped_ce,prior2.1,"Area","Model2","Cauchy","Control","Exposed") # Individual
    ce_mod3 <- runModel(ce,ped_ce,prior2.3,"Area","Model3","Cauchy","Control","Exposed") # Individual
    ce_mod4 <- runModel(ce,ped_ce,prior2.3,"Area","Model3","Inv-Wilshart","Control","Exposed") # Individual - comparison with inv-wilshart prior
    ce_mod5 <- runModel(ce,ped_ce,prior2.3,"Area","Model4","Cauchy","Control","Exposed") # Individual
    ce_mod6 <- runModel(ce,ped_ce,prior2.2,"Area","Model5","Cauchy","Control","Exposed") # Individual
    ce_mod7 <- runModel(ce,ped_ce,prior2.4,"Area","Model6","Cauchy","Control","Exposed") # Individual
    ce_jrp_mod1 <- runModel(jr_ce,ped_jr_ce,prior2.3,"Area","Model4","Cauchy","Control","Exposed") # Family
    ce_jrp_mod2 <- runModel(jr_ce,ped_jr_ce,prior2.2,"Area","Model5","Cauchy","Control","Exposed") # Family
    ce_list <- list(mod1=ce_mod1,mod2=ce_mod2,mod3=ce_mod3,mod4=ce_mod4,mod5=ce_mod5,mod6=ce_mod6,mod7=ce_mod7,mod1_jr=ce_jrp_mod1,mod2_jr=ce_jrp_mod2)
    saveRDS(ce_list,"~/Desktop/GrowthHeritabilityEstimate_ce.RDS")
    remove(ce_mod1)
    remove(ce_mod2)
    remove(ce_mod3)
    remove(ce_mod4)
    remove(ce_mod6)
    remove(ce_mod7)
    remove(ce_jrp_mod1)
    remove(ce_jrp_mod2)
    remove(ce_list)
    
    
# Exposed - Control
    ec_mod1 <- runModel(ec,ped_ec,prior2.5,"Area","Model1","Cauchy","Exposed","Control") # Individual
    ec_mod2 <- runModel(ec,ped_ec,prior2.1,"Area","Model2","Cauchy","Exposed","Control") # Individual
    ec_mod3 <- runModel(ec,ped_ec,prior2.3,"Area","Model3","Cauchy","Exposed","Control") # Individual
    ec_mod4 <- runModel(ec,ped_ec,prior2.3,"Area","Model3","Inv-Wilshart","Exposed","Control") # Individual - comparison with inv-wilshart prior
    ec_mod5 <- runModel(ec,ped_ec,prior2.3,"Area","Model4","Cauchy","Exposed","Control") # Individual
    ec_mod6 <- runModel(ec,ped_ec,prior2.2,"Area","Model5","Cauchy","Exposed","Control") # Individual
    ec_mod7 <- runModel(ec,ped_ec,prior2.4,"Area","Model6","Cauchy","Exposed","Control") # Individual
    ec_jrp_mod1 <- runModel(jr_ec,ped_jr_ec,prior2.3,"Area","Model4","Cauchy","Exposed","Control") # Family
    ec_jrp_mod2 <- runModel(jr_ec,ped_jr_ec,prior2.2,"Area","Model5","Cauchy","Exposed","Control") # Family
    ec_list <- list(mod1=ec_mod1,mod2=ec_mod2,mod3=ec_mod3,mod4=ec_mod4,mod5=ec_mod5,mod6=ec_mod6,mod7=ec_mod7,mod1_jr=ec_jrp_mod1,mod2_jr=ec_jrp_mod2)
    saveRDS(ec_list,"~/Desktop/GrowthHeritabilityEstimate_ec.RDS")
    remove(ec_mod1)
    remove(ec_mod2)
    remove(ec_mod3)
    remove(ec_mod4)
    remove(ec_mod6)
    remove(ec_mod7)
    remove(ec_jrp_mod1)
    remove(ec_jrp_mod2)
    remove(ec_list)
    
# Exposed - Exposed
    ee_mod1 <- runModel(ee,ped_ee,prior2.5,"Area","Model1","Cauchy","Exposed","Exposed") # Individual
    ee_mod2 <- runModel(ee,ped_ee,prior2.1,"Area","Model2","Cauchy","Exposed","Exposed") # Individual
    ee_mod3 <- runModel(ee,ped_ee,prior2.3,"Area","Model3","Cauchy","Exposed","Exposed") # Individual
    ee_mod4 <- runModel(ee,ped_ee,prior2.3,"Area","Model3","Inv-Wilshart","Exposed","Exposed") # Individual - comparison with inv-wilshart prior
    ee_mod5 <- runModel(ee,ped_ee,prior2.3,"Area","Model4","Cauchy","Exposed","Exposed") # Individual
    ee_mod6 <- runModel(ee,ped_ee,prior2.2,"Area","Model5","Cauchy","Exposed","Exposed") # Individual
    ee_mod7 <- runModel(ee,ped_ee,prior2.4,"Area","Model6","Cauchy","Exposed","Exposed") # Individual
    ee_jrp_mod1 <- runModel(jr_ee,ped_jr_ee,prior2.3,"Area","Model4","Cauchy","Exposed","Exposed") # Family
    ee_jrp_mod2 <- runModel(jr_ee,ped_jr_ee,prior2.2,"Area","Model5","Cauchy","Exposed","Exposed") # Family
    ee_list <- list(mod1=ee_mod1,mod2=ee_mod2,mod3=ee_mod3,mod4=ee_mod4,mod5=ee_mod5,mod6=ee_mod6,mod7=ee_mod7,mod1_jr=ee_jrp_mod1,mod2_jr=ee_jrp_mod2)
    saveRDS(ee_list,"~/Desktop/GrowthHeritabilityEstimate_ee.RDS")
    remove(ee_mod1)
    remove(ee_mod2)
    remove(ee_mod3)
    remove(ee_mod4)
    remove(ee_mod6)
    remove(ee_mod7)
    remove(ee_jrp_mod1)
    remove(ee_jrp_mod2)
    remove(ee_list)
    
    
############################ Read-in model data ####################################### 
    
cc_list <- readRDS("~/Desktop/GrowthHeritabilityEstimate_cc.RDS")
ce_list <- readRDS("~/Desktop/GrowthHeritabilityEstimate_ce.RDS")
ec_list <- readRDS("~/Desktop/GrowthHeritabilityEstimate_ec.RDS")
ee_list <- readRDS("~/Desktop/GrowthHeritabilityEstimate_ee.RDS")
mod_output <- list(cc=cc_list,ce=ce_list,ec=ec_list,ee=ee_list)
saveRDS(mod_output,"~/Desktop/GrowthHeritabilityEstimate.RDS")
remove(cc_list)
remove(ce_list)
remove(ec_list)
remove(ee_list)

############################ Single Model Run Script ################################## 

model_mcmc  <- MCMCglmm(Area ~ 1,
                        random = ~ animal + damID + JarID,
                        family = "gaussian",
                        prior = prior1.3,
                        pedigree = ped_cc,
                        data = cc,
                        nitt = 50000,
                        burnin = 10000,
                        thin = 1000)

model_jar_mcmc  <- MCMCglmm(scale(Area) ~ 1,
                        random = ~ animal + damID,
                        family = "gaussian",
                        prior = prior2.2,
                        pedigree = ped_jr_cc,
                        data = jr_cc,
                        nitt = 500000,
                        burnin = 10000,
                        thin = 1000)
model_mcmc <- model_jar_mcmc
saveRDS(model_mcmc,"~/Desktop/L18GrowthHeritabilityModel_ind_damJar.RDS")
#model_mcmc <- readRDS("~/Desktop/L18GrowthHeritabilityModel.RDS")

#### Model Summary ##
summary(model_mcmc)

#### Diagnostics ## 
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

## Plot for visualizing all random variance components
ref <- data.frame(model_mcmc$VCV)
rdf <- melt(ref,value.name="GrowthRate") # Replace growth rate is using another phenotype
density_plot <- ggplot(rdf,aes(x=sqrt(GrowthRate),color=variable)) + 
  #xlim(0,1) +
  geom_density() +
  labs(x="") +
  theme_cowplot() +
  theme(legend.position = "none")
boxplot_plot <- ggplot(rdf,aes(x=sqrt(GrowthRate),y=variable,color=variable)) + 
  #xlim(0,1) +
  geom_boxplot() +
  labs(x="Growth Rate Components of Variation (SD)") +
  theme_cowplot() +
  theme(legend.position = "none")
p1 <- plot_grid(density_plot,boxplot_plot,ncol = 1,align="v")
p1
# Plot animal and dam in 2d plot to examine covariation 
ggplot(ref, aes(x=sqrt(animal),y=sqrt(damID))) + 
  geom_point(alpha=0.5) +
  #xlim(0,1.5) + ylim(0,1.5) +
  labs(x="Animal Variance Component (SD)",y="Dam Variance Component (SD)") + 
  geom_density2d() + 
  geom_abline(int=0,slope=1) +
  theme_cowplot()


##### Heritability Estimates ######
animal_h2 <- model_mcmc$VCV[,colnames(model_mcmc$VCV)== "animal"] / rowSums(model_mcmc$VCV)
dam_h2 <- model_mcmc$VCV[,colnames(model_mcmc$VCV)== "damID"] / rowSums(model_mcmc$VCV)
h2_estimates <- data.frame(Component=c(rep("animal",times=length(animal_h2)),rep("dam",times=length(dam_h2))),
                           heritability=c(animal_h2,dam_h2))
h2 <- ggplot(h2_estimates,aes(x=Component,y=heritability)) +
  geom_boxplot() + 
  theme_cowplot()

plot_grid(p1,h2,ncol=2)

# colnames(model_mcmc$VCV)
# animal_var <-  model_mcmc$VCV[, "animal"]
# dam_var <-  model_mcmc$VCV[, "damID"]
# jarTrt_var <-  model_mcmc$VCV[, "JarID"]
# jarSeaTable_var <-  model_mcmc$VCV[, "JarSeatable"]
# error_var <-  model_mcmc$VCV[, "units"]
# p_var <- c(animal_var+dam_var+jarTrt_var+jarSeaTable_var+error_var)
# 
# mcmc_summary  <- data.frame(ParentTrt ="Control",
#                             Offspring="Control",
#                             Model="Model_1",
#                             N = nrow(cc),
#                             Va_mean=mean(animal_var),
#                             Va_lower=quantile(animal_var, 0.025),
#                             Va_upper=quantile(animal_var, 0.975),
#                             Vdam_mean=mean(dam_var),
#                             Vdam_lower=quantile(dam_var, 0.025),
#                             Vdam_upper=quantile(dam_var, 0.975),
#                             VJarTrt_mean=mean(jarTrt_var),
#                             VJarTrt_lower=quantile(jarTrt_var, 0.025),
#                             VJarTrt_upper=quantile(jarTrt_var, 0.975),
#                             Vtable_mean=mean(jarSeaTable_var),
#                             Vtable_lower=quantile(jarSeaTable_var, 0.025),
#                             Vtable_upper=quantile(jarSeaTable_var, 0.975),
#                             Verror_mean=mean(error_var),
#                             Verror_lower=quantile(error_var, 0.025),
#                             Verror_upper=quantile(error_var, 0.975),
#                             Vp_mean=mean(p_var),
#                             Vp_lower=quantile(p_var, 0.025),
#                             Vp_upper=quantile(p_var, 0.975),
#                             H2_animal_mean=mean(animal_h2),
#                             H2_animal_lower=quantile(animal_h2, 0.025),
#                             H2_animal_upper=quantile(animal_h2, 0.975),
#                             H2_dam_mean=mean(dam_h2),
#                             H2_dam_lower=quantile(dam_h2, 0.025),
#                             H2_dam_upper=quantile(dam_h2, 0.975))
# ## Barplot


