# A test to look at the lotterhos i5 lab primers 

## Overview

Performed a test to examine whether using the i5 lotterhos illumina primer (ID : i5_PCRprimer_L1_D501_AGGCTATA) in the Pico Methylation Library prep kit would led to amplification. The two most abundant samples from the previous extraction steps were used.

## Samples 

EFO5 x EM01  - larvae - exposed treatment - conc. 48.4 ng/ul  
CF01 x CM01  - zygote - control treatment - conc. 47.6 ng/ul 

100 ng used as starting amount for both samples

## Protocol Notes

Used standard protocol from [zymo](https://github.com/epigeneticstoocean/2018OAExp_larvae/blob/master/protocols/_d5455_d5456_picomethylseq.pdf)

Notes on the library prep:
* On sample EF05xEM01 elution for section 1 the elution buffer was not added to column matrix. An additional 4 ul of elution buffer was added directly to column matrix following the suggestion of the manufacturer.
* Used original 20uM i5 L1 stock but diluted it to 10uM to match the conc. of the zymo primer.
* Heated the elution buffer to 35 C.

Primer Table

| Sample | i5 Primer | i7 primer |
|:----:|:-----:|:----:|
| EF05 x EM01 | Lotterhos L1 | Zymo A |
| CF01 x CM01 | Zymo PreAmp Primer | Primer B |

Final elution 12 uL.

## Results

Qubit Quantification (dsDNA HS kit)

| Sample | Conc. | 
|:----:|:-----:|
| EF05 x EM01 | 0.218 ng/ul | 
| CF01 x CM01 | 7.62 ng/ul | 

**Links to tapestion**
* [EM05 x EF01 - Larvae sample using lotterhos i7 primer](https://github.com/epigeneticstoocean/2018OAExp_larvae/blob/master/labwork/sequencing%20reports/2020-08-27-01.D1000_i5_L1LotterhosAdapter_PicoMethylationKitTest.pdf)
* [CF01 x CM01 - Zygote sample using zymo i7 primer](https://github.com/epigeneticstoocean/2018OAExp_larvae/blob/master/labwork/sequencing%20reports/2020-09-03-01.D1000_i5_L1LotterhosAdapter_PicoMethylationKitTest_controlSample.pdf)

## Discussion

The lotterhos i5 (i5_PCRprimer_L1_D501_AGGCTATA) did not work. It would appear we had reason amplification (generated 7.62 x 12 = 91.44 ng of product). Based on the tape station i did not see much evidence of primer dimer, so we might not need an additional clean-up step (as seen in the [Putnam protocol](https://github.com/epigeneticstoocean/2018OAExp_larvae/blob/master/notebook/20200827_PutnamProtocolForPicoMethylationKit.md)).

* From the test we can safely rule out a reagent issue since the control worked.

**Reasons for sample prep failure**

* DNA sample quality issue - It could be a sample quality problem. I will go back a requantify the sample to control the previously estimated conc. is still the same.
* Lotterhos primer stock issue - Possibly there is an issue with the lotterhos lab primer stock. I think I could probably check this by comparing primer stocks (ours vs. the zymo primer) on the tapestation.
* i5 primer compatability issue -  This shouldn't be a problem, but confirm there is not problem with the compatability between the lotterhos lab primers and the adapters added earlier.
