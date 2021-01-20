---
title: "BRMS Sample"
author: "adowneywall"
date: "9/23/2020"
output: html_document
editor_options: 
  chunk_output_type: console
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
library(brms)
library(lme4)
library(methylKit)
knitr::opts_knit$set(base.dir = "/home/downeyam/Github/AE17_Cvirginica_MolecularResponse/")
```

```{r}
setwd("/home/downeyam/Github/AE17_Cvirginica_MolecularResponse/")
mC <- read.csv("data/MBDBS_seq/methylKitObj_all_cov5Filtered_united_MethylCCounts.csv")
tC <- read.csv("data/MBDBS_seq/methylKitObj_all_cov5Filtered_united_totalCounts.csv")

meth <- readRDS("data/MBDBS_seq/methylKitObj_all_cov5Filtered_united.RData")
meth_pos <- c(paste0(meth$chr,"_",meth$start))
# fibrillin-2-like isoform X1
# CpG that was significant in methylation analysis at day 80
sigPosition <- c("NC_035784.1_68684824")
locus <- which(meth_pos %in% sigPosition)

meta <- readRDS("data/meta/metadata_20190811.RData")

meta <- meta[meta$ID != "17099",]
```

Target Loci
```{r}
meta$tC <- as.integer(tC[locus,])
meta$mC <-as.integer(mC[locus,])
```

## Overview 
Exploration of multi level (mixed effects) models in R using binomial (count) based data (DNA methylation data). The goal of this is to examine several different multi-level modelling approaches (mainly maximum likelihood vs. bayesian) with binomial data.

## Maximum likelihood Binomical Model (*lme4*)

Fit model
```{r}
fit_glm <- glmer(cbind(mC,tC) ~ Treatment*Time + (1|Pop),data = meta,family = binomial(link="logit"))
```

```{r}
summary(fit_glm)
```

### Thoughts on model

**Singular Fit Problem**

Complex mixed-effect models (i.e., those with a large number of variance-covariance parameters) frequently result in singular fits, i.e. estimated variance-covariance matrices with less than full rank. Less technically, this means that some "dimensions" of the variance-covariance matrix have been estimated as exactly zero. For scalar random effects such as intercept-only models, or 2-dimensional random effects such as intercept+slope models, singularity is relatively easy to detect because it leads to random-effect variance estimates of (nearly) zero, or estimates of correlations that are (almost) exactly -1 or 1. However, for more complex models (variance-covariance matrices of dimension >=3) singularity can be hard to detect; models can often be singular without any of their individual variances being close to zero or correlations being close to +/-1.

This function performs a simple test to determine whether any of the random effects covariance matrices of a fitted model are singular. The rePCA method provides more detail about the singularity pattern, showing the standard deviations of orthogonal variance components and the mapping from variance terms in the model to orthogonal components (i.e., eigenvector/rotation matrices).

While singular models are statistically well defined (it is theoretically sensible for the true maximum likelihood estimate to correspond to a singular fit), there are real concerns that (1) singular fits correspond to overfitted models that may have poor power; (2) chances of numerical problems and mis-convergence are higher for singular models (e.g. it may be computationally difficult to compute profile confidence intervals for such models); (3) standard inferential procedures such as Wald statistics and likelihood ratio tests may be inappropriate.

There is not yet consensus about how to deal with singularity, or more generally to choose which random-effects specification (from a range of choices of varying complexity) to use. Some proposals include:

avoid fitting overly complex models in the first place, i.e. design experiments/restrict models a priori such that the variance-covariance matrices can be estimated precisely enough to avoid singularity (Matuschek et al 2017)

use some form of model selection to choose a model that balances predictive accuracy and overfitting/type I error (Bates et al 2015, Matuschek et al 2017)

“keep it maximal”, i.e. fit the most complex model consistent with the experimental design, removing only terms required to allow a non-singular fit (Barr et al. 2013), or removing further terms based on p-values or AIC

use a partially Bayesian method that produces maximum a posteriori (MAP) estimates using regularizing priors to force the estimated random-effects variance-covariance matrices away from singularity (Chung et al 2013, blme package)

use a fully Bayesian method that both regularizes the model via informative priors and gives estimates and credible intervals for all parameters that average over the uncertainty in the random effects parameters (Gelman and Hill 2006, McElreath 2015; MCMCglmm, rstanarm and brms packages)

## Bayesian Binomial Model (*BRMS*)

```{r}
fit1 <- brm(mC|trials(tC) ~ Treatment*Time + (1|Pop),
            data = meta, family = binomial(),
            iter = 10000, chains = 4,
            control = list(adapt_delta = c(0.99),max_treedepth=15),
            save_all_pars = TRUE)
    ```

```{r}
pairs(fit1)
```

```{r}
summary(fit1)

```

```{r}
conditional_effects(fit1)

# Check for coverage variance amoung trtxtime levels
ggplot(meta,aes(Time,tC,interaction(Treatment,Time),colour=Treatment)) +
  geom_boxplot()
# Check for methylation variance amoung trtxtime levels
ggplot(meta,aes(Time,mC,interaction(Treatment,Time),colour=Treatment)) +
  geom_boxplot()
ggplot(meta,aes(Time,c(mC/tC)*100,interaction(Treatment,Time),colour=Treatment)) + geom_boxplot() + labs(y="% Methylation")
  
# Manually create conditional effects graph
library(tidyr)
library(ggplot2)
out <- posterior_epred(fit1)
dim(out)
out_t <- t(out)
out_t_meta <- data.frame(Trt=meta$Treatment,Time=meta$Time,out_t)
final_dat <- gather(out_t_meta,iter,prediction,X1:colnames(out_t_meta)[ncol(out_t_meta)])
ggplot(final_dat,aes(Trt,prediction,interaction(Trt,Time),colour=Time)) + geom_boxplot(outlier.shape = NA) + ylim(0,2)
```

## Bayesian Beta Binomial Model (*BRMS*)

The beta binomial is in the binomial family, but includes an additional parameter that corrects for overdispersion. `BRMS` does not have this particular model so we can create our own custom version.

```{r}
beta_binomial2 <- custom_family(
  "beta_binomial2", dpars = c("mu", "phi"),
  links = c("logit", "log"), lb = c(NA, 0),
  type = "int", vars = "vint1[n]"
)

stan_funs <- "real beta_binomial2_lpmf(int y, real mu, real phi, int T) {return beta_binomial_lpmf(y | T, mu * phi, (1 - mu) * phi);}int beta_binomial2_rng(real mu, real phi, int T) {return beta_binomial_rng(T, mu * phi, (1 - mu) * phi);}"

stanvars <- stanvar(scode = stan_funs, block = "functions")
```

```{r}
fit2 <- brm(mC|vint(tC) ~ Treatment*Time + (1|Pop),data = meta,
            family = beta_binomial2,stanvars = stanvars,
            iter = 10000, chains = 4,
            control = list(adapt_delta = c(0.99),max_treedepth=15),
            save_all_pars = TRUE)
```

```{r}
expose_functions(fit2, vectorize = TRUE)

log_lik_beta_binomial2 <- function(i, prep) {
  mu <- prep$dpars$mu[, i]
  phi <- prep$dpars$phi
  trials <- prep$data$vint1[i]
  y <- prep$data$Y[i]
  beta_binomial2_lpmf(y, mu, phi, trials)
}

posterior_predict_beta_binomial2 <- function(i, prep, ...) {
  mu <- prep$dpars$mu[, i]
  phi <- prep$dpars$phi
  trials <- prep$data$vint1[i]
  beta_binomial2_rng(mu, phi, trials)
}

posterior_epred_beta_binomial2 <- function(prep) {
  mu <- prep$dpars$mu
  trials <- prep$data$vint1
  trials <- matrix(trials, nrow = nrow(mu), ncol = ncol(mu), byrow = TRUE)
  mu * trials
}
```


```{r}
summary(fit2)
plot(fit2)
pp_check(fit2)
conditional_effects(fit2)
```





