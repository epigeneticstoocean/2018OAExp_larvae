# Hare lab larval extraction protocol - Based on Sawada et al. 2008

### Description
This protocol is for extraction from individual larvae (or small groups of larvae) for the purposes of Next-generation sequencing (NGS). One big factor in determining how many larvae to use per extraction is larval size. This protocol has been used with 7-day-old and 20-day-old oyster larvae (ethanol preserved). If extra larvae are available, it is highly recommended to do test extractions with a variety of numbers of larvae in order to determine how many will be needed.

### Steps

1) **Larval selection and isolation**

Start with clean, ethanol-preserved larvae (sieved to size-select and remove as much debris as possible). Fresh is better, of course, but who can manage that?! Transfer a portion of the larval sample to a clean glass Petri dish. Under a dissection microscope, aspirate individual larvae into a 10ul pipette tip, transferring as little liquid as possible. Pipette into a tube or strip. Typically, 10-20 larvae can be transferred at a time, and it is helpful to transfer by tens to keep count. Select only “full” larvae, as clear shells mean that the larva has died and degraded. After the target number of larvae have been transferred, centrifuge the sample briefly and remove as much supernatant as possible without losing larvae.

2) **Lysis and Digestion**
This protocol was modified from Sawada et al 2008. First, prepare a larval lysis buffer stock:

|Reagent|Stock Conc.|Final Conc.|Amount|
|:-----:|:---------:|:---------:|:----:|
|Ammonium sulfate|132.134 g/mol|166mM|1.1g|
|Tween 20|20%|0.1%|25ul|
|Water|||Up to 50mL|
|Total Vol.|||50m:|

Just before use, add 20% proteinase K by volume (for example for 1ml, combine 800ul digestion buffer with 200ul Proteinase K)

After removing ethanol supernatant from the larval samples, add 1ul lysis buffer/ProK mix for each larva in the pool. For example when extracting 50 larvae, add 50ul lysis mix. Incubate at 55C overnight or until all soft material has digested. Shells will remain. Shells will often also stay partially closed for extended periods of time, so overnight digestion is often necessary.

3) **Purification**

Before use in enzymatic reactions samples must be purified. A quick and easy method for this is ethanol precipitation.

    a) To the lysate, add 2x volume of cold (-20C) 100% ethanol. For example, if using 50ul lysate, add 100ul ethanol.
    b) Add 1/10 volume of 3M sodium acetate (for example, if using 50ul lysate, add 5ul NaOAc)
    c) Mix by quickly inverting several times.
    d) Incubate at -20 for at least 20 minutes.
    e) Centrifuge 10 minutes at maximum speed (at least 12k rpm). A refrigerated centrifuge is ideal, but room temperature can also be used.
    f) Remove the supernatant. A pellet may not be visible, so care must be taken with this step.
    g) Add 500ul 70% ethanol to wash the pellet. Invert several times, then centrifuge 5 minutes at maximum speed. Remove supernatant.
    h) Repeat g once more for a total of two washes.
    i) Air dry the pellet until all liquid has just disappeared, usually 5-10 minutes.
    j) Resuspend in an appropriate volume of water or (ideally) of Tris HCl pH 7.5-8.

4) **Results**

Quantify the resulting purified DNA using a Qubit HS kit. In order to obtain enough DNA for NGS, typically at least 100-500ng should be recovered. Purity is also important, so an aliquot of 20-100ng should be run on a gDNA gel to assess degradation and purity (impurities from carryover reagents will distort the way the DNA runs). A Nanodrop can also be used to assess purity, but only if the DNA concentration is over 20ng/ul. 

Based on preliminary testing, at least 50 of the 20-day-old larvae were needed per lysis to obtain consistently high yields. 80-120 of the 7-day-old larvae were needed to obtain yields over 100ng, but neither number got yields higher than 250ng, and this size class wasn’t tested with ethanol precipitation.

Two alternative methods were also tested briefly: Qiagen’s DNeasy kit, and TaKaRa’s Nucleospin kit. Both provided yields of about 10-20% the amount of DNA from the modified Sawada et al protocol. 

