# Custom bisulfite conversion and library prep protocol

## Overview
This protocol uses the [Pico Methyl-seq library prep Kit by Zymo](https://www.zymoresearch.com/products/pico-methyl-seq-library-prep-kit) and mostly follows the manufacturers instructions outlined in the [manual](https://github.com/epigeneticstoocean/2018OAExp_larvae/blob/master/protocols/_d5455_d5456_picomethylseq.pdf), but deviates at step 4 and 5 following the recommendations of the Putnam lab ([notebook entry here](https://github.com/epigeneticstoocean/2018OAExp_larvae/blob/master/notebook/20200827_PutnamProtocolForPicoMethylationKit.md)).

## Step 0 - Sample DNA

gDNA used in the library prep protocol (not fragmented) and samples quantified prior to the start of the protocol to confirm concentration.

## Step 1 - Bisulfite conversion

Follow standard manufacturers recommendation. For all samples with sufficient amounts of DNA (in high enough concentration) I use 100ng of DNA, which I dilute as needed with H20 to a total volume of 20uL.

**In reaction tube**
130uL BS reagent + 20uL sample = 150 uL total reaction volume

**NOTE** As part of my sample I add 5ng of methylated lambda DNA (5% of sample DNA), this is included as part of the 20uL sample volume.

## Step 2

Manufacturers protocol followed

## Step 3

Manufacturers protocol followed

## Step 4

Reactions consistent with manufacturers recommendation. 9 cycles were used for the PCR.

## Step 5 

The thermocycler program from the manufacturer is used, but the reaction for each sample was as follows:

| Reagent | Amount |
|:------:|:-------:|
| LibraryAmp Master Mix (2X) | 14 uL|
| Primer Mix (10uM for each primer) | 2 uL |
| Sample (section 4) | 12.0 uL |
| Total | 28 uL |

## Step 6 

Quantification for each sample is down using a Qubit (HS dsDNA kit) first, then run on an Agilent tapestation for confirmation if there was a measurable amount of DNA using the Qubit.


## Step 6

