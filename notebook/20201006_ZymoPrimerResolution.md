# Update from Zymo Regarding Primer Trouble

### Overview
After some back and forth I finally found out that the i5 primer needs to be added to the final PCR step (Step 5) not the preceeding PCR. This was not clear from the directions or from previous communication with the rep. From the conversation I learned that the final PCR primer mix is a combination of the two index primers, but only the i7 is label (following the letter labeling scheme provided by the kit). This means that I will need to exclude this primer altogether and either use pre-existing i5 and i7 or order new ones.


### Actual Dialog from Zymo rep

Oct 5th 2020
```
The custom i5 will not work in the initial LibraryAmp Amplification in Section 4. I didn’t realize you were using it in that section. If you’re using the custom i5 primer to add another barcode, you’ll have to use it in Section 5 of the protocol in the index PCR. The library made up to Section 4 will not have enough (if any) of the adapter sequence for the i5 to prime off of.

I recommend using the LibraryAmp Primers that are included in the kit for Section 4, then mixing the i5/i7 primers of your choice for Section 5. However, the index primers that come with the kit are already a mix of p5/p7 primers. You would have to order i7 primers to use with your custom i5.
```

### Primers plan

The index primer in section five consists of BOTH i5 and 17 at a concentration of 10uM.  As an initial plan I will try to use 0.5uL of each custom primer (i5 and i7) in the final PCR as an alternative to the index primers available in the pico methylation kit.

**Primers**

i5
```
From Zymo
5’-AATGATACGGCGACCACCGAGATCTACAC------------TCTTTCCCTACACGACGCTCTT-3’ i5 provided initial by Zymo
5'-AATGATACGGCGACCACCGAGATCTACACNNNNNN--ACACTCTTTCCCTACACGAC-3' i5 also provided by Zymo (6 base example)

Custom Primers
5'-AATGATACGGCGACCACCGAGATCTACACNNNNNNNNACACTCTTTCCCTACACGACGCTCTTCCGATCT-3' i5 custom - previously ordered (8 base index)
5'-AATGATACGGCGACCACCGAGATCTACACNNNNNN--ACACTCTTTCCCTACACGAC-3' i5 custom - new using short design from Zymo (6 based index)
```

i7
```
5’-CAAGCAGAAGACGGCATACGAGAT------GTGACTGGAGTTCAGACGTGTG-3’ i7 provided initially by Zymo
5'-CAAGCAGAAGACGGCATACGAGATNNNNNNGTGACTGGAGTTCAGACGTGTGC-3' i7 custom - previously ordered (6 base index)
```

### Test design


| Sample | i5 name | i5 index | i7 name | i7 index | 
|:------:|:--:|:--:|:--:|:--:|
| Zymo | Index A  | None | Index A | CGATGT | 
| Custom 1 | i5_PCRprimer_L1_D501_AGGCTATA (old) | AGGCTATA | PCR2_09_GATCAG | GATCAG |
| Custom 2 | A508 (new) | TAGACCTA | PCR2_09_GATCAG | GATCAG |

### Library Test

Performed a test on three samples using primer design above and following standard manufacturers protocols. I quantified the results using a Qubit HS dsDNA. In the final PCR step (indexing PCR), I added 0.5 ul of the primer mix (10uM) to the Zymo sample (contains both i5 and i7), while I added 0.5ul of each primer (conc. 10uM) for the two custom primer samples.  

**Quantification results**:

| Sample | Conc. (ng/ul)|
|:------:|:--:|
| Zymo | 15.5  | 
| Custom 1 | 0.98 | 
| Custom 2 | 1.5 | 

It appears that the custom primers didn't work, although I did see slightly more product in the custom 2. I will be running this on the tapestation to determine is this may be a small amount of amplification of the target sequence of primer dimer.

     
     
