# Hspice Lab5
Q: How to encode a file
```

```

# Commonly used IDE for Hspice

# Architecture
1. Know where CMOS should be connected.
2. The working voltage of your circuit.
3. Do AC,DC analysis.
4. Perform simulation, analyzing delay , power and voltage. See if spec is met.

# Examples?

# Control statement
1. .AC,.DC,.TRAN are commonly use.

### Note that 0 is always gnd.


## The 0 in number string are all ignored, also the character within the string is always neglected.

## In different hierarchy, the name of the nodes can actually be the same, however, this is not the case for same hierarchy.

## Commonly used elements.
- C
- EFGH
- M:MOSFET
- V:Voltage source


## COMPONENT MOSFET
- Type : calls different types of NMOS or PMOS from the library.
- Usually used FinFET when calling out MOSFET components.

## Subckt
- Look it like a reusable function, where parameter is the function input for module reuses.
Q: Are there any syntax that mimics things like for loop within verilog?
```

```

## PROTECT
1. Used to prevent from printing out library infos.


## Sweep
1. Sweeping works like a in range function, slowly progressing using a certain step.


## Pulse
1. Vin is commonly used for pulse generation.

# Digital vector file
1. Vector pattern definition


```
    hspice -i NETLIST.sp -o NETLIST.lis
```


# Viewing waveform
- Using waveview to get the waveform.
```
    wv &
```
- Within waveform viewer, you can simply click update everyime after you reload your design.

# Error file
- Err0 file can helps debugging, works like a testbench.

# Python script can be used to generate multiple sub circuits.
1. Buffers = 2INV should be inserted to prevent infinite driving circuits.
2. Useful snippets for sub circuit generation.

```C

.subckt nand2 A B Y

    Mpa Y A VDD VDD pmos_lvt m=1
    Mpb Y B VDD VDD nmos_lvt m=1

    Mna Y A node1 x nmos_lvt m=1
    Mnb node1 B GND x nmos_lvt m=1
.ends

Xnand2 a1 b1 out nand2

```
# Script for port connection automation
- Since for loop does not exist within Hspice, thus we have to code out our own script for complicated port connections. Following code is used to aid the connection of the and64 tree structure.

```python

STAGES = 6
stage = [32,16,8,4,2,1]
for j in range(STAGES):
    print(f"**Stages:{j}**")
    cnt = 1
    for i in range(0,stage[j]):
        # print(f"c{i}",end=" ")

        # print(f"Mn{i} result c{i} GND x nmos_lvt  m=1")
        #                   D      G   S  X

        # if i == 0:
        #     print(f"Mp{i}  n{i}  c{i}  VDD   x pmos_lvt  m=1")
        # elif i == 63:
        #     print(f"Mp{i} result c{i} n{i-1} x pmos_lvt  m=1")
        # else:
        #     print(f"Mp{i}  n{i}  c{i} n{i-1} x pmos_lvt  m=1")

        # print(f"XoneBitCompBuf{i} a{i} b{i} c{i} oneBitCompBuf")
        if j == 0:
            print(f"Xand2_{j}_{i} c{i*2} c{i*2+1} s_{j}_{i} and2")
        else:
            print(f"Xand2_{j}_{i} s_{j-1}_{i*2} s_{j-1}_{i*2+1} s_{j}_{i} and2")

```

# Debug notes
1. Within Hspice, there is no upper case and lower case difference, thus when declaring nodes, na should be declared. instead of a.
2. Hspice coding style should be followed to prevent yourself from connecting circuit onto the same node.
3. Note the 4th parameter of MOSFET should be connected according to PMOS and NMOS. PMOS's Bulk uses VDD and NMOS Bulk uses GND. This example is an and2 gate. Note, adding an inverter makes driving ability better.

```s
.subckt and2  A B Y
    **  D    G   S    X **
    **PMOS**
    Mp1 result A VDD VDD pmos_lvt m=1
    Mp2 result B VDD VDD pmos_lvt m=1

    **NMOS**
    Mn1 result A na   GND nmos_lvt m=1
    Mn2 na      B GND GND nmos_lvt m=1

    *inverter*
    Xinv0 result Y  INV msize=1

.ends

```

4. XNOR gate is the 1-bit comparator, using truth table is sometimes a great way to simplify your logic.