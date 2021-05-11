# Plan for Heritability Paper


# Heritability Model

1) Estimate heritability for each parent-offspring environment treatment with individual data. 
  * Run animal model tests in mcmcGLMM without DNA Methylation
    * Final model : Larval Growth ~ mu + (1|animal) + (1|damID) + (1|JarID)
    * Also tested range of priors
    * Calculate heritability and maternal effect

2) Calculate lineage level growth for each parent treatment
* Fit linear regression for each family where offspring pH is the primary explanatory factor.
* Use the slope of this regression as a response variable in the animal model (slope represents the reaction norm)
* Does it make sense to also look at the intercepts? In the context of the anima

3) Estimate parentl DNA methylation
* Calculate single estimate of methylation for each parent
* Estimate variance-covariance matrix with euclidean matrix approach outlined by Thomson et al 2018

4) Run linear mixed model using DNA methylation as fixed covariate
  * Run same best model as Elise in her paper and include methylation as fixed covariate
  * **Question**: Is parental methylation a significant explanatory variable in a linear mixed model that examines the effects of intergenerational OA exposure on larval growth?   
