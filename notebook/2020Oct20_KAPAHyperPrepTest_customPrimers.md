# Library prep test using KAPA hyper prep kit and custom primers

## Overview
This test was to confirm that the custom design primers (specifically the stock I am working with) is work properly. For the test I made new working stocks for both the adapters (y-inline nobarcode) and the primers (i5s -`i5_PCRprimer_L5_D505_CTTCGCCT ` and `I5_A508_6bp_picoMethyl_A`; i7 - `PCR2_09_GATCAG`). I then performed a standard KAPA hyperplus library prep on three samples (Sample 1: using the KAPA standard primers for the final PCR step, Sample 2: using the long custom i5 primer, Sample 3: using the short custom i5 primer,`I5_A508_6bp_picoMethyl_A`). The aim was to confirm these working stocks work using a protocol that has worked previously with these primers.

## Notebook entry
![](https://github.com/epigeneticstoocean/2018OAExp_larvae/blob/master/figures/pg29_2020Oct21_HyperKitPrep_customPrimers_pt1.jpg)
![](https://github.com/epigeneticstoocean/2018OAExp_larvae/blob/master/figures/pg30_2020Oct21_HyperKitPrep_customPrimers_pt2.jpg)
![](https://github.com/epigeneticstoocean/2018OAExp_larvae/blob/master/figures/pg31_2020Oct21_HyperKitPrep_customPrimers_pt3.jpg)

## [Confirming adapter and primer compatability](https://docs.google.com/document/d/1U8CH-pDtkQffdZUC7FBZo6pA2GM9r0NLqMxDMgERMnw/edit#heading=h.8yhxvl68q6tx)

## [Agilent Results](https://github.com/epigeneticstoocean/2018OAExp_larvae/blob/master/labwork/sequencing%20reports/2020-10-21-02.D1000_i5_L1LotterhosLab_KAPATEST.pdf)

## Thoughts

It appears that the amplification was not successfull using the KAPA Hyper prep kit following standard manufacturers instructions. From the tapestation we still see the final product in S2 and S3 (the original custom i5 and the new short custom i5,respectively) were the same as the target size of the sheared DNA (150bp). There is also a spike at small bp (~70-80bp) which indicates that some dimer might be present.

**Possible issues**:
* Smaller DNA input than expect - I used a Qubit to look at the concentration of the template 150bp dna sequence and found that is was about half what I expected based on my calculations, so I was likely starting with closer to 50ng of DNA. I would expect this to negatively effect the overall amount of final product, but not prevent any amplfication.
* Overnight A-tailing - Starting the reaction took longer than expect and I had to keep the A-tailed product overnight rather than proceeding directly into ligation. This could also negatively impact the overall output, but I don't think it should prevent it from working all together.
