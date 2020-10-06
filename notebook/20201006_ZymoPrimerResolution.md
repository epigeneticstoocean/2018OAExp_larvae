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

```

i7
```

```
