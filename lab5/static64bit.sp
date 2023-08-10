.TITLE static CMOS 64bit comparator

*****************************
**     Library setting     **
*****************************
.protect
.include '7nm_TT.pm'
.unprotect


*****************************
**      Input Vector       **
*****************************
.VEC 'pattern_array.vec'

*****************************
**   SubCircuits   **
*****************************
.subckt INV in out msize=1
    **  D    G   S    X **
    Mp  out  in  VDD  VDD  pmos_lvt  m=msize
    Mn  out  in  GND  GND  nmos_lvt  m=msize
.ends


.subckt oneBitComp A B Y
    **  Inverters **
    Xinv1 A A_inv INV
    Xinv2 B B_inv INV msize=1

    **  D    G   S    X **
    **  PMOS **
    Mp1  a           A          VDD    VDD  pmos_lvt  m=1
    Mp2  Y           B          a      VDD  pmos_lvt  m=1
    Mp3  b           A_inv      VDD    VDD  pmos_lvt  m=1
    Mp4  Y           B_inv      b      VDD  pmos_lvt  m=1

    **  NMOS **
    Mn1  Y           A              c     GND  nmos_lvt  m=1
    Mn3  Y           A_inv          d     GND  nmos_lvt  m=1
    Mn2  c           B_inv          GND   GND  nmos_lvt  m=1
    Mn4  d           B              GND   GND  nmos_lvt  m=1

.ends


.subckt oneBitCompBuf A B C
    **  Inverters **
    XinvA0 A      A_inv  INV
    XinvA1 A_inv  A_inv2 INV msize=4

    XinvB0 B      B_inv  INV
    XinvB1 B_inv  B_inv2 INV msize=4

    XcompOut A_inv2 B_inv2 compOut oneBitComp

.ends

.subckt and2  A B Y
    **  D    G   S    X **
    **PMOS**
    Mp1 result A VDD VDD pmos_lvt m=1
    Mp2 result B VDD VDD pmos_lvt m=1

    **NMOS**
    Mn1 result A a   GND nmos_lvt m=1
    Mn2 a      B GND GND nmos_lvt m=1

    *inverter*
    Xinv0 result Y  INV msize=1

.ends

.subckt and64 c0 c1 c2 c3 c4 c5 c6 c7 c8 c9 c10 c11 c12 c13 c14 c15 c16 c17 c18 c19 c20 c21 c22 c23 c24 c25 c26 c27 c28 c29 c30 c31 c32 c33 c34 c35 c36 c37 c38 c39 c40 c41 c42 c43 c44 c45 c46 c47 c48 c49 c50 c51 c52 c53 c54 c55 c56 c57 c58 c59 c60 c61 c62 c63 out

**Stages:0**
Xand2_0_0 c0 c1 s_0_0 and2
Xand2_0_1 c2 c3 s_0_1 and2
Xand2_0_2 c4 c5 s_0_2 and2
Xand2_0_3 c6 c7 s_0_3 and2
Xand2_0_4 c8 c9 s_0_4 and2
Xand2_0_5 c10 c11 s_0_5 and2
Xand2_0_6 c12 c13 s_0_6 and2
Xand2_0_7 c14 c15 s_0_7 and2
Xand2_0_8 c16 c17 s_0_8 and2
Xand2_0_9 c18 c19 s_0_9 and2
Xand2_0_10 c20 c21 s_0_10 and2
Xand2_0_11 c22 c23 s_0_11 and2
Xand2_0_12 c24 c25 s_0_12 and2
Xand2_0_13 c26 c27 s_0_13 and2
Xand2_0_14 c28 c29 s_0_14 and2
Xand2_0_15 c30 c31 s_0_15 and2
Xand2_0_16 c32 c33 s_0_16 and2
Xand2_0_17 c34 c35 s_0_17 and2
Xand2_0_18 c36 c37 s_0_18 and2
Xand2_0_19 c38 c39 s_0_19 and2
Xand2_0_20 c40 c41 s_0_20 and2
Xand2_0_21 c42 c43 s_0_21 and2
Xand2_0_22 c44 c45 s_0_22 and2
Xand2_0_23 c46 c47 s_0_23 and2
Xand2_0_24 c48 c49 s_0_24 and2
Xand2_0_25 c50 c51 s_0_25 and2
Xand2_0_26 c52 c53 s_0_26 and2
Xand2_0_27 c54 c55 s_0_27 and2
Xand2_0_28 c56 c57 s_0_28 and2
Xand2_0_29 c58 c59 s_0_29 and2
Xand2_0_30 c60 c61 s_0_30 and2
Xand2_0_31 c62 c63 s_0_31 and2
**Stages:1**
Xand2_1_0 s_0_0 s_0_1 s_1_0 and2
Xand2_1_1 s_0_2 s_0_3 s_1_1 and2
Xand2_1_2 s_0_4 s_0_5 s_1_2 and2
Xand2_1_3 s_0_6 s_0_7 s_1_3 and2
Xand2_1_4 s_0_8 s_0_9 s_1_4 and2
Xand2_1_5 s_0_10 s_0_11 s_1_5 and2
Xand2_1_6 s_0_12 s_0_13 s_1_6 and2
Xand2_1_7 s_0_14 s_0_15 s_1_7 and2
Xand2_1_8 s_0_16 s_0_17 s_1_8 and2
Xand2_1_9 s_0_18 s_0_19 s_1_9 and2
Xand2_1_10 s_0_20 s_0_21 s_1_10 and2
Xand2_1_11 s_0_22 s_0_23 s_1_11 and2
Xand2_1_12 s_0_24 s_0_25 s_1_12 and2
Xand2_1_13 s_0_26 s_0_27 s_1_13 and2
Xand2_1_14 s_0_28 s_0_29 s_1_14 and2
Xand2_1_15 s_0_30 s_0_31 s_1_15 and2
**Stages:2**
Xand2_2_0 s_1_0 s_1_1 s_2_0 and2
Xand2_2_1 s_1_2 s_1_3 s_2_1 and2
Xand2_2_2 s_1_4 s_1_5 s_2_2 and2
Xand2_2_3 s_1_6 s_1_7 s_2_3 and2
Xand2_2_4 s_1_8 s_1_9 s_2_4 and2
Xand2_2_5 s_1_10 s_1_11 s_2_5 and2
Xand2_2_6 s_1_12 s_1_13 s_2_6 and2
Xand2_2_7 s_1_14 s_1_15 s_2_7 and2
**Stages:3**
Xand2_3_0 s_2_0 s_2_1 s_3_0 and2
Xand2_3_1 s_2_2 s_2_3 s_3_1 and2
Xand2_3_2 s_2_4 s_2_5 s_3_2 and2
Xand2_3_3 s_2_6 s_2_7 s_3_3 and2
**Stages:4**
Xand2_4_0 s_3_0 s_3_1 s_4_0 and2
Xand2_4_1 s_3_2 s_3_3 s_4_1 and2
**Stages:5**
Xand2_5_0 s_4_0 s_4_1 out and2

.ends


*****************************
**     Voltage Source      **
*****************************
.global VDD GND
Vvdd VDD GND 0.7v

*****************************
**      Your Circuit       **
*****************************
*** Parrallel buffered One bit comparators***
XoneBitCompBuf0 a0 b0 c0 oneBitCompBuf
XoneBitCompBuf1 a1 b1 c1 oneBitCompBuf
XoneBitCompBuf2 a2 b2 c2 oneBitCompBuf
XoneBitCompBuf3 a3 b3 c3 oneBitCompBuf
XoneBitCompBuf4 a4 b4 c4 oneBitCompBuf
XoneBitCompBuf5 a5 b5 c5 oneBitCompBuf
XoneBitCompBuf6 a6 b6 c6 oneBitCompBuf
XoneBitCompBuf7 a7 b7 c7 oneBitCompBuf
XoneBitCompBuf8 a8 b8 c8 oneBitCompBuf
XoneBitCompBuf9 a9 b9 c9 oneBitCompBuf
XoneBitCompBuf10 a10 b10 c10 oneBitCompBuf
XoneBitCompBuf11 a11 b11 c11 oneBitCompBuf
XoneBitCompBuf12 a12 b12 c12 oneBitCompBuf
XoneBitCompBuf13 a13 b13 c13 oneBitCompBuf
XoneBitCompBuf14 a14 b14 c14 oneBitCompBuf
XoneBitCompBuf15 a15 b15 c15 oneBitCompBuf
XoneBitCompBuf16 a16 b16 c16 oneBitCompBuf
XoneBitCompBuf17 a17 b17 c17 oneBitCompBuf
XoneBitCompBuf18 a18 b18 c18 oneBitCompBuf
XoneBitCompBuf19 a19 b19 c19 oneBitCompBuf
XoneBitCompBuf20 a20 b20 c20 oneBitCompBuf
XoneBitCompBuf21 a21 b21 c21 oneBitCompBuf
XoneBitCompBuf22 a22 b22 c22 oneBitCompBuf
XoneBitCompBuf23 a23 b23 c23 oneBitCompBuf
XoneBitCompBuf24 a24 b24 c24 oneBitCompBuf
XoneBitCompBuf25 a25 b25 c25 oneBitCompBuf
XoneBitCompBuf26 a26 b26 c26 oneBitCompBuf
XoneBitCompBuf27 a27 b27 c27 oneBitCompBuf
XoneBitCompBuf28 a28 b28 c28 oneBitCompBuf
XoneBitCompBuf29 a29 b29 c29 oneBitCompBuf
XoneBitCompBuf30 a30 b30 c30 oneBitCompBuf
XoneBitCompBuf31 a31 b31 c31 oneBitCompBuf
XoneBitCompBuf32 a32 b32 c32 oneBitCompBuf
XoneBitCompBuf33 a33 b33 c33 oneBitCompBuf
XoneBitCompBuf34 a34 b34 c34 oneBitCompBuf
XoneBitCompBuf35 a35 b35 c35 oneBitCompBuf
XoneBitCompBuf36 a36 b36 c36 oneBitCompBuf
XoneBitCompBuf37 a37 b37 c37 oneBitCompBuf
XoneBitCompBuf38 a38 b38 c38 oneBitCompBuf
XoneBitCompBuf39 a39 b39 c39 oneBitCompBuf
XoneBitCompBuf40 a40 b40 c40 oneBitCompBuf
XoneBitCompBuf41 a41 b41 c41 oneBitCompBuf
XoneBitCompBuf42 a42 b42 c42 oneBitCompBuf
XoneBitCompBuf43 a43 b43 c43 oneBitCompBuf
XoneBitCompBuf44 a44 b44 c44 oneBitCompBuf
XoneBitCompBuf45 a45 b45 c45 oneBitCompBuf
XoneBitCompBuf46 a46 b46 c46 oneBitCompBuf
XoneBitCompBuf47 a47 b47 c47 oneBitCompBuf
XoneBitCompBuf48 a48 b48 c48 oneBitCompBuf
XoneBitCompBuf49 a49 b49 c49 oneBitCompBuf
XoneBitCompBuf50 a50 b50 c50 oneBitCompBuf
XoneBitCompBuf51 a51 b51 c51 oneBitCompBuf
XoneBitCompBuf52 a52 b52 c52 oneBitCompBuf
XoneBitCompBuf53 a53 b53 c53 oneBitCompBuf
XoneBitCompBuf54 a54 b54 c54 oneBitCompBuf
XoneBitCompBuf55 a55 b55 c55 oneBitCompBuf
XoneBitCompBuf56 a56 b56 c56 oneBitCompBuf
XoneBitCompBuf57 a57 b57 c57 oneBitCompBuf
XoneBitCompBuf58 a58 b58 c58 oneBitCompBuf
XoneBitCompBuf59 a59 b59 c59 oneBitCompBuf
XoneBitCompBuf60 a60 b60 c60 oneBitCompBuf
XoneBitCompBuf61 a61 b61 c61 oneBitCompBuf
XoneBitCompBuf62 a62 b62 c62 oneBitCompBuf
XoneBitCompBuf63 a63 b63 c63 oneBitCompBuf


*** NOR64 ***
Xand64 c0 c1 c2 c3 c4 c5 c6 c7 c8 c9 c10 c11 c12 c13 c14 c15 c16 c17 c18 c19 c20 c21 c22 c23 c24 c25 c26 c27 c28 c29 c30 c31 c32 c33 c34 c35 c36 c37 c38 c39 c40 c41 c42 c43 c44 c45 c46 c47 c48 c49 c50 c51 c52 c53 c54 c55 c56 c57 c58 c59 c60 c61 c62 c63 out and64


*****************************
**  Transient Analysis     **
*****************************
.tran 0.1ns 80ns


*****************************
**    Simulator setting    **
*****************************
.option post
.options probe			*with I/V in .lis
.probe v(*) i(*)
.option captab			*with cap value in .lis

.TEMP 25


*****************************
**      Measurement        **
*****************************

.measure tphh_a0toOutput
    + TRIG v(a0)  VAL='0.35' RISE=2
    + TARG v(out) VAL='0.35' RISE=2

.measure TRAN Static_pwr avg POWER from=0.00n to=80.0n


.end
