# Meeting with GENEWIZ


## Things to remember for their visit
 * Samples from Block 1
   * We have 16 female and 5 male gonads and gametes
      * Male sperm were sent to Yaamini
   * We have at most 65 zygote and larvae samples, some of these (up to 16) may have been combined, need to check notes
      * If we go NovaSeq S4 (based on offer) we could sequence all samples with >25 coverage. [Link to calculation](https://github.com/epigeneticstoocean/2018OAExp_larvae/blob/master/notebook/20191112_illuminaCostCalSummary.md)
 * Pico Methylation Kit
   * BS conversino digestion performs DNA cutting (no sonication)
   * PBAT approach for BS conversion (adapters after conversion)
   * Two PCR steps (first gets dsDNA fragments and second adds the primer w/ indexes)
   * No current post PCR or quantificaiton steps **question for GENEWIZ reps**.
 * Single vs. Duel Indexes
    * **Thought One from Zymo rep**: You can sequence up to 96 samples as long as the sequencer output is enough for the genome size you’re working with. We do not sell additional primers, but you can order them from your favorite custom oligo vendor. Each index primer set in the Pico Methyl-Seq Library Prep kit is composed of two primers, P5 and P7, at a concentration of 10 uM. The index primers that are included in the Pico Methyl-Seq kit are based off of the Illumina TruSeq index primers (dashes are the 6-nucleotide barcode sequence, which is only on the P7). You can order the primers from your favorite oligo vendor. The primers do not need to be specially purified – we use standard desalting.
      * P7: 5’-CAAGCAGAAGACGGCATACGAGAT------GTGACTGGAGTTCAGACGTGTG-3’
      * P5’-AATGATACGGCGACCACCGAGATCTACACTCTTTCCCTACACGACGCTCTT-3’
    * **Thought Two** : The Illumina Small RNA Primers are longer than the primer sequences I sent, but can still be used with the kit. To incorporate a P5 barcode, you can order the following primer sequence and add one of the i5 barcodes in the orientation shown in the second column of the table below:
      * AATGATACGGCGACCACCGAGATCTACACNNNNNNACACTCTTTCCCTACACGAC
    * It is up to you whether you want to use the full barcode (8 bases listed above) or use only the first 6 bases. Just make sure that you input the correct sequence for demultiplexing in the sample sheet. An alternative would be to use the [IDT for Illumina TruSeq UD Indexes](https://support.illumina.com/sequencing/sequencing_kits/idt-truseq-dna-rna-udi.html).

## Brief list of things to discuss
  * Discuss the duel index primer design. Ask if there are anything things we should be aware of when ordering the oligos.
  * Discuss the number of samples (based on numbers above) we could sequence and pricing across various platforms
  * Ask if they have any thoughts on size selection post PCR.
  
## Thoughts from GENEWIZ meeting
