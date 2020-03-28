## Extraction Test

I performed a preliminary test using the protocol provided by the Hare Lab ([link to protocol](https://github.com/epigeneticstoocean/2018OAExp_larvae/blob/master/protocols/hare_larvaeExtractionProtocol.md)) using **adult mantle** tissue from the L16 experiment (081 RNA Mantle 080116) and **larvae** from the failed 1-L larval cross experiment (J509). For reference,the larvae were approximately D stage (3 days old) and were collected by filtering a 5 liter container through a 50 micron filter and immediately flash freezing filter. We don't have a precise measure of mortality within the 5 liter containers, so the filter could have contained somewhere between a couple hundred to a couple thousand larvae.  

**Additional documentation on PAGE 6 and 7 of the lab manual**

## Extraction Protocol

* Standard protocol instructions were followed as outlined in the Hare Lab protocol link. This also included making working stocks for several reagents (see lab notebook).
* The larvae digestion was prepped by first using 95% EtoH in a sterile squeeze bottle to genetly rinse the filter and push any larvae towards the center of the filter, then using a sterile scapel I cut the filter from the plastic casing and transferred it directly into a 1.5mL tube (I digested the larvae directly off the filter paper).
* I digested the larvae and blank in 1000uL lysing buffer/prot k (200 uL for the mantle samples).
* After an overnight digestion I ended up splitting the volumes into an A and B tube to make sure I could accomodate the proper amount of EtOH (based on calculations from the standard protocol scaled up). For the larvae this meant leaving the piece of filter paper in tube A.
* Followed standard protocol and performed centrifuge steps using a refridgerated centrifuge set to -11C.
* I eluted in **50uL of TRIS HCL 8pH** for each tube (so 100uL total for the larvae and blank).

## Results

1) I noticed that all samples had residual precipitate left over similar to the zygote test. This is most likely excess salt, which doesn't appear to impact the quantification of the extracted DNA (see quantification below). 
2) I will also be doing a follow up BS conversion library prep using these samples, so i'll be able to confirm that this residual precipitate also doesn't interfer with downstream processing. 

### Quantification
 
 **Qubit HS DNA**
 
  * Larvae J509 A (with filter) : 7.08 nl/ul 
  * Larvae J509 B (no filter) : 7.77 ng/ul 
  * Mantle Tissue 1 : 75.8 ng/ul
  * Mantle Tissue 2 : TO LOW (this sample failed for some reason?)
  * Blank A : TO LOW   
  * Blank B : TO LOW
 
 Larvae extraction total mass
  * (7.77+7.08)/2 = 7.45 ng/ul * (50ul*2) = **745 ng total larvae DNA**
  
**DNA fragments on gel**
  
Calculated out 20ng of DNA for each sample (zygote sample from previous extraction, larvae A, mantle A) to make sure there was equal quantity among samples. Found that both zygote and larvae had large DNA fragment (>1200bp), while the mantle tissue sample didn't seem to work as well (low fragment size) and the blank didn't show up at all. This confirms that while there are residual salts in the final extraction solution they don't appear to be impacting the quantification.

![](https://github.com/epigeneticstoocean/2018OAExp_larvae/blob/master/figures/20200207_testExtraction2Gel.jpg)
