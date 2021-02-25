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