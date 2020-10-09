# Calculations for creating 10uM primer mix

### Overview
The goal is to create a 10uM primer mix using custom primers that mirrors the primer mixes provides by Zymo. After the first test adding two primers (i5 and i7) to the final PCR, it appeared that one of the custom samples worked marginally, but was not as efficient as the sample using only Zymo primers. One possible reason for this was use of a mix that combines i5 and i7 primers.


### Calculation

```
M1 x V1 = M2 x V2

```

In this cas we want a final molarity of 10uM (M2 = 10uM) and to create a final volume of 5 ul (V2 = 10uM). The molarity of both primers is also adjusted to 10uM (M1 = 10uM). Since we are adding equal amount of either primer we are solving for half V1
```
2 x V1 = M2 x V2 / M1
````
with values,
```
2 x V1 = 10uM x 5uL / 10uM
```
simplified,
```
V1 = 5uL/2

V1 = 2.5 uL per primer (primers at 10uM)
```

If we did this for all combinations that would requre 2.5uL x 8 = 20uL of each primer (both i5 and i7s) adjusted to 10uM if we used an 8 x 8 primer design. 
