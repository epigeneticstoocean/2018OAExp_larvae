# BS Conversion test with new short i5 primer

### Overview
Using new i5 primer I tested the pico methylation library prep to determine if the new shortened primers perform better than the custom primers previously designed.


**Sample** : previously created 5ng/ul (20ul x 5 = 100ng) unmethylated lambda DNA [LINK](https://github.com/epigeneticstoocean/2018OAExp_larvae/blob/master/notebook/20200904_lambdaDNAworkingstock.md)

**Protocol** : Standard pico methylation protocol


**Primers**

| Sample | i5 primer | i7 primer |
|:------:|:---------:|:---------:|
| A | Zymo | D |
| custom | A508 custom | D |

### Quantification

#### Qubit


| Sample | concentration (ng/ul) | 
|:------:|:---------:|
| A (post BS conversion) | 0.528 | 
| custom  (post BS conversion)  | 0.534 |
| A (final amplification) | 18.10 | 
| custom  (final amplification)  | 8.10  |

#### Tapestation

Looks like the Zymo i5 worked to some degree, but did not work using the new short i5 primer.

[Link](https://github.com/epigeneticstoocean/2018OAExp_larvae/blob/master/labwork/sequencing%20reports/2020-09-24-01.D1000_i5_L1LotterhosLab_shortAdapter.pdf)

### Results

It looks like we had some primer dimer, unfortunately, in our custom i5 primer. In the tapestation we had a peak near 60 bp. I think this makes some sense if the primers binded to themselves rather than the DNA template.

### Next steps

In order :

* I plan on doing a secondary confirmation of the i5 custom annealing using the zymo primer as a control (something I forgot to do on my last gel).

* Perform a custom primer test using a range of temperatures in the thermocycle (recommendation from the Zymo rep)

* Use the putnam protocol augments.
