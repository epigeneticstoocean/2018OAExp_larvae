
## Purpose : Formats data from the transgenerational repo into two RDS files that include pedigree and phenotype
 # information for both individual and jar level phenotypes.

## Inputs: Found in 'LarvaeTransGen2018/data/' repo folder
## Outputs: Found in the `2018OAExp_larvae/input_files/` folder
library(dplyr)
library(GGally)
library(stringr) # str_split function

## Read files
setwd("~/Github/LarvaeTransGen2018") # Local path
#setwd("~/LarvaeTransGen2018") # Discovery cluster

## Phenotypes of all larvae
LDat <- read.csv("data/LarvaeDat.csv")
out <- str_split(LDat$CrossID,pattern = "_",simplify = TRUE)
pheno_all <- data.frame(animal=as.character(1:nrow(LDat)),damID=out[,1],sireID=out[,2],LDat[,-1])
ped_all <- data.frame(id=1:nrow(LDat),dam=out[,1],sire=out[,2])
dams <- data.frame(id=unique(out[,1]),dam=NA,sire=NA)
sires <- data.frame(id=unique(out[,2]),dam=NA,sire=NA)
ped_all <- rbind(dams,sires,ped_all)
ped_all$id <- as.character(ped_all$id)

## Phenotypes of jar summarize larvae
LJar <- read.csv("data/LarvByJarDat.csv")
pheno_jar <- data.frame(animal=as.character(1:nrow(LJar)),LJar[,-1])
out_male <- str_split(LJar$MaleID,pattern = "_",simplify = TRUE)[,1]
out_female <- str_split(LJar$FemaleID,pattern = "_",simplify = TRUE)[,1]
damsj <- data.frame(id=unique(out_female),dam=NA,sire=NA)
siresj <- data.frame(id=unique(out_male),dam=NA,sire=NA)
ped_jar <- data.frame(id=pheno_jar$animal,dam=out_female,sire=out_male )
ped_jar <- rbind(damsj,siresj,ped_jar)
ped_jar$id <- as.character(ped_jar$id)

## Correlations
# Target Phenotype subsets
# Individual
colnames(pheno_all)
cnames <- c("LarvaeAreaum2","LarvaeDiamum","LarvaePerimeterum","GrowthPerDay","MajMinRat","PerimDiamRat")
pheno_allCorr <- subset(pheno_all,select=cnames)
# Jars
colnames(pheno_jar)
cnames <- c("MeanWtPerLarvae","LarvaeSurvived","UnfertCount","AbnormalCount","NumCilia","LarvaeAreaum2","LarvaeDiamum","LarvaePerimeterum","LarvaeSolidity","Areaciliaextent","Areaciliaarea")
pheno_jarCorr <- subset(pheno_jar,select=cnames)

# Correlation Plots
# Phenotypes for single larvae
all_pair <- ggpairs(pheno_allCorr)
ggsave("~/2018OAExp_larvae/input_files/CorrelationPlot_IndividualLarvalPhenotypes.png",plot=all_pair)
# Phenotypes for jars
jar_pair <- ggpairs(pheno_jarCorr)
ggsave("~/2018OAExp_larvae/input_files/CorrelationPlot_JarPhenotypes.png",plot=jar_pair)

## Data tranformation and subsets 
cnames <- c("animal","damID","sireID","JarID","JarTrt","ParentTrt",
            "LarvaeAreaum2","LarvaeDiamum","LarvaePerimeterum",
            "GrowthPerDay","MajMinRat","PerimDiamRat")
pheno_allSub <- subset(pheno_all,select=cnames)

colnames()
pheno_allSub %>% group_by(JarID) %>%
  summarise(damID=unique(damID),sireID=unique(sireID),JarTrt=unique(JarTrt),ParentTrt=unique(ParentTrt),
            Area=mean(LarvaeAreaum2),Diameter=mean(LarvaeDiamum),Perimeter=mean(LarvaePerimeterum),
            Growth=mean(GrowthPerDay),MMR=mean(MajMinRat),PDR=mean(PerimDiamRat)) -> pheno_sumAll

cnames <- c("JarID","MeanWtPerLarvae","LarvaeSurvived","UnfertCount",
            "AbnormalCount","CiliaTotalCount","NumCilia","PercentCilia","EggDiamum","JarpCO2_SW")
pheno_jarSub <- subset(pheno_jar,select=cnames)
pheno_final <- left_join(pheno_sumAll,pheno_jarSub,by="JarID")
pheno_final <- data.frame(animal=pheno_jar$animal,pheno_final)
pheno_finalpair <- ggpairs(pheno_final[,-(1:6)])
ggsave("~/2018OAExp_larvae/input_files/CorrelationPlot_CombinedJarPhenotypes.png",plot=pheno_finalpair)

## Saving Data
# Save to the "2018OAExp_larvae/" github repo
saveRDS(list(ped=ped_jar,pheno=pheno_final),"~/Github/2018OAExp_larvae/input_files/JarHeritabilityData.RDS")
saveRDS(list(ped=ped_all,pheno=pheno_allSub),"~/Github/2018OAExp_larvae/input_files/IndHeritabilityData.RDS")

