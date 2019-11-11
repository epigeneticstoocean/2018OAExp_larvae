# Script for exploring the cost associated with different types of BSeq approaches and kits

Included three comparisons:
1) MecSeq without zymo kit `MEC_1200`
2) MecSeq with zymo pico kit `MEC_2500`
2) Whole gnome approach (following Raines et al. protocol) `WGBS 0`

LINK to full markdown : [https://github.com/DrK-Lo/Mec-Seq/blob/master/extra/cost_calculator.md](https://github.com/DrK-Lo/Mec-Seq/blob/master/extra/cost_calculator.md)

Take aways 
* Using the zymo kit doesn't reduce the number of samples possible (this is largely driven by the number of sequencing lanes. (84 vs. 87 samples with 50X coverage).
* WGBS will only support substantially fewer samples : 18 samples (44x coverage) or 27 samples (29x coverage)
* Estimates for Mec-Seq are still based on a reduction in the genome comparable to the size of the exome (what we expect if we used the mRNA as probes similar to EecSeq). This may need to change to reflect a MBD enrichment approach for making probes, which could increase (or decrease) the coverage of the genome being sequenced.
