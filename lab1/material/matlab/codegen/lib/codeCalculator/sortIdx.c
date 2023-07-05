/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 * File: sortIdx.c
 *
 * MATLAB Coder version            : 4.0
 * C/C++ source code generated on  : 05-Jul-2023 11:04:50
 */

/* Include Files */
#include "rt_nonfinite.h"
#include "codeCalculator.h"
#include "sortIdx.h"

/* Function Definitions */

/*
 * Arguments    : int idx[6]
 *                signed char x[6]
 *                int offset
 *                int np
 *                int nq
 *                int iwork[6]
 *                signed char xwork[6]
 * Return Type  : void
 */
void b_merge(int idx[6], signed char x[6], int offset, int np, int nq, int
             iwork[6], signed char xwork[6])
{
  int n;
  int qend;
  int p;
  int iout;
  int exitg1;
  if ((np == 0) || (nq == 0)) {
  } else {
    n = np + nq;
    for (qend = 0; qend < n; qend++) {
      iwork[qend] = idx[offset + qend];
      xwork[qend] = x[offset + qend];
    }

    p = 0;
    n = np;
    qend = np + nq;
    iout = offset - 1;
    do {
      exitg1 = 0;
      iout++;
      if (xwork[p] >= xwork[n]) {
        idx[iout] = iwork[p];
        x[iout] = xwork[p];
        if (p + 1 < np) {
          p++;
        } else {
          exitg1 = 1;
        }
      } else {
        idx[iout] = iwork[n];
        x[iout] = xwork[n];
        if (n + 1 < qend) {
          n++;
        } else {
          n = iout - p;
          while (p + 1 <= np) {
            idx[(n + p) + 1] = iwork[p];
            x[(n + p) + 1] = xwork[p];
            p++;
          }

          exitg1 = 1;
        }
      }
    } while (exitg1 == 0);
  }
}

/*
 * Arguments    : int idx[6]
 *                signed char x[6]
 *                int offset
 *                int np
 *                int nq
 *                int iwork[6]
 *                signed char xwork[6]
 * Return Type  : void
 */
void merge(int idx[6], signed char x[6], int offset, int np, int nq, int iwork[6],
           signed char xwork[6])
{
  int n;
  int qend;
  int p;
  int iout;
  int exitg1;
  if ((np == 0) || (nq == 0)) {
  } else {
    n = np + nq;
    for (qend = 0; qend < n; qend++) {
      iwork[qend] = idx[offset + qend];
      xwork[qend] = x[offset + qend];
    }

    p = 0;
    n = np;
    qend = np + nq;
    iout = offset - 1;
    do {
      exitg1 = 0;
      iout++;
      if (xwork[p] <= xwork[n]) {
        idx[iout] = iwork[p];
        x[iout] = xwork[p];
        if (p + 1 < np) {
          p++;
        } else {
          exitg1 = 1;
        }
      } else {
        idx[iout] = iwork[n];
        x[iout] = xwork[n];
        if (n + 1 < qend) {
          n++;
        } else {
          n = iout - p;
          while (p + 1 <= np) {
            idx[(n + p) + 1] = iwork[p];
            x[(n + p) + 1] = xwork[p];
            p++;
          }

          exitg1 = 1;
        }
      }
    } while (exitg1 == 0);
  }
}

/*
 * File trailer for sortIdx.c
 *
 * [EOF]
 */
