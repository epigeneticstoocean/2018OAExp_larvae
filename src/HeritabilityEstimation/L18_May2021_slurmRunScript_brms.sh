#!/bin/bash

#SBATCH --job-name=DNAMethylation_mapping
#SBATCH --mem=100Gb
#SBATCH --mail-user=downey-wall.a@northeastern.edu
#SBATCH --mail-type=FAIL
#SBATCH --partition=lotterhos
#SBATCH --nodes=1
#SBATCH --cpus-per-task=32
#SBATCH --output=/home/downey-wall.a/2018OAExp_larvae/results/heritabilitySlurmOutput_%j.out
#SBATCH --error=/home/downey-wall.a/2018OAExp_larvae/results/heritabilitySlurmOutput_%j.err

source ~/miniconda3/bin/activate adw_20210415

Rscript ~/2018OAExp_larvae/src/HeritabilityEstimation/L18_heritabilityEstimateDiscovery_May2021.R
