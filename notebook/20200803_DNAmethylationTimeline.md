# Remaining DNA methylation lab work - Aug 3 2020

## Done

1) Sample extraction:
All samples (adult mantle, larvae, zygotes) have been extracted. 

Here are the tables showing which samples we have viable DNA for either larvae or zygotes. 

**Zygotes**
[]()

**Larvae**
[]()


This means there will be :
* 16 females (8 controls + 8 exposed)
* 15 zygtoes (8 control + 7 exposed)
* 22 larvae samples (9 control + 13 exposed)
* Total : 53 samples

The plan is to do WGBS on these samples, using a single lane of S4 2x150bp NovaSeq. 

This will give us > 25x coverage for all samples even with 10x duplication error (which is what i saw with the last oyster methylation data):
[calculation](https://github.com/epigeneticstoocean/2018OAExp_larvae/blob/master/notebook/20191112_illuminaCostCalSummary.md)

2) Test Bisulfite conversion

Confirmed that we can successfully prep libraries using pico methlyation kit and 100ng of larvae sample.

### TO-DO

Library prep plan: Using duel index design with previous designed index (confirmed with genewiz this shouldn't be a problem). I will do BS conversion / library prep on all 53 samples. 

Using adapters we have I decided on a unique combinatorial index design [(illumina suggests this may help the potentially minor issue associated with index hopping)](https://support.illumina.com/bulletins/2017/08/recommended-strategies-for-unique-dual-index-designs.html)

[Additional info here](https://www.illumina.com/content/dam/illumina-marketing/documents/products/whitepapers/index-hopping-white-paper-770-2017-004.pdf)

### Timeline

Since the pico methylation kit has digestion tubes aliquots in samples of 10. I plan on processing samples in similar batches of ten. I budget 3 days per batch of ten, including library quantification at the end. This will mean 15 days to process 50 samples plus another 3 days (total of 18 days) to finish the remaining 3 samples and any samples that may have failed during the initial library prep. Working 6 days a week this should be done within 3 weeks. Tentative start date: Aug 24th.





