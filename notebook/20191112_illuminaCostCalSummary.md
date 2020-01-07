# Illumina Sequencing calculator

[LINK to coverage calculator](https://support.illumina.com/downloads/sequencing_coverage_calculator.html)

![](https://github.com/epigeneticstoocean/2018OAExp_larvae/blob/master/notebook/img/illuminaCalcScreenShot.png)

### Costs

**NOTE**: Cost determined as ball park using Harvard Bauer Core facility [prices](https://bauercore.fas.harvard.edu/fees).

![](https://github.com/epigeneticstoocean/2018OAExp_larvae/blob/master/notebook/img/harvardCostSeqTable.png)

**Illumina 4500 (2x75bp)** 
* 25000 / 4420 = 5.6 lanes (x2 samples per lane) = 10-12 samples with ~25x expected coverage

**Nova Seq S1**
* 25000 / 9863 =  2.53 (x12 samples per lane) = 24 samples with ~25x expected coverage

**Nova Seq S2**
* 25000 / 18093 = 1.382 (x32 samples per lane) = 32 samples with ~25x expected coverage

### Details about illumina calculator parameters

**Calculation of Results Using Coverage Needed**
* Total output required = region size * coverage / ((1-duplicates/100) * on target/100)
* Output per unit = clusters per unit * read length
* Number of units (flow cells or lanes) = total output required / output per unit
* Number of samples = output per unit / total output required
