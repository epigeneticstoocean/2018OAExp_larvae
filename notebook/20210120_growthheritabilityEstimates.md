# Heritability of larval estimates 

In the markdown below I explore heritability estimates using several different bayesian models implemented in MCMCglmm. I run the model separate for each parent-offspring treatment combination (4 total). I also explore 5 different models that vary based on random effects included, priors used, and data version (individual or mean jar growth rates).

**Scroll to the bottom to see the final summary table and plots. The summary also includes diagnostic tables and plots.**

## [Markdown Summary](https://github.com/epigeneticstoocean/2018OAExp_larvae/blob/master/src/HeritabilityEstimation/L18_growthheritabilityestimate.md)

## Next Steps

* I plan on looking more into the appropriate priors to use in the model. In particular, the posterior distribution (included in the diagnostic plots) for the animal random effect looks non-normal. Specifically, it has lots of zeros. I am not sure if this is necessarily problematic for our estimate of heritability, but I think its worth confirming that this isn't an artifact of the choosen priors.
