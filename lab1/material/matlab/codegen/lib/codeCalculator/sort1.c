/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 * File: sort1.c
 *
 * MATLAB Coder version            : 4.0
 * C/C++ source code generated on  : 05-Jul-2023 04:02:40
 */

/* Include Files */
#include "rt_nonfinite.h"
#include "codeCalculator.h"
#include "sort1.h"
#include "sortIdx.h"

/* Function Definitions */

/*
 * Arguments    : signed char x[6]
 * Return Type  : void
 */
void b_sort(signed char x[6])
{
  int i1;
  signed char idx4[4];
  int idx[6];
  signed char x4[4];
  int i2;
  int i3;
  int i4;
  signed char perm[4];
  int iwork[6];
  signed char xwork[6];
  for (i1 = 0; i1 < 6; i1++) {
    idx[i1] = 0;
  }

  idx4[0] = 1;
  idx4[1] = 2;
  idx4[2] = 3;
  idx4[3] = 4;
  x4[0] = x[0];
  x4[1] = x[1];
  x4[2] = x[2];
  x4[3] = x[3];
  if (x[0] >= x[1]) {
    i1 = 1;
    i2 = 2;
  } else {
    i1 = 2;
    i2 = 1;
  }

  if (x[2] >= x[3]) {
    i3 = 3;
    i4 = 4;
  } else {
    i3 = 4;
    i4 = 3;
  }

  if (x4[i1 - 1] >= x4[i3 - 1]) {
    if (x4[i2 - 1] >= x4[i3 - 1]) {
      perm[0] = (signed char)i1;
      perm[1] = (signed char)i2;
      perm[2] = (signed char)i3;
      perm[3] = (signed char)i4;
    } else if (x4[i2 - 1] >= x4[i4 - 1]) {
      perm[0] = (signed char)i1;
      perm[1] = (signed char)i3;
      perm[2] = (signed char)i2;
      perm[3] = (signed char)i4;
    } else {
      perm[0] = (signed char)i1;
      perm[1] = (signed char)i3;
      perm[2] = (signed char)i4;
      perm[3] = (signed char)i2;
    }
  } else if (x4[i1 - 1] >= x4[i4 - 1]) {
    if (x4[i2 - 1] >= x4[i4 - 1]) {
      perm[0] = (signed char)i3;
      perm[1] = (signed char)i1;
      perm[2] = (signed char)i2;
      perm[3] = (signed char)i4;
    } else {
      perm[0] = (signed char)i3;
      perm[1] = (signed char)i1;
      perm[2] = (signed char)i4;
      perm[3] = (signed char)i2;
    }
  } else {
    perm[0] = (signed char)i3;
    perm[1] = (signed char)i4;
    perm[2] = (signed char)i1;
    perm[3] = (signed char)i2;
  }

  idx[0] = idx4[perm[0] - 1];
  idx[1] = idx4[perm[1] - 1];
  idx[2] = idx4[perm[2] - 1];
  idx[3] = idx4[perm[3] - 1];
  x[0] = x4[perm[0] - 1];
  x[1] = x4[perm[1] - 1];
  x[2] = x4[perm[2] - 1];
  x[3] = x4[perm[3] - 1];
  for (i1 = 0; i1 < 2; i1++) {
    idx4[i1] = (signed char)(5 + i1);
    x4[i1] = x[i1 + 4];
  }

  for (i1 = 0; i1 < 4; i1++) {
    perm[i1] = 0;
  }

  if (x4[0] >= x4[1]) {
    perm[0] = 1;
    perm[1] = 2;
  } else {
    perm[0] = 2;
    perm[1] = 1;
  }

  for (i1 = 0; i1 < 2; i1++) {
    idx[i1 + 4] = idx4[perm[i1] - 1];
    x[i1 + 4] = x4[perm[i1] - 1];
  }

  for (i1 = 0; i1 < 6; i1++) {
    xwork[i1] = 0;
    iwork[i1] = 0;
  }

  b_merge(idx, x, 0, 4, 2, iwork, xwork);
}

/*
 * Arguments    : signed char x[6]
 * Return Type  : void
 */
void sort(signed char x[6])
{
  int i1;
  signed char idx4[4];
  int idx[6];
  signed char x4[4];
  int i2;
  int i3;
  int i4;
  signed char perm[4];
  int iwork[6];
  signed char xwork[6];
  for (i1 = 0; i1 < 6; i1++) {
    idx[i1] = 0;
  }

  idx4[0] = 1;
  idx4[1] = 2;
  idx4[2] = 3;
  idx4[3] = 4;
  x4[0] = x[0];
  x4[1] = x[1];
  x4[2] = x[2];
  x4[3] = x[3];
  if (x[0] <= x[1]) {
    i1 = 1;
    i2 = 2;
  } else {
    i1 = 2;
    i2 = 1;
  }

  if (x[2] <= x[3]) {
    i3 = 3;
    i4 = 4;
  } else {
    i3 = 4;
    i4 = 3;
  }

  if (x4[i1 - 1] <= x4[i3 - 1]) {
    if (x4[i2 - 1] <= x4[i3 - 1]) {
      perm[0] = (signed char)i1;
      perm[1] = (signed char)i2;
      perm[2] = (signed char)i3;
      perm[3] = (signed char)i4;
    } else if (x4[i2 - 1] <= x4[i4 - 1]) {
      perm[0] = (signed char)i1;
      perm[1] = (signed char)i3;
      perm[2] = (signed char)i2;
      perm[3] = (signed char)i4;
    } else {
      perm[0] = (signed char)i1;
      perm[1] = (signed char)i3;
      perm[2] = (signed char)i4;
      perm[3] = (signed char)i2;
    }
  } else if (x4[i1 - 1] <= x4[i4 - 1]) {
    if (x4[i2 - 1] <= x4[i4 - 1]) {
      perm[0] = (signed char)i3;
      perm[1] = (signed char)i1;
      perm[2] = (signed char)i2;
      perm[3] = (signed char)i4;
    } else {
      perm[0] = (signed char)i3;
      perm[1] = (signed char)i1;
      perm[2] = (signed char)i4;
      perm[3] = (signed char)i2;
    }
  } else {
    perm[0] = (signed char)i3;
    perm[1] = (signed char)i4;
    perm[2] = (signed char)i1;
    perm[3] = (signed char)i2;
  }

  idx[0] = idx4[perm[0] - 1];
  idx[1] = idx4[perm[1] - 1];
  idx[2] = idx4[perm[2] - 1];
  idx[3] = idx4[perm[3] - 1];
  x[0] = x4[perm[0] - 1];
  x[1] = x4[perm[1] - 1];
  x[2] = x4[perm[2] - 1];
  x[3] = x4[perm[3] - 1];
  for (i1 = 0; i1 < 2; i1++) {
    idx4[i1] = (signed char)(5 + i1);
    x4[i1] = x[i1 + 4];
  }

  for (i1 = 0; i1 < 4; i1++) {
    perm[i1] = 0;
  }

  if (x4[0] <= x4[1]) {
    perm[0] = 1;
    perm[1] = 2;
  } else {
    perm[0] = 2;
    perm[1] = 1;
  }

  for (i1 = 0; i1 < 2; i1++) {
    idx[i1 + 4] = idx4[perm[i1] - 1];
    x[i1 + 4] = x4[perm[i1] - 1];
  }

  for (i1 = 0; i1 < 6; i1++) {
    xwork[i1] = 0;
    iwork[i1] = 0;
  }

  merge(idx, x, 0, 4, 2, iwork, xwork);
}

/*
 * File trailer for sort1.c
 *
 * [EOF]
 */
