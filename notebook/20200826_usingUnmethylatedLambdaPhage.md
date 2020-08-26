# Thoughts on using lambda phage

**Purpose** : Using a [unmethylated lambda phage](https://www.promega.com/products/biochemicals-and-labware/nucleic-acids/unmethylated-lambda-dna/?catNum=D1521#specifications) allows for us to estimate the conversion efficiency of the bisulfite conversion.

**Generally how it works** :  
 * Include small amoung of unmethylated lambda phage samples (~1% or less, 1 ng lambda phage vs. 100 ng sample) prior to conversion
 * Prep library and sequence.
 * Map lambda phage to phage genome.
 * Estimate number of methylated cytosines vs. unmethylated cytosines (from bismark) to determine BS conversion efficiency.

[**Holly Putnam / Steven Roberts thread on lambda phage and PSI X"](https://github.com/RobertsLab/resources/issues/753)  

[**Biostars thoughts on using lambda phage**](https://www.biostars.org/p/151034/)
