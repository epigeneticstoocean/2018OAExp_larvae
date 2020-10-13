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

# KEL calculations for creating 10uM primer mix

I'm not following the above calculation. If you have 10uM primer mix, you cannot combine two primers of a 10uM individual primer mix to end up with 10uM combined primer mix. Here is why (uM = picomoles/uL):

If you combine 2.5uL of 10uM primer_A + 2.5uL of 10uM primer_B, you have:

```
2.5uL * 10pM/uL = 25pM of primer A
2.5uL * 10pM/uL = 25pM of primer B

25pM/5uL = 5pM/uL = 5pM
```

Thus, combining equal amounts of two primer mixes will halve the molarity of your solution.

You need to start with a higher concentration of primers, and the final volume of your solution and work backwards:

```
Final volume = 10uL
Final molarity of each primer = 10uM = 10pM/uL
Starting molarity of each primer = 100uM primerA

Number of moles needed for a 10uM solution in a final volumen of 10uL
  10uL * 10pM/uL = XpM
  X = 100pM
  
Number uL of 100uM primer A:
  100uM = 100pM/uL
  100pM/uL * XuL = 100pM
  X = 1uL
  
Final recipe:
  1uL of 100uM primer A mix
  1uL of 100uM primer B mix
  8uL ddH20
```
