# Order details for new shorter i5 primers 

### Overview

Based on the last two failed BS conversion tests, I will be ordering a couple of primers that mirror the primers suggested by Zymo [see previous conversation]() rather than the longer i5 primers we currently have (even though these should still technically work but might need optimization).

**Primer template** 
```
5’-AATGATACGGCGACCACCGAGATCTACAC----------TCTTTCCCTACACGACGCTCTT-3’ # i5 available in kit
5'-AATGATACGGCGACCACCGAGATCTACACNNNNNNACACTCTTTCCCTACACGAC-3'       # Suggested by rep for ordering

Dashes (-) inserted to align sequence but are not present in actual primers.

``` 
Pasted from Zymo email

### Primers  

For reference the i7 primers that **comes with the Zymo kit**:

| Index | Index Illumina | Index Sequence |
|:-----:|:--------------:|:--------------:|
| A | 2 | CGATGT |
| B | 4 | TGACCA |
| C | 5 | ACAGTG |
| D | 6 | GCCAAT |
| E | 7 | CAGATC |
| F | 12 | CTTGTA |

And the list of suggest i5 barcodes from illumina TruSeq HT kit:
| i5 Index Name | i5 Bases |
|:-------------:|:--------:|
| A501 | TGAACCTT |
| A502 | TGCTAAGT |
| A503 | TGTTCTCT |
| A504 | TAAGACAC |
| A505 | CTAATCGA |
| A506 | CTAGAACA |
| A507 | TAAGTTCC |
| A508 | TAGACCTA |

These are currently 8 bases, but the Zymo rep said we could used the first 6 for a shorter primer.

Based on a [short comparison](https://docs.google.com/spreadsheets/d/11MV5KLuCR5RvFRHDP_nClV57Vo_q64rImCUX1rksYGc/edit#gid=0) I will use the `A508` barcode with 6 bases as my test. 


### Target primer for test  

The A508 barcode is sufficiently different that it shouldn't be a problem with the i7 primers used in the Zymo kit. Below are the oligos needed to make thie 6 bp version of the A508 barcode:

Sample oligos
```
Oligo 1:
5'-AATGATACGGCGACCACCGAGATCTACACTAGACCACACTCTTTCCCTACACGAC-3'
Oligo 2 (reverse compliment): 
5'-GTCGTGTAGGGAAAGAGTGTGGTCTAGTGTAGATCTCGGTGGTCGCCGTATCATT-3'
````

Order Template for IDT for A508 based i5 primer [LINK](https://github.com/epigeneticstoocean/2018OAExp_larvae/blob/master/labwork/2020Sep_shortPrimer_illuminai5A508_oligoOrder.xlsx)


