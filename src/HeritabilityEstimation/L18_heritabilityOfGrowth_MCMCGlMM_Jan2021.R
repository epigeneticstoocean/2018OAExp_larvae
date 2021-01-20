
library(MCMCglmm)
library(ggplot2)
library(ggpubr)
library(cowplot)
library(dplyr)
library(knitr)
library(brms)
library(rstan)
options(mc.cores = parallel::detectCores())
rstan_options(auto_write = TRUE)

jr <- readRDS("~/Github/2018OAExp_larvae/input_files/JarHeritabilityData.RDS")
ind <- readRDS("~/Github/2018OAExp_larvae/input_files/IndHeritabilityData.RDS")

pheno <- ind$pheno
hist(pheno$GrowthPerDay)
pheno$GrowthScale <-scale(pheno$GrowthPerDay)
ped1 <- jr$ped
jrp <- jr$pheno
jrp$GrowthScale <-scale(jrp$Growth)

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

prior1.3 <- list(R = list(V=1, nu=0.002), G = list(G1 = list(V=1, nu=0.002),
                                                   G2 = list(V=1, nu=0.002),
                                                   G3 = list(V=1, nu=0.002)))

prior2.2<-list(R=list(V=1,nu=1),
               G=list(G1=list(V=1,nu=1,alpha.mu=0,alpha.V=1000),
                      G2=list(V=1,nu=1,alpha.mu=0,alpha.V=1000)))

prior2.3<-list(R=list(V=1,nu=1),
               G=list(G1=list(V=1,nu=1,alpha.mu=0,alpha.V=1000),
                      G2=list(V=1,nu=1,alpha.mu=0,alpha.V=1000),
                      G3=list(V=1,nu=1,alpha.mu=0,alpha.V=1000)))

prior2.5<-list(R=list(V=1,nu=1),
               G=list(G1=list(V=1,nu=1,alpha.mu=0,alpha.V=1000),
                      G2=list(V=1,nu=1,alpha.mu=0,alpha.V=1000),
                      G3=list(V=1,nu=1,alpha.mu=0,alpha.V=1000),
                      G4=list(V=1,nu=1,alpha.mu=0,alpha.V=1000),
                      G5=list(V=1,nu=1,alpha.mu=0,alpha.V=1000)))

            # Control - Control
                cc_mod1 <- runModel(cc,ped_cc,prior2.5,"Model1","Control","Control")
                cc_mod2 <- runModel(cc,ped_cc,prior2.3,"Model2","Control","Control")
                cc_mod3 <- runModel(cc,ped_cc,prior1.3,"Model3","Control","Control")
                cc_mod4 <- runModel(jr_cc,ped_jr_cc,prior2.3,"Model4","Control","Control")
                cc_mod5 <- runModel(jr_cc,ped_jr_cc,prior2.2,"Model5","Control","Control")
                cc <- list(mod1=cc_mod1,mod2=cc_mod2,mod3=cc_mod3,mod4=cc_mod4,mod5=cc_mod5)
                saveRDS(cc,"~/Desktop/GrowthHeritabilityEstimate_cc.RDS")
                remove(cc_mod1)
                remove(cc_mod2)
                remove(cc_mod3)
                remove(cc_mod4)
                remove(cc_mod5)
                remove(cc)
            # Control - Exposed
                ce_mod1 <- runModel(ce,ped_ce,prior2.5,"Model1","Control","Exposed")
                ce_mod2 <- runModel(ce,ped_ce,prior2.3,"Model2","Control","Exposed")
                ce_mod3 <- runModel(ce,ped_ce,prior1.3,"Model3","Control","Exposed")
                ce_mod4 <- runModel(jr_ce,ped_jr_ce,prior2.3,"Model4","Control","Exposed")
                ce_mod5 <- runModel(jr_ce,ped_jr_ce,prior2.2,"Model5","Control","Exposed")
                ce <- list(mod1=ce_mod1,mod2=ce_mod2,mod3=ce_mod3,mod4=ce_mod4,mod5=ce_mod5)
                saveRDS(ce,"~/Desktop/GrowthHeritabilityEstimate_ce.RDS")
                remove(ce_mod1)
                remove(ce_mod2)
                remove(ce_mod3)
                remove(ce_mod4)
                remove(ce_mod5)
                remove(ce)
            # Exposed - Control
                ec_mod1 <- runModel(ec,ped_ec,prior2.5,"Model1","Exposed","Control")
                ec_mod2 <- runModel(ec,ped_ec,prior2.3,"Model2","Exposed","Control")
                ec_mod3 <- runModel(ec,ped_ec,prior1.3,"Model3","Exposed","Control")
                ec_mod4 <- runModel(jr_ec,ped_jr_ec,prior2.3,"Model4","Exposed","Control")
                ec_mod5 <- runModel(jr_ec,ped_jr_ec,prior2.2,"Model5","Exposed","Control")
                ec <- list(mod1=ec_mod1,mod2=ec_mod2,mod3=ec_mod3,mod4=ec_mod4,mod5=ec_mod5)
                saveRDS(ec,"~/Desktop/GrowthHeritabilityEstimate_ec.RDS")
                remove(ec_mod1)
                remove(ec_mod2)
                remove(ec_mod3)
                remove(ec_mod4)
                remove(ec_mod5)
                remove(ec)
            # Exposed - Exposed
                ee_mod1 <- runModel(ee,ped_ee,prior2.5,"Model1","Exposed","Exposed")
                ee_mod2 <- runModel(ee,ped_ee,prior2.3,"Model2","Exposed","Exposed")
                ee_mod3 <- runModel(ee,ped_ee,prior1.3,"Model3","Exposed","Exposed")
                ee_mod4 <- runModel(jr_ee,ped_jr_ee,prior2.3,"Model4","Exposed","Exposed")
                ee_mod5 <- runModel(jr_ee,ped_jr_ee,prior2.2,"Model5","Exposed","Exposed")
                ee <- list(mod1=ee_mod1,mod2=ee_mod2,mod3=ee_mod3,mod4=ee_mod4,mod5=ee_mod5)
                saveRDS(ee,"~/Desktop/GrowthHeritabilityEstimate_ee.RDS")
                remove(ee_mod1)
                remove(ee_mod2)
                remove(ee_mod3)
                remove(ee_mod4)
                remove(ee_mod5)
                remove(ee)
    
    cc <- readRDS("~/Desktop/GrowthHeritabilityEstimate_cc.RDS")
    ce <- readRDS("~/Desktop/GrowthHeritabilityEstimate_ce.RDS")
    ec <- readRDS("~/Desktop/GrowthHeritabilityEstimate_ec.RDS")
    ee <- readRDS("~/Desktop/GrowthHeritabilityEstimate_ee.RDS")
    mod_output <- list(cc=cc,ce=ce,ec=ec,ee=ee)
    saveRDS(mod_output,"~/Desktop/GrowthHeritabilityEstimate.RDS")
    remove(cc,ce,ec,ee)

sumTab <- NULL 
## Diagnostics
for(i in mod_output){
  for(j in i){
    print(paste(j$summary[,1:3]))
    sumTab <- rbind(sumTab,j$summary)
    #print(j$model_summary)
    # Plot of posteriors
    #plot(j$model$Sol,ask=F)
    #plot(j$model$VCV,ask=F)
    # Autocorrelation assessment
    print(autocorr.diag(j$model$Sol))
    print(autocorr.diag(j$model$VCV))
    # Effective sample size
    print(effectiveSize(j$model$Sol))
    print(effectiveSize(j$model$VCV))
    # Test of model convergence
    print(heidel.diag(j$model$VCV))
  }
}

kable(sumTab)

animal_plot <- ggplot(sumTab,aes(x=interaction(Parent_Env,Offspring_Env,model),
                  y=animal_H2_mean,
                  group=interaction(model,Parent_Env,Offspring_Env),
                  #linetype=model,
                  colour=interaction(Parent_Env,Offspring_Env))) + 
  geom_point() + 
  geom_errorbar(aes(ymin=animal_H2_lower,ymax=animal_H2_upper)) +
  theme_cowplot() + 
  #annotate(geom = "text", x = seq_len(nrow(sumTab)), y = -0.05, label = rep(unique(sumTab$model),each=4), size = 4,angle=45) +
  annotate(geom = "text", x = 2.5+4*c(0:4), y = -0.1, label = unique(sumTab$model), size = 6) +
    coord_cartesian(ylim = c(-0.02,1), expand = FALSE, clip = "off") +
  labs(y="Heritability",title="Animal",colour="Parent.Offspring \n    Environment") +
  theme(plot.margin = unit(c(1, 1, 4, 1), "lines"),
        axis.title.x = element_blank(),
        axis.text.x = element_blank(),
        panel.grid.major.x = element_blank(),
        panel.grid.minor.x = element_blank())

dam_plot <- ggplot(sumTab,aes(x=interaction(Parent_Env,Offspring_Env,model),
                                 y=dam_H2_mean,
                                 group=interaction(model,Parent_Env,Offspring_Env),
                                 #linetype=model,
                                 colour=interaction(Parent_Env,Offspring_Env))) + 
  geom_point() + 
  geom_errorbar(aes(ymin=dam_H2_lower,ymax=dam_H2_upper)) +
  theme_cowplot() + 
  #annotate(geom = "text", x = seq_len(nrow(sumTab)), y = -0.05, label = rep(unique(sumTab$model),each=4), size = 4,angle=45) +
  annotate(geom = "text", x = 2.5+4*c(0:4), y = -0.1, label = unique(sumTab$model), size = 6) +
  coord_cartesian(ylim = c(-0.02,1), expand = FALSE, clip = "off") +
  labs(y="Heritability",title="Dam",colour="Parent.Offspring \n    Environment") +
  theme(plot.margin = unit(c(1, 1, 4, 1), "lines"),
        axis.title.x = element_blank(),
        axis.text.x = element_blank(),
        panel.grid.major.x = element_blank(),
        panel.grid.minor.x = element_blank())

plot_grid(animal_plot,dam_plot,nrow=2)

runModel <- function(pheno,ped,prior,model_name,parentTrt,offspringTrt){
  if(model_name == "Model1"){
    model_mcmc  <- MCMCglmm(GrowthScale ~ 1,
                            random = ~ animal + damID + sireID + JarID + JarSeatable,
                            family = "gaussian",
                            prior = prior,
                            pedigree = ped,
                            data = pheno,
                            nitt = 5000000,
                            burnin = 10000,
                            thin = 1000)
  }
  if(model_name == "Model2"){
    model_mcmc  <- MCMCglmm(GrowthScale ~ 1,
                             random = ~ animal + damID + JarID ,
                             family = "gaussian",
                             prior = prior,
                             pedigree = ped,
                             data = pheno,
                             nitt = 5000000,
                             burnin = 10000,
                             thin = 1000)
  }
  if(model_name == "Model3"){
    model_mcmc  <- MCMCglmm(GrowthScale ~ 1,
                             random = ~ animal + damID + JarID,
                             family = "gaussian",
                             prior = prior,
                             pedigree = ped,
                             data = pheno,
                             nitt = 5000000,
                             burnin = 10000,
                             thin = 1000)
  }
  if(model_name == "Model4"){
    model_mcmc  <- MCMCglmm(GrowthScale ~ 1,
                             random = ~ animal + damID + SeaTable,
                             family = "gaussian",
                             prior = prior,
                             pedigree = ped,
                             data = pheno,
                             nitt = 1000000,
                             burnin = 10000,
                             thin = 500)
  }
  if(model_name == "Model5"){
    model_mcmc  <- MCMCglmm(GrowthScale ~ 1,
                             random = ~ animal + damID,
                             family = "gaussian",
                             prior = prior,
                             pedigree = ped,
                             data = pheno,
                             nitt = 1000000,
                             burnin = 10000,
                             thin = 500)
  }
  
  model_sum <- summary(model_mcmc)
  list_var <- list()
  for(i in 1:ncol(model_mcmc$VCV)){
    list_var[[i]] <- model_mcmc$VCV[,colnames(model_mcmc$VCV)[i]]
  }
  names(list_var)<-colnames(model_mcmc$VCV)
  mt1 <- data.frame(matrix(unlist(list_var), ncol = length(colnames(model_mcmc$VCV)), byrow = F))
  colnames(mt1)<-colnames(model_mcmc$VCV)
  mt1$Pheno <- rowSums(mt1)
  mt1$animal_H2 <- mt1$animal / mt1$Pheno
  mt1$dam_H2 <- mt1$damID / mt1$Pheno
  
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
  summary_table <- data.frame(model=model_name,Parent_Env=parentTrt,Offspring_Env=offspringTrt,values)
  
  return(list(model=model_mcmc,model_summary=model_sum,variance_output=mt1,summary=summary_table))
}

## Single Runs 
model_mcmc  <- MCMCglmm(GrowthScale ~ 1,
                        random = ~ animal + damID + sireID + JarID + JarSeatable,
                        family = "gaussian",
                        prior = prior2.5,
                        pedigree = ped_cc,
                        data = cc,
                        nitt = 5000000,
                        burnin = 10000,
                        thin = 1000)

saveRDS(model_mcmc,"~/Desktop/L18GrowthHeritabilityModel.RDS")
model_mcmc <- readRDS("~/Desktop/L18GrowthHeritabilityModel.RDS")
summary(model_mcmc)
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

colnames(model_mcmc$VCV)
animal_var <-  model_mcmc$VCV[, "animal"]
dam_var <-  model_mcmc$VCV[, "damID"]
sire_var <-  model_mcmc$VCV[, "sireID"]
jarTrt_var <-  model_mcmc$VCV[, "JarID"]
jarSeaTable_var <-  model_mcmc$VCV[, "JarSeatable"]
error_var <-  model_mcmc$VCV[, "units"]
p_var <- c(animal_var+dam_var+sire_var+jarTrt_var+jarSeaTable_var+error_var)

animal_h2 <- animal_var / c(animal_var+dam_var+sire_var+jarTrt_var+jarSeaTable_var+error_var)
dam_h2 <- dam_var / c(animal_var+dam_var+sire_var+jarTrt_var+jarSeaTable_var+error_var)


mcmc_summary  <- data.frame(ParentTrt ="Control",
                            Offspring="Control",
                            Model="Model_1",
                            N = nrow(cc),
                            Va_mean=mean(animal_var),
                            Va_lower=quantile(animal_var, 0.025),
                            Va_upper=quantile(animal_var, 0.975),
                            Vdam_mean=mean(dam_var),
                            Vdam_lower=quantile(dam_var, 0.025),
                            Vdam_upper=quantile(dam_var, 0.975),
                            Vsire_mean=mean(sire_var),
                            Vsire_lower=quantile(sire_var, 0.025),
                            Vsire_upper=quantile(sire_var, 0.975),
                            VJarTrt_mean=mean(jarTrt_var),
                            VJarTrt_lower=quantile(jarTrt_var, 0.025),
                            VJarTrt_upper=quantile(jarTrt_var, 0.975),
                            Vtable_mean=mean(jarSeaTable_var),
                            Vtable_lower=quantile(jarSeaTable_var, 0.025),
                            Vtable_upper=quantile(jarSeaTable_var, 0.975),
                            Verror_mean=mean(error_var),
                            Verror_lower=quantile(error_var, 0.025),
                            Verror_upper=quantile(error_var, 0.975),
                            Vp_mean=mean(p_var),
                            Vp_lower=quantile(p_var, 0.025),
                            Vp_upper=quantile(p_var, 0.975),
                            H2_animal_mean=mean(animal_h2),
                            H2_animal_lower=quantile(animal_h2, 0.025),
                            H2_animal_upper=quantile(animal_h2, 0.975),
                            H2_dam_mean=mean(dam_h2),
                            H2_dam_lower=quantile(dam_h2, 0.025),
                            H2_dam_upper=quantile(dam_h2, 0.975))
                            

model2_mcmc  <- MCMCglmm(GrowthScale ~ 1,
                        random = ~ animal + damID + JarID ,
                        family = "gaussian",
                        prior = prior2.3,
                        pedigree = ped_cc,
                        data = cc,
                        nitt = 1000000,
                        burnin = 10000,
                        thin = 200)

saveRDS(model2_mcmc,"~/Desktop/L18GrowthHeritabilityModel2.RDS")
model2_mcmc <- readRDS("~/Desktop/L18GrowthHeritabilityModel2.RDS")
summary(model2_mcmc)
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

animal_var2 <-  model2_mcmc$VCV[, "animal"]
dam_var2 <-  model2_mcmc$VCV[, "damID"]
jarTrt_var2 <-  model2_mcmc$VCV[, "JarID"]
error_var2 <-  model2_mcmc$VCV[, "units"]
p_var2 <- c(animal_var2+dam_var2+jarTrt_var2+error_var2)

animal2_h2 <- animal_var2 / p_var2
dam2_h2 <- dam_var2 / p_var2

mcmc2_summary  <- data.frame(ParentTrt ="Control",
                            Offspring="Control",
                            Model="Model_2",
                            N = nrow(cc),
                            Va_mean=mean(animal_var2),
                            Va_lower=quantile(animal_var2, 0.025),
                            Va_upper=quantile(animal_var2, 0.975),
                            Vdam_mean=mean(dam_var2),
                            Vdam_lower=quantile(dam_var2, 0.025),
                            Vdam_upper=quantile(dam_var2, 0.975),
                            Vsire_mean=NA,
                            Vsire_lower=NA,
                            Vsire_upper=NA,
                            VJarTrt_mean=mean(jarTrt_var2),
                            VJarTrt_lower=quantile(jarTrt_var2, 0.025),
                            VJarTrt_upper=quantile(jarTrt_var2, 0.975),
                            Vtable_mean=NA,
                            Vtable_lower=NA,
                            Vtable_upper=NA,
                            Verror_mean=mean(error_var2),
                            Verror_lower=quantile(error_var2, 0.025),
                            Verror_upper=quantile(error_var2, 0.975),
                            Vp_mean=mean(p_var2),
                            Vp_lower=quantile(p_var2, 0.025),
                            Vp_upper=quantile(p_var2, 0.975),
                            H2_animal_mean=mean(animal2_h2),
                            H2_animal_lower=quantile(animal2_h2, 0.025),
                            H2_animal_upper=quantile(animal2_h2, 0.975),
                            H2_dam_mean=mean(dam2_h2),
                            H2_dam_lower=quantile(dam2_h2, 0.025),
                            H2_dam_upper=quantile(dam2_h2, 0.975))


model3_mcmc  <- MCMCglmm(GrowthScale ~ 1,
                         random = ~ animal + damID + JarID,
                         family = "gaussian",
                         prior = prior1.3,
                         pedigree = ped_cc,
                         data = cc,
                         nitt = 5000000,
                         burnin = 10000,
                         thin = 200)

saveRDS(model3_mcmc,"~/Desktop/L18GrowthHeritabilityModel3.RDS")
model3_mcmc <- readRDS("~/Desktop/L18GrowthHeritabilityModel3.RDS")
summary(model3_mcmc)
# Traces for fixed effects
plot(model3_mcmc$Sol)
# Traces for random effects
plot(model3_mcmc$VCV)
## Auto-correlation among lag steps
autocorr.diag(model3_mcmc$Sol)
autocorr.diag(model3_mcmc$VCV)

## Effective sample size
effectiveSize(model3_mcmc$Sol)
effectiveSize(model3_mcmc$VCV)

## Test of model convergence
heidel.diag(model3_mcmc$VCV)

animal_var3 <-  model3_mcmc$VCV[, "animal"]
dam_var3 <-  model3_mcmc$VCV[, "damID"]
jarTrt_var3 <-  model3_mcmc$VCV[, "JarID"]
error_var3 <-  model3_mcmc$VCV[, "units"]
p_var3 <- c(animal_var3+dam_var3+jarTrt_var3+error_var3)

animal3_h2 <- animal_var3 / p_var3
dam3_h2 <- dam_var3 / p_var3

mcmc3_summary  <- data.frame(ParentTrt ="Control",
                             Offspring="Control",
                             Model="Model_3",
                             N = nrow(cc),
                             Va_mean=mean(animal_var3),
                             Va_lower=quantile(animal_var3, 0.025),
                             Va_upper=quantile(animal_var3, 0.975),
                             Vdam_mean=mean(dam_var3),
                             Vdam_lower=quantile(dam_var3, 0.025),
                             Vdam_upper=quantile(dam_var3, 0.975),
                             Vsire_mean=NA,
                             Vsire_lower=NA,
                             Vsire_upper=NA,
                             VJarTrt_mean=mean(jarTrt_var3),
                             VJarTrt_lower=quantile(jarTrt_var3, 0.025),
                             VJarTrt_upper=quantile(jarTrt_var3, 0.975),
                             Vtable_mean=NA,
                             Vtable_lower=NA,
                             Vtable_upper=NA,
                             Verror_mean=mean(error_var3),
                             Verror_lower=quantile(error_var3, 0.025),
                             Verror_upper=quantile(error_var3, 0.975),
                             Vp_mean=mean(p_var3),
                             Vp_lower=quantile(p_var3, 0.025),
                             Vp_upper=quantile(p_var3, 0.975),
                             H2_animal_mean=mean(animal3_h2),
                             H2_animal_lower=quantile(animal3_h2, 0.025),
                             H2_animal_upper=quantile(animal3_h2, 0.975),
                             H2_dam_mean=mean(dam3_h2),
                             H2_dam_lower=quantile(dam3_h2, 0.025),
                             H2_dam_upper=quantile(dam3_h2, 0.975))

model4_mcmc  <- MCMCglmm(GrowthScale ~ 1,
                        random = ~ animal + damID + SeaTable,
                        family = "gaussian",
                        prior = prior2.3,
                        pedigree = ped_jr_cc,
                        data = jr_cc,
                        nitt = 1000000,
                        burnin = 10000,
                        thin = 200)

saveRDS(model4_mcmc,"~/Desktop/L18GrowthHeritabilityModel4.RDS")

summary(model4_mcmc)
# Traces for fixed effects
plot(model4_mcmc$Sol)
# Traces for random effects
plot(model4_mcmc$VCV)
## Auto-correlation among lag steps
autocorr.diag(model4_mcmc$Sol)
autocorr.diag(model4_mcmc$VCV)

## Effective sample size
effectiveSize(model4_mcmc$Sol)
effectiveSize(model4_mcmc$VCV)

## Test of model convergence
heidel.diag(model4_mcmc$VCV)

animal_var4 <-  model4_mcmc$VCV[, "animal"]
dam_var4 <-  model4_mcmc$VCV[, "damID"]
jarTrt_var4 <-  model4_mcmc$VCV[, "SeaTable"]
error_var4 <-  model4_mcmc$VCV[, "units"]
p_var4 <- c(animal_var4+dam_var4+jarTrt_var4+error_var4)

animal4_h2 <- animal_var4 / p_var4
dam4_h2 <- dam_var4 / p_var4

mcmc4_summary  <- data.frame(ParentTrt ="Control",
                             Offspring="Control",
                             Model="Model_4",
                             N = nrow(jr_cc),
                             Va_mean=mean(animal_var4),
                             Va_lower=quantile(animal_var4, 0.025),
                             Va_upper=quantile(animal_var4, 0.975),
                             Vdam_mean=mean(dam_var4),
                             Vdam_lower=quantile(dam_var4, 0.025),
                             Vdam_upper=quantile(dam_var4, 0.975),
                             Vsire_mean=NA,
                             Vsire_lower=NA,
                             Vsire_upper=NA,
                             VJarTrt_mean=NA,
                             VJarTrt_lower=NA,
                             VJarTrt_upper=NA,
                             Vtable_mean=mean(jarTrt_var4),
                             Vtable_lower=quantile(jarTrt_var4, 0.025),
                             Vtable_upper=quantile(jarTrt_var4, 0.975),
                             Verror_mean=mean(error_var4),
                             Verror_lower=quantile(error_var4, 0.025),
                             Verror_upper=quantile(error_var4, 0.975),
                             Vp_mean=mean(p_var4),
                             Vp_lower=quantile(p_var4, 0.025),
                             Vp_upper=quantile(p_var4, 0.975),
                             H2_animal_mean=mean(animal4_h2),
                             H2_animal_lower=quantile(animal4_h2, 0.025),
                             H2_animal_upper=quantile(animal4_h2, 0.975),
                             H2_dam_mean=mean(dam4_h2),
                             H2_dam_lower=quantile(dam4_h2, 0.025),
                             H2_dam_upper=quantile(dam4_h2, 0.975))

model5_mcmc  <- MCMCglmm(GrowthScale ~ 1,
                         random = ~ animal + damID,
                         family = "gaussian",
                         prior = prior2.2,
                         pedigree = ped_jr_cc,
                         data = jr_cc,
                         nitt = 1000000,
                         burnin = 10000,
                         thin = 200)

saveRDS(model5_mcmc,"~/Desktop/L18GrowthHeritabilityModel5.RDS")

summary(model5_mcmc)
# Traces for fixed effects
plot(model5_mcmc$Sol)
# Traces for random effects
plot(model5_mcmc$VCV)
## Auto-correlation among lag steps
autocorr.diag(model5_mcmc$Sol)
autocorr.diag(model5_mcmc$VCV)

## Effective sample size
effectiveSize(model5_mcmc$Sol)
effectiveSize(model5_mcmc$VCV)

## Test of model convergence
heidel.diag(model5_mcmc$VCV)

animal_var5 <-  model5_mcmc$VCV[, "animal"]
dam_var5 <-  model5_mcmc$VCV[, "damID"]
error_var5 <-  model5_mcmc$VCV[, "units"]
p_var5 <- c(animal_var5+dam_var5+error_var5)

animal5_h2 <- animal_var5 / p_var5
dam5_h2 <- dam_var5 / p_var5

mcmc5_summary  <- data.frame(ParentTrt ="Control",
                             Offspring="Control",
                             Model="Model_5",
                             N = nrow(jr_cc),
                             Va_mean=mean(animal_var5),
                             Va_lower=quantile(animal_var5, 0.025),
                             Va_upper=quantile(animal_var5, 0.975),
                             Vdam_mean=mean(dam_var5),
                             Vdam_lower=quantile(dam_var5, 0.025),
                             Vdam_upper=quantile(dam_var5, 0.975),
                             Vsire_mean=NA,
                             Vsire_lower=NA,
                             Vsire_upper=NA,
                             VJarTrt_mean=NA,
                             VJarTrt_lower=NA,
                             VJarTrt_upper=NA,
                             Vtable_mean=NA,
                             Vtable_lower=NA,
                             Vtable_upper=NA,
                             Verror_mean=mean(error_var5),
                             Verror_lower=quantile(error_var5, 0.025),
                             Verror_upper=quantile(error_var5, 0.975),
                             Vp_mean=mean(p_var5),
                             Vp_lower=quantile(p_var5, 0.025),
                             Vp_upper=quantile(p_var5, 0.975),
                             H2_animal_mean=mean(animal5_h2),
                             H2_animal_lower=quantile(animal5_h2, 0.025),
                             H2_animal_upper=quantile(animal5_h2, 0.975),
                             H2_dam_mean=mean(dam5_h2),
                             H2_dam_lower=quantile(dam5_h2, 0.025),
                             H2_dam_upper=quantile(dam5_h2, 0.975))





summary_table <- rbind(mcmc_summary,mcmc2_summary,mcmc3_summary,mcmc4_summary,mcmc5_summary)
summary_table <- data.frame(summary_table[,1:4],round(summary_table[,5:ncol(summary_table)],5))


animal_plot <- ggplot(summary_table,aes(x=Model,y=H2_animal_mean)) + 
  geom_point() +
  geom_errorbar(aes(ymin=H2_animal_lower,ymax=H2_animal_upper)) + 
  theme_cowplot() +
  labs(y="Heritability",title="Animal")

dam_plot <- ggplot(summary_table,aes(x=Model,y=H2_dam_mean)) + 
  geom_point() +
  geom_errorbar(aes(ymin=H2_dam_lower,ymax=H2_dam_upper)) + 
  theme_cowplot() +
  labs(y="Heritability",title="Dam")

plot_grid(animal_plot,dam_plot)
