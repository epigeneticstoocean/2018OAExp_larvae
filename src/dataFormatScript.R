
## Purpose : Formats data from the transgenerational repo into two RDS files that include pedigree and phenotype
 # information for both individual and jar level phenotypes.

## Inputs: Found in 'LarvaeTransGen2018/data/' repo folder
## Outputs: Found in the `2018OAExp_larvae/input_files/` folder
library(dplyr)
library(GGally)
library(stringr) # str_split function
library(ggplot2)
library(cowplot)
library(lme4)

## Read files
setwd("~/Github/LarvaeTransGen2018") # Local path

## Phenotypes of all larvae
LDat <- read.csv("data/LarvaeDat.csv") # Individuals measures from block one
out <- str_split(LDat$CrossID,pattern = "_",simplify = TRUE)
pheno_all <- data.frame(animal=as.character(1:nrow(LDat)),damID=out[,1],sireID=out[,2],LDat[,-1])
pheno_all$family <- paste0(pheno_all$sireID,"_",pheno_all$damID) 

# Create individual pedigree table
ped_ind <- data.frame(id=1:nrow(LDat),dam=pheno_all$damID,sire=pheno_all$sireID)
dams <- data.frame(id=unique(out[,1]),dam=NA,sire=NA)
sires <- data.frame(id=unique(out[,2]),dam=NA,sire=NA)
ped_ind <- rbind(dams,sires,ped_ind)

## Phenotypes of jar summarize larvae
LJar <- read.csv("data/LarvByJar.csv") # Jar summaries from all blocks
LJar <- LJar[LJar$Block.x == "B1",] # Only looking at block 1
LJar <- LJar[!is.na(LJar$JarID),]
out_male <- str_split(LJar$MaleID,pattern = "_",simplify = TRUE)[,1]
out_female <- str_split(LJar$FemaleID,pattern = "_",simplify = TRUE)[,1]
LJar$damID <- out_female
LJar$sireID <- out_male
LJar$family <- paste0(LJar$sireID,"_",LJar$damID) 
pheno_jar <- data.frame(animal=as.character(1:nrow(LJar)),LJar[,-1])

# Create jar level pedigree
damsj <- data.frame(id=unique(LJar$damID),dam=NA,sire=NA)
siresj <- data.frame(id=unique(LJar$sireID),dam=NA,sire=NA)
ped_jar <- data.frame(id=pheno_jar$animal,dam=LJar$damID,sire=LJar$sireID)
ped_jar <- rbind(damsj,siresj,ped_jar)

#### Output working directory ####
setwd("~/Github/2018OAExp_larvae/")

#### Correlations ####
# Target Phenotype subsets
# Individual
cnames <- c("LarvaeAreaum2","LarvaeDiamum","LarvaePerimeterum","GrowthPerDay","MajMinRat","PerimDiamRat")
pheno_allCorr <- subset(pheno_all,select=cnames)
# Jars
cnames <- c("MeanWtPerLarvae","LarvaeSurvived","v2SurvCount","LarvaeAreaum2","LarvaeDiamum","LarvaePerimeterum","LarvaeSolidity","Areaciliaextent","Areaciliaarea")
pheno_jarCorr <- subset(pheno_jar,select=cnames)

## Correlation Plots 
# Phenotypes for single larvae

all_pair <- ggpairs(pheno_allCorr)
ggsave("input_files/CorrelationPlot_IndividualLarvalPhenotypes.png",plot=all_pair)
# Phenotypes for jars
jar_pair <- ggpairs(pheno_jarCorr)
ggsave("input_files/CorrelationPlot_JarPhenotypes.png",plot=jar_pair)


#### Selecting Variables To Examine By Individual #### 
cnames <- c("animal","family","damID","sireID","JarID","JarSeatable",
            "JarTrt","JarpHNBS","JarpCO2_SW","ParentTrt", 
            "LarvaeAreaum2","LarvaeDiamum","LarvaePerimeterum",
            "GrowthPerDay","MajMinRat","PerimDiamRat")
pheno_indFinal <- subset(pheno_all,select=cnames)
# Turning trt variables (parent and offspring or jar into factors)
pheno_indFinal$JarTrt <- as.factor(pheno_indFinal$JarTrt)
pheno_indFinal$ParentTrt[pheno_indFinal$ParentTrt == 400] <- "Control"
pheno_indFinal$ParentTrt[pheno_indFinal$ParentTrt == 2600] <- "Exposed"
pheno_indFinal$ParentTrt <- as.factor(pheno_indFinal$ParentTrt)
# Adding scaled version of growth and morphology data
pheno_indFinal$GrowthScale <- scale(pheno_indFinal$GrowthPerDay)
pheno_indFinal$PDRScale <- scale(pheno_indFinal$PerimDiamRat)

#### Selecting Variables To Summarize By Jar ####
pheno_indFinal %>% group_by(JarID) %>%
  summarise(damID=unique(damID),sireID=unique(sireID),JarTrt=unique(JarTrt),ParentTrt=unique(ParentTrt),SeaTable=unique(JarSeatable),
            Area=mean(LarvaeAreaum2),Diameter=mean(LarvaeDiamum),Perimeter=mean(LarvaePerimeterum),
            Growth=mean(GrowthPerDay),MMR=mean(MajMinRat),PDR=mean(PerimDiamRat)) -> pheno_sumAll

cnames <- c("animal","JarID","family","MaleID","FemaleID","JarpHNBS","JarpCO2_SW",
            "MeanWtPerLarvae","LarvaeSurvived","v2SurvCount",
            "UnfertCount","AbnormalCount","EggDiamum")
pheno_jarSub <- subset(pheno_jar,select=cnames)

# summarize growth 
jar_growth <- subset(pheno_sumAll,select=c("JarID","Growth","PDR","JarTrt","ParentTrt","SeaTable"))

pheno_jarFinal <- left_join(pheno_jarSub,jar_growth,by="JarID")

# Reorder
re_order <- c("animal","JarID","family","MaleID","FemaleID",
              "JarTrt","JarpHNBS","JarpCO2_SW","ParentTrt",
              "MeanWtPerLarvae","SeaTable","LarvaeSurvived","v2SurvCount",
              "UnfertCount","AbnormalCount","EggDiamum","Growth","PDR")
pheno_jarFinal <- subset(pheno_jarFinal,select=re_order)
# Set treatment as factors
pheno_jarFinal$JarTrt <- as.factor(pheno_jarFinal$JarTrt)
pheno_jarFinal$ParentTrt[pheno_jarFinal$ParentTrt == 400] <- "Control"
pheno_jarFinal$ParentTrt[pheno_jarFinal$ParentTrt == 2600] <- "Exposed"
pheno_jarFinal$ParentTrt <- as.factor(pheno_jarFinal$ParentTrt)

#### Selecting Variables To Summarize Family ####
## Summarize Growth and Survivorship by Family (averaged)
pheno_family_sum <- pheno_jarFinal  %>% 
  group_by(family,JarTrt) %>% 
  summarise(animal=animal[1],
            ParentTrt=unique(ParentTrt),
            pH_NBS=mean(JarpHNBS),
            CO2=mean(JarpCO2_SW),
            damID=unique(FemaleID),
            eggDiamum=mean(EggDiamum),
            Growth=mean(Growth),
            PDR=mean(PDR),
            Survived=mean(LarvaeSurvived),
            Survived_alt=mean(v2SurvCount))

# Since each family was exposed to both ambient and exposed conditions we examine the different in
# growth and survivorship among offspring treatments 
# Subset by offspring treatment

pheno_family_sum$GrowthScaled <- scale(pheno_family_sum$Growth)
pheno_family_sum$PDRScaled <- scale(pheno_family_sum$PDR)
pheno_family_sum <- pheno_family_sum[,c(1:9,13,10,14,11,12)]

pheno_family_sum_ctrl <- pheno_family_sum[pheno_family_sum$JarTrt == "Control",]
colnames(pheno_family_sum_ctrl) <- c("family","JarTrt","animal","ParentTrt","pH_NBS_ambient","CO2_ambient",
                                  "damID","eggDiamum",
                                  "Growth_ambient","GrowthScale_ambient",
                                  "PDR_ambient","PDRScale_ambient",
                                  "Survived_ambient","Survived_alt_ambient")
pheno_family_sum_exposed <- pheno_family_sum[pheno_family_sum$JarTrt == "Exposed",c(1,5,6,9:14)]
colnames(pheno_family_sum_exposed) <- c("family","pH_NBS_exposed","CO2_exposed",
                                     "Growth_exposed","GrowthScale_exposed",
                                     "PDR_exposed","PDRScale_exposed",
                                     "Survived_exposed","Survived_alt_exposed")
# Merge together 
pheno_family <- left_join(pheno_family_sum_ctrl,pheno_family_sum_exposed,by="family")

# Create some simple relative survival, growth and morphology measures
# i.e., OA relative to control
pheno_family$prop_survived <- pheno_family$Survived_exposed/pheno_family$Survived_ambient
pheno_family$prop_survived[pheno_family$prop_survived > 1] <- 1
pheno_family$diffPDRScaled <- c(pheno_family$PDRScale_exposed - pheno_family$PDRScale_ambient)
pheno_family$diffGrowthScaled <- c(pheno_family$GrowthScale_exposed - pheno_family$GrowthScale_ambient)


#### Fits linear regressions to individual level data to generate a linear family level reaction norm (intercept and slope) ####

## Growth reaction norm 
y <- "GrowthScale" # Response Variable
x <- "JarpHNBS" # Explanatory variable
r <- "JarID" #Random effect

slp <- NULL
inter <- NULL
for( i in 1:length(unique(pheno_indFinal$family))){
  temp <- pheno_indFinal[pheno_indFinal$family == unique(pheno_indFinal$family)[i],]
  temp <- temp[!is.na(temp[,x]),]
  model_out <- lmer(temp[,y]~temp[,x] + (1|temp[,r]))
  model_out_s <- summary(model_out)
  inter <- c(inter,model_out_s$coefficients[1,1])
  slp <- c(slp,model_out_s$coefficients[2,1])
}

family_group <- data.frame(family=unique(pheno_indFinal$family))
family_group$Slope_growth=slp
family_group$Intercept_growth=inter

## PDR reaction norm
y <- "PDRScale" # Response Variable
slp <- NULL
inter <- NULL
for( i in 1:length(unique(pheno_indFinal$family))){
  temp <- pheno_indFinal[pheno_indFinal$family == unique(pheno_indFinal$family)[i],]
  temp <- temp[!is.na(temp[,x]),]
  model_out <- lmer(temp[,y]~temp[,x] + (1|temp[,r]))
  model_out_s <- summary(model_out)
  inter <- c(inter,model_out_s$coefficients[1,1])
  slp <- c(slp,model_out_s$coefficients[2,1])
}

family_group$Slope_PDR=slp
family_group$Intercept_PDR=inter

pheno_familyFinal <- left_join(pheno_family,family_group,by="family")

ped_family <- rbind(ped_jar[1:26,],ped_jar[which(ped_jar$id %in% pheno_familyFinal$animal),])

#### Saving Data ####
# Save to the "2018OAExp_larvae/" github repo
saveRDS(list(ped=ped_ind,pheno=pheno_indFinal),"~/Github/2018OAExp_larvae/input_files/IndHeritabilityData.RDS")
saveRDS(list(ped=ped_jar,pheno=pheno_jarFinal),"~/Github/2018OAExp_larvae/input_files/JarHeritabilityData.RDS")
saveRDS(list(ped=ped_family,pheno=pheno_familyFinal),"~/Github/2018OAExp_larvae/input_files/FamilyHeritabilityData.RDS")



#### Extra Visualization Figures ####
## NEED TO UPDATE THIS, AFTER CLEANING CODE ABOVE THIS CODE WON'T RUN

# Offspring Env. By Family
p1<-ggplot(pheno_jarFinal,aes(family,JarpCO2_SW,colour=JarTrt)) + 
  geom_boxplot() + 
  geom_point() +
  theme_cowplot() + 
  labs(x="Family",y="pCO2 (SW)",colour="Offspring Treatment",title="Offspring Env. By Family") +
  theme(axis.text.x=element_text(angle=45,vjust = 0.9, hjust=1),
        plot.title = element_text(hjust=0.5))
ggsave(plot=p1,"input_files/offspringEnvByFamily.png",width=30 ,height=20,units = "cm")

## Two part figure
# Offspring Survival By Offspring Env. (Control)
p1<-ggplot(pheno_jar[pheno_jar$JarTrt=="Control",],
       aes(JarpCO2_SW,LarvaeSurvived,
           group=as.factor(ParentTrt),
           colour=as.factor(ParentTrt))) + 
    geom_point() + 
    geom_smooth(method="lm") +
    theme_cowplot() +
    labs(x="pCO2 (SW)",y="Num. Larvae Survived",colour="Parent Treatment",title="Offspring Survival By Offspring Env. (Control)") +
    theme(plot.title = element_text(hjust=0.5))
#Offspring Survival By Offspring Env. (Exposed)
p2 <- ggplot(pheno_jar[pheno_jar$JarTrt=="Exposed",],
       aes(JarpCO2_SW,LarvaeSurvived,
           group=as.factor(ParentTrt),
           colour=as.factor(ParentTrt))) + 
      geom_point() + 
      geom_smooth(method="lm") +
      theme_cowplot() +
      labs(x="pCO2 (SW)",y="Num. Larvae Survived",colour="Parent Treatment",title="Offspring Survival By Offspring Env. (Exposed)") +
      theme(plot.title = element_text(hjust=0.5))
p3 <- plot_grid(p1,p2,rows = 2)
ggsave(plot=p3,"input_files/offspringSurvivalByOffspringEnv.png",width=25,height=40,units = "cm")

# Larvae Survival By Family
p1 <- ggplot(pheno_jar_sum,aes(family,Survived,group=interaction(JarTrt,ParentTrt,family),colour=interaction(JarTrt,ParentTrt))) +
  geom_point() + 
  theme_cowplot() +
  labs(x="Family",y="Larvae Survived",colour="Offspring.Parent Treatment",title="Larvae Survival By Family") +
  theme(axis.text.x=element_text(angle=45,vjust = 0.9, hjust=1),
        plot.title = element_text(hjust=0.5))
ggsave(plot=p1,"input_files/larvaeSurvivalByFamily.png",width=30 ,height=20,units = "cm")

# Survival Proportion By Difference In Larval Growth
p1 <- ggplot(pheno_jar_sum_alt,aes(diffMort,diffGrowth,group=as.factor(ParentTrt),colour=as.factor(ParentTrt))) + 
  geom_point() + 
  geom_smooth(method="lm") +
  theme_cowplot() +
  labs(x="Proportion Survived",
       y="Difference In Growth",
       colour="Parent Treatment",
       title="Survival Proportion By Difference In Larval Growth") +
  theme(plot.title=element_text(hjust=0.5))
ggsave(plot=p1,"input_files/SurvivalPropByDiffInLarvaeGrowth.png",width=30 ,height=20,units = "cm")

# A quick check to examine the relationship between portional mortality changes due to OA vs. changes in growth
mod_out2 <- lm(diffGrowth~diffMort+as.factor(ParentTrt),data=pheno_jar_alt_noNA)
summary(mod_out2)



