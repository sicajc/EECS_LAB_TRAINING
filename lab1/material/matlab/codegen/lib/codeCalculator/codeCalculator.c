/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 * File: codeCalculator.c
 *
 * MATLAB Coder version            : 4.0
 * C/C++ source code generated on  : 05-Jul-2023 11:04:50
 */

/* Include Files */
#include <math.h>
#include "rt_nonfinite.h"
#include "codeCalculator.h"
#include "sort1.h"

/* Function Definitions */

/*
 * Arguments    : const signed char seq[6]
 *                double opt1
 *                double opt2
 *                double equ
 * Return Type  : short
 */
short codeCalculator(const signed char seq[6], double opt1, double opt2, double
                     equ)
{
  short out;
  int yfi;
  signed char iv0[6];
  signed char sorted_result[6];
  double cu_normalized[6];
  int i;
  int j;
  double temp_result;
  double v;

  /*  No matter signed or unsigned, we all uses the same datapath. */
  /*  sort, this would be implemented using bitonic sorters. */
  if (opt1 == 0.0) {
    for (yfi = 0; yfi < 6; yfi++) {
      iv0[yfi] = seq[yfi];
    }

    sort(iv0);
    for (yfi = 0; yfi < 6; yfi++) {
      sorted_result[yfi] = iv0[yfi];
    }
  } else {
    for (yfi = 0; yfi < 6; yfi++) {
      iv0[yfi] = seq[yfi];
    }

    b_sort(iv0);
    for (yfi = 0; yfi < 6; yfi++) {
      sorted_result[yfi] = iv0[yfi];
    }
  }

  /*  disp("Sorted Result"); */
  for (yfi = 0; yfi < 6; yfi++) {
    cu_normalized[yfi] = sorted_result[yfi];
  }

  /* Cumluation and Normalization */
  if (opt2 == 1.0) {
    for (i = 0; i < 6; i++) {
      if (1 + i == 1) {
        cu_normalized[i] = floor((double)(sorted_result[i] * 2 * 4 * 2 +
          sorted_result[i] * 8) * 0.125 / 3.0 * 8.0 * 0.125);
      } else {
        cu_normalized[i] = floor((cu_normalized[i - 1] * 2.0 * 8.0 + (double)
          sorted_result[i] * 8.0) * 0.125 / 3.0 * 8.0 * 0.125);
      }
    }
  } else {
    /*  Shift the first number to become 0, others must follows */
    if (sorted_result[0] > 0) {
      /*  -1 for all number until first number is 0 */
      for (i = 1; i <= sorted_result[0]; i++) {
        for (j = 0; j < 6; j++) {
          /*  disp("Cu normalized"); */
          cu_normalized[j]--;
        }
      }
    } else {
      /*  lt 0 */
      /*  +1 for all number until first number is 0 */
      yfi = -sorted_result[0];
      for (i = 1; i <= yfi; i++) {
        for (j = 0; j < 6; j++) {
          /*  disp("Cu normalized"); */
          cu_normalized[j]++;
        }
      }
    }
  }

  /*  disp("Cumulated and Normalized"); */
  /*  Output equation */
  if (equ == 0.0) {
    temp_result = floor((cu_normalized[3] * 4.0 + cu_normalized[4] * 4.0 * 4.0) *
                        0.25 * cu_normalized[5] * 4.0 * 0.25 / 3.0 * 4.0 * 0.25);
  } else {
    temp_result = cu_normalized[5] * (cu_normalized[1] - cu_normalized[0]);
    if (temp_result < 0.0) {
      temp_result = -temp_result;
    }
  }

  v = fabs(temp_result);
  if (v < 4.503599627370496E+15) {
    if (v >= 0.5) {
      temp_result = floor(temp_result + 0.5);
    } else {
      temp_result *= 0.0;
    }
  }

  if (temp_result < 512.0) {
    if (temp_result >= -512.0) {
      out = (short)temp_result;
    } else {
      out = -512;
    }
  } else if (temp_result >= 512.0) {
    out = 511;
  } else {
    out = 0;
  }

  return out;
}

/*
 * File trailer for codeCalculator.c
 *
 * [EOF]
 */
