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
.subckt inverter in out
    **  D    G   S    X **
    Mp  out  in  VDD  x  pmos_lvt  m=1
    Mn  out  in  GND  x  nmos_lvt  m=1
.ends


.subckt oneBitComp A B C
    **  D    G   S    X **
    **  Inverters **
    Ainv1 A A_inv inverter
    Binv1 B B_inv inverter

    **  PMOS **
    Mp1  a      A_inv  VDD  x  pmos_lvt  m=1
    Mp2  C      A      a    x  pmos_lvt  m=1
    Mp3  a      B_inv  VDD  x  pmos_lvt  m=1
    Mp4  C      B      a    x  pmos_lvt  m=1

    **  NMOS **
    Mn1  C      A      b      x  nmos_lvt  m=1
    Mn2  b      B      GND    x  nmos_lvt  m=1
    Mn3  C      A_inv  d      x  nmos_lvt  m=1
    Mn4  d      B_inv  GND    x  nmos_lvt  m=1
.ends


.subckt oneBitCompBuf A B C
    **  Inverters **
    Ainv1 A     A_inv  inverter
    Ainv2 A_inv A_inv2 inverter
    Binv1 B     B_inv  inverter
    Binv2 B     B_inv2 inverter

    CcompOut A_inv2 B_inv2 C oneBitComp
.ends


.subckt nor64 c0 c1 c2 c3 c4 c5 c6 c7 c8 c9 c10 c11 c12 c13 c14 c15 c16 c17 c18 c19 c20 c21 c22 c23 c24 c25 c26 c27 c28 c29 c30 c31 c32 c33 c34 c35 c36 c37 c38 c39 c40 c41 c42 c43 c44 c45 c46 c47 c48 c49 c50 c51 c52 c53 c54 c55 c56 c57 c58 c59 c60 c61 c62 c63 result
    **  PMOS **
    Mp0   n0   c0  VDD   x pmos_lvt  m=1
    Mp1   n1   c1  n0 x pmos_lvt  m=1
    Mp2   n2   c2  n1 x pmos_lvt  m=1
    Mp3   n3   c3  n2 x pmos_lvt  m=1
    Mp4   n4   c4  n3 x pmos_lvt  m=1
    Mp5   n5   c5  n4 x pmos_lvt  m=1
    Mp6   n6   c6  n5 x pmos_lvt  m=1
    Mp7   n7   c7  n6 x pmos_lvt  m=1
    Mp8   n8   c8  n7 x pmos_lvt  m=1
    Mp9   n9   c9  n8 x pmos_lvt  m=1
    Mp10  n10  c10 n9 x pmos_lvt  m=1
    Mp11  n11  c11 n10 x pmos_lvt  m=1
    Mp12  n12  c12 n11 x pmos_lvt  m=1
    Mp13  n13  c13 n12 x pmos_lvt  m=1
    Mp14  n14  c14 n13 x pmos_lvt  m=1
    Mp15  n15  c15 n14 x pmos_lvt  m=1
    Mp16  n16  c16 n15 x pmos_lvt  m=1
    Mp17  n17  c17 n16 x pmos_lvt  m=1
    Mp18  n18  c18 n17 x pmos_lvt  m=1
    Mp19  n19  c19 n18 x pmos_lvt  m=1
    Mp20  n20  c20 n19 x pmos_lvt  m=1
    Mp21  n21  c21 n20 x pmos_lvt  m=1
    Mp22  n22  c22 n21 x pmos_lvt  m=1
    Mp23  n23  c23 n22 x pmos_lvt  m=1
    Mp24  n24  c24 n23 x pmos_lvt  m=1
    Mp25  n25  c25 n24 x pmos_lvt  m=1
    Mp26  n26  c26 n25 x pmos_lvt  m=1
    Mp27  n27  c27 n26 x pmos_lvt  m=1
    Mp28  n28  c28 n27 x pmos_lvt  m=1
    Mp29  n29  c29 n28 x pmos_lvt  m=1
    Mp30  n30  c30 n29 x pmos_lvt  m=1
    Mp31  n31  c31 n30 x pmos_lvt  m=1
    Mp32  n32  c32 n31 x pmos_lvt  m=1
    Mp33  n33  c33 n32 x pmos_lvt  m=1
    Mp34  n34  c34 n33 x pmos_lvt  m=1
    Mp35  n35  c35 n34 x pmos_lvt  m=1
    Mp36  n36  c36 n35 x pmos_lvt  m=1
    Mp37  n37  c37 n36 x pmos_lvt  m=1
    Mp38  n38  c38 n37 x pmos_lvt  m=1
    Mp39  n39  c39 n38 x pmos_lvt  m=1
    Mp40  n40  c40 n39 x pmos_lvt  m=1
    Mp41  n41  c41 n40 x pmos_lvt  m=1
    Mp42  n42  c42 n41 x pmos_lvt  m=1
    Mp43  n43  c43 n42 x pmos_lvt  m=1
    Mp44  n44  c44 n43 x pmos_lvt  m=1
    Mp45  n45  c45 n44 x pmos_lvt  m=1
    Mp46  n46  c46 n45 x pmos_lvt  m=1
    Mp47  n47  c47 n46 x pmos_lvt  m=1
    Mp48  n48  c48 n47 x pmos_lvt  m=1
    Mp49  n49  c49 n48 x pmos_lvt  m=1
    Mp50  n50  c50 n49 x pmos_lvt  m=1
    Mp51  n51  c51 n50 x pmos_lvt  m=1
    Mp52  n52  c52 n51 x pmos_lvt  m=1
    Mp53  n53  c53 n52 x pmos_lvt  m=1
    Mp54  n54  c54 n53 x pmos_lvt  m=1
    Mp55  n55  c55 n54 x pmos_lvt  m=1
    Mp56  n56  c56 n55 x pmos_lvt  m=1
    Mp57  n57  c57 n56 x pmos_lvt  m=1
    Mp58  n58  c58 n57 x pmos_lvt  m=1
    Mp59  n59  c59 n58 x pmos_lvt  m=1
    Mp60  n60  c60 n59 x pmos_lvt  m=1
    Mp61  n61  c61 n60 x pmos_lvt  m=1
    Mp62  n62  c62 n61 x pmos_lvt  m=1
    Mp63 result c63 n62 x pmos_lvt  m=1

    **  NMOS **
    Mn0 result c0 GND x nmos_lvt  m=1
    Mn1 result c1 GND x nmos_lvt  m=1
    Mn2 result c2 GND x nmos_lvt  m=1
    Mn3 result c3 GND x nmos_lvt  m=1
    Mn4 result c4 GND x nmos_lvt  m=1
    Mn5 result c5 GND x nmos_lvt  m=1
    Mn6 result c6 GND x nmos_lvt  m=1
    Mn7 result c7 GND x nmos_lvt  m=1
    Mn8 result c8 GND x nmos_lvt  m=1
    Mn9 result c9 GND x nmos_lvt  m=1
    Mn10 result c10 GND x nmos_lvt  m=1
    Mn11 result c11 GND x nmos_lvt  m=1
    Mn12 result c12 GND x nmos_lvt  m=1
    Mn13 result c13 GND x nmos_lvt  m=1
    Mn14 result c14 GND x nmos_lvt  m=1
    Mn15 result c15 GND x nmos_lvt  m=1
    Mn16 result c16 GND x nmos_lvt  m=1
    Mn17 result c17 GND x nmos_lvt  m=1
    Mn18 result c18 GND x nmos_lvt  m=1
    Mn19 result c19 GND x nmos_lvt  m=1
    Mn20 result c20 GND x nmos_lvt  m=1
    Mn21 result c21 GND x nmos_lvt  m=1
    Mn22 result c22 GND x nmos_lvt  m=1
    Mn23 result c23 GND x nmos_lvt  m=1
    Mn24 result c24 GND x nmos_lvt  m=1
    Mn25 result c25 GND x nmos_lvt  m=1
    Mn26 result c26 GND x nmos_lvt  m=1
    Mn27 result c27 GND x nmos_lvt  m=1
    Mn28 result c28 GND x nmos_lvt  m=1
    Mn29 result c29 GND x nmos_lvt  m=1
    Mn30 result c30 GND x nmos_lvt  m=1
    Mn31 result c31 GND x nmos_lvt  m=1
    Mn32 result c32 GND x nmos_lvt  m=1
    Mn33 result c33 GND x nmos_lvt  m=1
    Mn34 result c34 GND x nmos_lvt  m=1
    Mn35 result c35 GND x nmos_lvt  m=1
    Mn36 result c36 GND x nmos_lvt  m=1
    Mn37 result c37 GND x nmos_lvt  m=1
    Mn38 result c38 GND x nmos_lvt  m=1
    Mn39 result c39 GND x nmos_lvt  m=1
    Mn40 result c40 GND x nmos_lvt  m=1
    Mn41 result c41 GND x nmos_lvt  m=1
    Mn42 result c42 GND x nmos_lvt  m=1
    Mn43 result c43 GND x nmos_lvt  m=1
    Mn44 result c44 GND x nmos_lvt  m=1
    Mn45 result c45 GND x nmos_lvt  m=1
    Mn46 result c46 GND x nmos_lvt  m=1
    Mn47 result c47 GND x nmos_lvt  m=1
    Mn48 result c48 GND x nmos_lvt  m=1
    Mn49 result c49 GND x nmos_lvt  m=1
    Mn50 result c50 GND x nmos_lvt  m=1
    Mn51 result c51 GND x nmos_lvt  m=1
    Mn52 result c52 GND x nmos_lvt  m=1
    Mn53 result c53 GND x nmos_lvt  m=1
    Mn54 result c54 GND x nmos_lvt  m=1
    Mn55 result c55 GND x nmos_lvt  m=1
    Mn56 result c56 GND x nmos_lvt  m=1
    Mn57 result c57 GND x nmos_lvt  m=1
    Mn58 result c58 GND x nmos_lvt  m=1
    Mn59 result c59 GND x nmos_lvt  m=1
    Mn60 result c60 GND x nmos_lvt  m=1
    Mn61 result c61 GND x nmos_lvt  m=1
    Mn62 result c62 GND x nmos_lvt  m=1
    Mn63 result c63 GND x nmos_lvt  m=1
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
Xnor64 c0 c1 c2 c3 c4 c5 c6 c7 c8 c9 c10 c11 c12 c13 c14 c15 c16 c17 c18 c19 c20 c21 c22 c23 c24 c25 c26 c27 c28 c29 c30 c31 c32 c33 c34 c35 c36 c37 c38 c39 c40 c41 c42 c43 c44 c45 c46 c47 c48 c49 c50 c51 c52 c53 c54 c55 c56 c57 c58 c59 c60 c61 c62 c63 out

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
***.measure tphh_a0toOutput * rising prop delay
***+ TRIG v(a0) VAL='0.35' RISE=2
***+ TARG v(out_and0to31) VAL='0.35' RISE=2
***
***.measure TRAN Static_pwr  avg POWER from=20.03n to=24.9n


.end
