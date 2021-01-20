

library(MASS)
library(ggplot2)
library(cowplot)
library(ggpubr)

# Parents from control
devV <- 0.1
selV <- 0.25
covV <- 1
sigma <- matrix(c(devV,devV*covV,selV*covV,selV),ncol=2)
out <- mvrnorm(50,c(1,3),sigma)
out_df <- data.frame(Environment="Control",Individual=c(1:nrow(out)), Phenotype=as.numeric(out[,1]))
out_df <- rbind(out_df,data.frame(Environment="OA",Individual=c(1:nrow(out)),Phenotype=as.numeric(out[,2])))

# Parents from OA
devV <- 0.05
selV <- 0.1
covV <- 0.4
sigma <- matrix(c(devV,devV*covV,selV*covV,selV),ncol=2)
out2 <- mvrnorm(50,c(2,3),sigma)
out_df2 <- data.frame(Environment="Control",Individual=c(1:nrow(out2)), Phenotype=as.numeric(out2[,1]))
out_df2 <- rbind(out_df2,data.frame(Environment="OA",Individual=c(1:nrow(out2)),Phenotype=as.numeric(out2[,2])))

# Control Parent Figures
ggplot(out_df,aes(x=Environment,y=Phenotype,colour=Environment)) + 
  geom_boxplot() +
  geom_jitter(width = 0.2) + 
  theme_cowplot() + 
  theme(legend.position = "none")
  
ggpaired(out_df, x = "Environment", y = "Phenotype",
         color = "Environment", line.color = "gray", line.size = 0.4) + 
  labs(x = "Environment" , y = "Phenotype") + 
  theme(legend.position = "none")

# Both Parent Figures
out_df$Parent <- "Control"
out_df2$Parent <- "OA"
out_all <- rbind(out_df,out_df2)

ggplot(out_all,aes(x=Environment,y=Phenotype,colour=Environment)) + 
  facet_grid(~Parent) +
  geom_boxplot() +
  geom_jitter(width = 0.2) + 
  theme_cowplot() + 
  theme(legend.position = "none")

ggpaired(out_all, x = "Environment", y = "Phenotype",id="Individual",
         color = "Environment", line.color = "gray", line.size = 0.4,facet.by = "Parent") + 
  labs(x = "Environment" , y = "Phenotype") +
  theme(legend.position = "none")



