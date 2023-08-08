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

# Error file
- Err0 file can helps debugging, works like a testbench.


# Python script can be used to generate multiple sub circuits.
1.
2. Buffers should be inserted to prevent infinite driving circuits.

```

.subckt nand2 A B Y
    Mpa Y A VDD x pmos_lvt m=1
    Mpb Y B VDD x nmos_lvt m=1
    Mna Y A node1 x nmos_lvt m=1
    Mnb node1 B GND x nmos_lvt m=1
.ends

Xnand2 a1 b1 out nand2

```