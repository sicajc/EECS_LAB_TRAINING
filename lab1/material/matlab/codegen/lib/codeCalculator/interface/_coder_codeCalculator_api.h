/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 * File: _coder_codeCalculator_api.h
 *
 * MATLAB Coder version            : 4.0
 * C/C++ source code generated on  : 05-Jul-2023 11:35:02
 */

#ifndef _CODER_CODECALCULATOR_API_H
#define _CODER_CODECALCULATOR_API_H

/* Include Files */
#include "tmwtypes.h"
#include "mex.h"
#include "emlrt.h"
#include <stddef.h>
#include <stdlib.h>
#include "_coder_codeCalculator_api.h"

/* Variable Declarations */
extern emlrtCTX emlrtRootTLSGlobal;
extern emlrtContext emlrtContextGlobal;

/* Function Declarations */
extern int16_T codeCalculator(int8_T seq[6], real_T opt1, real_T opt2, real_T
  equ);
extern void codeCalculator_api(const mxArray * const prhs[5], int32_T nlhs,
  const mxArray *plhs[1]);
extern void codeCalculator_atexit(void);
extern void codeCalculator_initialize(void);
extern void codeCalculator_terminate(void);
extern void codeCalculator_xil_terminate(void);

#endif

/*
 * File trailer for _coder_codeCalculator_api.h
 *
 * [EOF]
 */
