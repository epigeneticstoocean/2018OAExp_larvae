#!/bin/bash

#SBATCH --job-name=DNAMethylation_mapping
#SBATCH --mem=100Gb
#SBATCH --mail-user=downey-wall.a@northeastern.edu
#SBATCH --mail-type=FAIL
#SBATCH --partition=lotterhos
#SBATCH --nodes=1
#SBATCH --cpus-per-task=32
#SBATCH --output=/work/lotterhos/2018OALarvae_DNAm/slurm_log/DNAm_mapping_%j.out
#SBATCH --error=/work/lotterhos/2018OALarvae_DNAm/slurm_log/DNAm_mapping_%j.err

source ~/miniconda3/bin/activate methyKit_20210604

Rscript ~/2018OAlarvae_DNAm/src/04_methylKitMatrix.R