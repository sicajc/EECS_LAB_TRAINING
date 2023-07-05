/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 * File: sortIdx.h
 *
 * MATLAB Coder version            : 4.0
 * C/C++ source code generated on  : 05-Jul-2023 04:02:40
 */

#ifndef SORTIDX_H
#define SORTIDX_H

/* Include Files */
#include <stddef.h>
#include <stdlib.h>
#include "rtwtypes.h"
#include "codeCalculator_types.h"

/* Function Declarations */
extern void b_merge(int idx[6], signed char x[6], int offset, int np, int nq,
                    int iwork[6], signed char xwork[6]);
extern void merge(int idx[6], signed char x[6], int offset, int np, int nq, int
                  iwork[6], signed char xwork[6]);

#endif

/*
 * File trailer for sortIdx.h
 *
 * [EOF]
 */
