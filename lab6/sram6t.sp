.TITLE Noise Margin in Hold/Read/Write Operation

*****************************
**     Library setting     **
*****************************
.protect
.include '7nm_TT.pm'
.unprotect

*****************************
**   Circuit Description   **
*****************************
    ** 6T SRAM cell**
    **     D    G   S   B **
    **Pull up PMOS**
    Mn1   q   GR  VDD VDD pmos_lvt m=1
    Mn2   qb  GL  VDD VDD pmos_lvt m=1

    **Pull Down NMOS**
    Mp1   q   GR  GND  GND nmos_lvt m=1
    Mp2   qb  GL  GND  GND nmos_lvt m=1

    ***Access NMOS***
    Mn3   q   WL  BL   GND nmos_lvt m=1
    Mn4   qb  WL  BLB  GND nmos_lvt m=1


******************************************
**     Voltage & Other Definitions      **
******************************************
.param  xvdd = 0.7v
.param  BITCAP=10E-14

.global VDD GND
Vvdd VDD GND xvdd

CBLB BLB GND BITCAP
CBL  BL  GND BITCAP

*** SNM(Static Noise Margin) Settings***
* HOLD *
*** .ic means initial condition ***

.ic V(BL)= 0.7v   * ?? need to be edited
.ic V(BLB)= 0.7v * ?? need to be edited
VWL  WL  GND  0.0v * ?? need to be edited

*** .nodeset is used to set DC voltage levels at specific circuit nodes in simulation ***
*** Ensuring circuit starts with specific initial condition ***
.nodeset V(q)= 0.7v  *?? need to be edited
.nodeset V(qb)= 0.0v * ?? need to be edited

* READ *
* .ic V(CBL.BL)= VDD * ?? need to be edited
* .ic V(CBLB.BLB)= VDD * ?? need to be edited
* VWL  WL  GND  VDD * ?? need to be edited
* .ic V(CBL.BL)= VDD * ?? need to be edited
* .ic V(CBLB.BLB)= VDD * ?? need to be edited
* VWL  WL  GND  VDD * ?? need to be edited

* .nodeset V(q)= VDD * ?? need to be edited
* .nodeset V(qb)= GND * ?? need to be edited
* .nodeset V(q)= VDD * ?? need to be edited
* .nodeset V(qb)= GND * ?? need to be edited

* WRITE *
* .ic V(CBL.BL)= GND * ?? need to be edited
* .ic V(CBLB.BLB)= VDD * ?? need to be edited
* VWL  WL  GND  VDD * ?? need to be edited
* .ic V(CBL.BL)= GND * ?? need to be edited
* .ic V(CBLB.BLB)= VDD * ?? need to be edited
* VWL  WL  GND  VDD * ?? need to be edited

* .nodeset V(q)= VDD * ?? need to be edited
* .nodeset V(qb)= GND * ?? need to be edited
* .nodeset V(q)= VDD * ?? need to be edited
* .nodeset V(qb)= GND * ?? need to be edited

*************************************
** Voltage control Voltage Source  **
*************************************
ELi gl GND VCVS POLY(2) v1 GND u GND 0 '1/sqrt(2)' '1/sqrt(2)'
Ev1 v1 GND VCVS POLY(2) qb GND u GND 0 'sqrt(2)'   1
ERi gr GND VCVS POLY(2) v2 GND u GND 0 '1/sqrt(2)' '-1/sqrt(2)'
Ev2 v2 GND VCVS POLY(2) q  GND u GND 0 'sqrt(2)'   -1

Vu u GND 0

*****************************
**       DC Analysis       **
*****************************
.op
.dc Vu '-1/sqrt(2)' '1/sqrt(2)' 0.0001
**.print V(qb)
**.print V(q)

*****************************
**    Simulator setting    **
*****************************
.option post
.options probe
.probe v(*) i(*)

.TEMP 25


*****************************
**      Measurement        **
*****************************
.measure dc max_1 max v(v1,v2)
.measure dc max_2 max v(v2,v1)

.measure dc SNML param='max(max_1,max_2)/sqrt(2)'
.measure dc SNMR param='min(max_1,max_2)/sqrt(2)'

.end
