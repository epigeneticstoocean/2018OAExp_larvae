# Revised plan for sample sequencing

**Description** : To look at intergenerational DNA methylation I will be using a **WGBSseq** approach to sequence female (eggs) and larvae (pooled samples on filters) to look at the potential for transmission of epigenetic marks, with a specific focus on identifying marks that are differentially methylated among OA treatments.

**Samples**
* Eggs from females exposed for 1 month (2 treatments x 8 females per treatment) = 8 samples
* Zygotes (fertilized eggs reared in control conditions for a couple of hours) = 
* Larvae  (3 day old D stage larvae) = 

* Sample targets will also focus on sampelst that overlap with Elises work on larvae structure using the SEM [LINK](https://github.com/epigeneticstoocean/2018OAExp_larvae/blob/master/notebook/20191111_EliseSampleList.md)

**Sequencing Pipeline**
* Extraction using omega kit (using our current kit to try out the extraction protocol)
    * Alternative: [Kit Jon used for his larvae stuff](https://www.zymoresearch.com/collections/quick-dna-rna-kits/products/quick-dna-rna-miniprep-plus-kit)
    * **Note** : library prep. does not need sonicated DNA (bisulfite conversion is responsible for the shearing).
* Library Prep - [Pico kit](https://www.zymoresearch.com/products/pico-methyl-seq-library-prep-kit)
    * [Protocol](https://files.zymoresearch.com/protocols/_d5455_d5456_picomethylseq.pdf)
    * We have 50 preps.
* Pool and Sequence

**Barcoding Breakdown**

* Kit comes with 6 indexes. These are the same as those from the [*TruSeq Small RNA Kits*](https://support.illumina.com/content/dam/illumina-support/documents/documentation/chemistry_documentation/samplepreps_truseq/truseqsmallrna/truseq-small-rna-library-prep-kit-reference-guide-15004197-02.pdf)
   * Illumina : 2,4,5,6,7,12
* That kit has up to 148 index adapter sequences, however, there are grouped into 4 groups, and not all indexes can be multipexed together. See [page 25 of this index pooling guide](https://www.illumina.com/content/dam/illumina-support/documents/documentation/chemistry_documentation/experiment-design/index-adapters-pooling-guide-1000000041074-05.pdf).
* I think in theory these should be compatiple with some of our custom adapters given that they both were based on TruSeq Illumina design. Looks like they will work for at least some of Jons old eec-seq adapters potentially, but may not be ideal for the kapa lib. prep primers we more recently ordered.

**Multiplex Thoughts from Zymo from there pico kit Q and A**  
1. Ensure that there is diversity within the first couple of bases. Illumina recommends **choosing barcodes that do not share the same base at the position 2.** Order new primers according to the “Can additional index primers be purchased for multiplexing?” section 3. Illumina recommends the following multiplexing strategy for 6 or fewer samples: Pool of 2 samples: • Index #6 GCCAAT • Index #12 CTTGTA Pool of 3 samples: • Index #4 TGACCA • Index #6 GCCAAT • Index #12 CTTGTA Pool of 6 samples: • Index #2 CGATGT • Index #4 TGACCA • Index #5 ACAGTG • Index #6 GCCAAT • Index #7 CAGATC • Index #12 CTTGTA


[Detailed info about small RNA primers used by illumina (and adopted by zymo in this kit) on pg 32](https://support.illumina.com/content/dam/illumina-support/documents/documentation/chemistry_documentation/experiment-design/illumina-adapter-sequences-1000000002694-11.pdf)

RNA PCR Primer(RP1)  
5′AATGATACGGCGACCACCGAGATCTACACGTTCAGAGTTCTACAGTCCGA  
RNA PCR Index Primers  
5′CAAGCAGAAGACGGCATACGAGAT[6bases]GTGACTGGAGTTCCTTGGCACCCGAGAATTCCA  

[LINK to our primer / index database](https://docs.google.com/spreadsheets/d/1chXHQN3bYWArrUJmSRBO9Q_H8i_63yZAIdsu1xE6KHc/edit#gid=917843354)

[Order info for illumina small RNA Tru Seq Adapters](https://www.illumina.com/products/by-type/sequencing-kits/library-prep-kits/truseq-small-rna.html)

**Sequencer Targets**
* Machine :  Illumina 4500
* Coverage : 40x
* Expected duplication % : 10% (based on previous data)
* Bp length : Zymo recommends 50bp (100 bp paired).

**Sequence Estimates**

[LINK for simple workup of estimates using illumina calculator and harvard core facility pricing](https://github.com/epigeneticstoocean/2018OAExp_larvae/blob/master/notebook/20191112_illuminaCostCalSummary.md)



