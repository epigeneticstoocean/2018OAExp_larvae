# Thoughts on indexing samples for sequencing

## Indexes given by Zymo in their Pico Methylation Kit

Zymo kit provides us with **6** unique **P7 indexes** that are slightly custom, but based on TRUSeq small RNA primers. These include indexes 2,4,5,6,7,and 12.

Their design:

P7: 5’-CAAGCAGAAGACGGCATACGAGAT**BBBBBB**GTGACTGGAGTTCAGACGTGTG-3’
P5: 5’-AATGATACGGCGACCACCGAGATCTACACTCTTTCCCTACACGACGCTCTT-3’
Alternative P5:
    5'-AATGATACGGCGACCACCGAGATCTACAC**BBBBBB**ACACTCTTTCCCTACACGAC-3'

The barcode numbers they provide match up with the illumina barcodes, but the sequence itself is slightly different.

**Notes from the Zymo Rep**

You can sequence up to 96 samples as long as the sequencer output is enough for the genome size you’re working with. We do not sell additional primers, but you can order them from your favorite custom oligo vendor. **Each index primer set in the Pico Methyl-Seq Library Prep kit is composed of two primers, P5 and P7, at a concentration of 10 uM**. The index primers that are included in the Pico Methyl-Seq kit are based off of the Illumina TruSeq index primers (dashes are the 6-nucleotide barcode sequence, which is only on the P7). You can order the primers from your favorite oligo vendor. The **primers do not need to be specially purified – we use standard desalting**.

**It is up to you whether you want to use the full barcode (8 bases listed above) or use only the first 6 bases**. Just make sure that you input the correct sequence for demultiplexing in the sample sheet. An alternative would be to use the IDT for Illumina TruSeq UD Indexes.

**8 base Index list from Illumina for i5 primers**
![](https://github.com/epigeneticstoocean/2018OAExp_larvae/blob/master/notebook/img/image008.png)


