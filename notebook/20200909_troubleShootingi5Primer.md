# Troubleshooting i5 primer issues 

## Problem
In two separate tests I have been able to successfully perform the BS conversion and library amplification using the pico methylation kit:

* [First example using larvae samples](https://github.com/epigeneticstoocean/2018OAExp_larvae/blob/master/notebook/20200902_PrimerTest1_picoMethylationLibraryPrep.md)
* [Second example using lambda DNA](https://github.com/epigeneticstoocean/2018OAExp_larvae/blob/master/notebook/20200904_BSConversionUsingLamdaDNA.md)

## Troubleshooting so far...

### Confirmed our design
Confirmed with Zymo that our primer design is not the problem and should work with the kit (but may need some optimization):

**Me**  
```
I am working with previous developed p5 primers (8 base barcode) that look something like this:
AATGATACGGCGACCACCGAGATCTACACNNNNNNNNACACTCTTTCCCTACACGACGCTCTTCCGATCT

I am trying to figure out if these will also work with the pico methylation kit or will the section underlined above (which differs from the example your provided in your earlier email) would be problematic.
```
**Zymo**  
```
That p5 primer is compatible with the Pico adapters. The annealing temperature used in the protocol for the final PCR should work but you might have to do a temperature gradient to find the optimal temperature.
```
### Checked primer quality / concentration

[Compared the concentration of our primers to those from Zymo](https://github.com/epigeneticstoocean/2018OAExp_larvae/blob/master/notebook/20200903_primerAndSampleCheck.md). This doesn't rule out contamination issues, but does indicate that primers are annealed and present in our working stock.

## Potential future trouble shooting ...

## Order barcoded oligos using the shorter primer design suggested by Zymo

In the initial conversation with Zymo about barcoding they suggested using a shorter primer:

```
AATGATACGGCGACCACCGAGATCTACACNNNNNNACACTCTTTCCCTACACGAC
compare to ours ..
AATGATACGGCGACCACCGAGATCTACACNNNNNNNNACACTCTTTCCCTACACGACGCTCTTCCGATCT
```

One option is could try ordering a couple of these (about 20 dollars an oligo) to see if the short primer works.

## Remake our primer stock

Alternatively, we could remake the i5 primer working stock and see if that helps. This would correct the issue if it was due to contamination of the current working stock.

## Optimize the thermocycler protocol.

We could also try a range of annealing temperatures to see if we can improve yield by altering the PCR protocol. This was something suggested by the Zymo reps.


## Considerations for next steps

* I currently have 44 reactions pico methylation kit reactions. A new 25 sample kit would cost around 1300.
* Oligos would cost about 15-30 dollars per oligo (x2 per primer).
