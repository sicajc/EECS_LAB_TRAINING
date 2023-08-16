# SRAM
- Timing units are used to determine when to turn on or off the decoders.


# Read operation path
1. input latch -> Timing units -> row decoder -> SRAM array -> sense amp -> col decoder -> address out latch

# Write operation
1. We must ensure data arrives before address arrives.


# Error
1. If no intersects in voltage graph, error. So discharge and charge must have intersection.

# Butterfly curve
1. It is created using the VTC if inverters.
2. Difference and then divided by sqrt2.

# SNM(Static noise margin)
1. The square of the butterfly is the SNM.

# BL % BLB
1. Prefer .ic

# SNM
1. Using the formula created on paper, we can rotates the VTC intersection curves, and get the boxes.