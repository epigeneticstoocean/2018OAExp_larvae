# Thoughts on indexing samples for sequencing  

## Indexes given by Zymo in their Pico Methylation Kit  

Zymo kit provides us with **6** unique **P7 indexes** that are slightly custom, but based on TRUSeq small RNA primers. These include indexes 2,4,5,6,7,and 12.

Their design:

P7: 5’-CAAGCAGAAGACGGCATACGAGAT**BBBBBB**GTGACTGGAGTTCAGACGTGTG-3’

P5: 5’-AATGATACGGCGACCACCGAGATCTACACTCTTTCCCTACACGACGCTCTT-3’

Alternative P5 suggested by Zymo rep:  
    5'-AATGATACGGCGACCACCGAGATCTACAC**BBBBBB**ACACTCTTTCCCTACACGAC-3'

The barcode numbers they provide match up with the illumina barcodes, but the sequence itself is slightly different.

**Notes from the Zymo Rep**

You can sequence up to 96 samples as long as the sequencer output is enough for the genome size you’re working with. We do not sell additional primers, but you can order them from your favorite custom oligo vendor. **Each index primer set in the Pico Methyl-Seq Library Prep kit is composed of two primers, P5 and P7, at a concentration of 10 uM**. The index primers that are included in the Pico Methyl-Seq kit are based off of the Illumina TruSeq index primers (dashes are the 6-nucleotide barcode sequence, which is only on the P7). You can order the primers from your favorite oligo vendor. The **primers do not need to be specially purified – we use standard desalting**.

**It is up to you whether you want to use the full barcode (8 bases listed above) or use only the first 6 bases**. Just make sure that you input the correct sequence for demultiplexing in the sample sheet. An alternative would be to use the IDT for Illumina TruSeq UD Indexes.

**8 base Index list from Illumina for i5 primers**
![](https://github.com/epigeneticstoocean/2018OAExp_larvae/blob/master/notebook/img/image008.png)

**Alternative Illumina TruSeq UD Index System**
 
 * Also uses an 8 base barcode
 
P7 : 5'-CAAGCAGAAGACGGCATACGAGAT[i7]GTCTCGTGGGCTCGG-3'  
P5 : 5'-AATGATACGGCGACCACCGAGATCTACAC[i5]TCGTCGGCAGCGTC-3'   

[Index/Barcode options](https://support.illumina.com/content/dam/illumina-support/documents/documentation/chemistry_documentation/experiment-design/illumina-adapter-sequences-1000000002694-11.pdf)

## Our Indexes   

[LINK](https://docs.google.com/spreadsheets/d/1chXHQN3bYWArrUJmSRBO9Q_H8i_63yZAIdsu1xE6KHc/edit#gid=917843354)

Example of P5 primer:  
       5'-AATGATACGGCGACCACCGAGATCTACAC**TATAGCCT**ACACTCTTTCCCTACACGAC**GCTCTTCCGATCT**-3'  
       
 Difference from Zymo optios:  
    * Uses an 8 base barcode  
    * Contains additional 13 bases on 3 primer end  
 
We have 12 different P5 barcodes of these:  
i5_PCRprimer_L1_D501_AGGCTATA  
i5_PCRprimer_L2_D502_GCCTCTAT  
i5_PCRprimer_L3_D503_AGGATAGG  
i5_PCRprimer_L4_D504_TCAGAGCC  
i5_PCRprimer_L5_D505_CTTCGCCT  
i5_PCRprimer_L6_D506_TAAGATTA  
i5_PCRprimer_L7_D507_ACGTCCTG   
i5_PCRprimer_L8_D508_GTCAGTAC  
i5_PCRprimer_L9_TTGTCGGT  
i5_PCRprimer_L10_TTGCCACT  
i5_PCRprimer_L11_AGTCTGTG  
i5_PCRprimer_L12_AAGTGTCG  

Example of P7 primer: 
      5'-CAAGCAGAAGACGGCATACGAGAT**CGTGATGT**{GT}GACTGGAGTTCAGACGTGTG**C**-3'  

Difference from Zymo optios:  
    * Uses an 8 base barcode  
    * Contains additional 1 base on 3 primer end 
    * Missing 2 bases immediately next to the index (in curly brackets) compared to Zymo P7 primer
    
We have 12 different P7 barcodes of these:  
PCR2_01_ATCACG  
PCR2_02_CGATGT  
PCR2_03_TTAGGC  
PCR2_04_TGACCA  
PCR2_05_ACAGTG  
PCR2_06_GCCAAT  
PCR2_07_CAGATC  
PCR2_08_ACTTGA  
PCR2_09_GATCAG  
PCR2_10_TAGCTT  
PCR2_11_GGCTAC  
PCR2_12_CTTGTA  
