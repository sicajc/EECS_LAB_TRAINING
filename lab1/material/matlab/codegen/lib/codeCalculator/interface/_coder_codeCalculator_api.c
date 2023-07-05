/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 * File: _coder_codeCalculator_api.c
 *
 * MATLAB Coder version            : 4.0
 * C/C++ source code generated on  : 05-Jul-2023 04:02:40
 */

/* Include Files */
#include "tmwtypes.h"
#include "_coder_codeCalculator_api.h"
#include "_coder_codeCalculator_mex.h"

/* Variable Definitions */
emlrtCTX emlrtRootTLSGlobal = NULL;
static const mxArray *eml_mx;
static const mxArray *b_eml_mx;
static const mxArray *c_eml_mx;
static const mxArray *d_eml_mx;
static const mxArray *e_eml_mx;
emlrtContext emlrtContextGlobal = { true,/* bFirstTime */
  false,                               /* bInitialized */
  131466U,                             /* fVersionInfo */
  NULL,                                /* fErrorFunction */
  "codeCalculator",                    /* fFunctionName */
  NULL,                                /* fRTCallStack */
  false,                               /* bDebugMode */
  { 2045744189U, 2170104910U, 2743257031U, 4284093946U },/* fSigWrd */
  NULL                                 /* fSigMem */
};

static emlrtMCInfo emlrtMCI = { -1,    /* lineNo */
  -1,                                  /* colNo */
  "",                                  /* fName */
  ""                                   /* pName */
};

/* Function Declarations */
static void b_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u, const
  emlrtMsgIdentifier *parentId, int8_T y[6]);
static const mxArray *b_numerictype(const emlrtStack *sp, const char * b, const
  char * c, const char * d, const char * e, const char * f, real_T g, const char
  * h, real_T i, const char * j, real_T k, const char * l, real_T m, const char *
  n, real_T o, emlrtMCInfo *location);
static real_T c_emlrt_marshallIn(const emlrtStack *sp, const mxArray *opt1,
  const char_T *identifier);
static void codeCalculator_once(const emlrtStack *sp);
static real_T d_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u, const
  emlrtMsgIdentifier *parentId);
static void e_emlrt_marshallIn(const emlrtStack *sp, const mxArray *T, const
  char_T *identifier);
static void emlrt_marshallIn(const emlrtStack *sp, const mxArray *seq, const
  char_T *identifier, int8_T y[6]);
static const mxArray *emlrt_marshallOut(const emlrtStack *sp, const int16_T u);
static void f_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u, const
  emlrtMsgIdentifier *parentId);
static const mxArray *fimath(const emlrtStack *sp, const char * b, const char
  * c, const char * d, const char * e, const char * f, const char * g, const
  char * h, const char * i, const char * j, const char * k, const char * l,
  const char * m, const char * n, real_T o, const char * p, real_T q, const char
  * r, real_T s, const char * t, real_T u, const char * v, real_T w, const char *
  x, real_T y, const char * ab, real_T bb, const char * cb, real_T db, const
  char * eb, real_T fb, const char * gb, real_T hb, const char * ib, real_T jb,
  const char * kb, real_T lb, const char * mb, boolean_T nb, const char * ob,
  real_T pb, const char * qb, real_T rb, emlrtMCInfo *location);
static void g_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u, const
  emlrtMsgIdentifier *parentId);
static void h_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u, const
  emlrtMsgIdentifier *parentId);
static void i_emlrt_marshallIn(const mxArray *src, int8_T ret[6]);
static real_T j_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src, const
  emlrtMsgIdentifier *msgId);
static void k_emlrt_marshallIn(const mxArray *src);
static void l_emlrt_marshallIn(const mxArray *src);
static const mxArray *numerictype(const emlrtStack *sp, const char * b, real_T c,
  const char * d, real_T e, const char * f, real_T g, const char * h, real_T i,
  const char * j, real_T k, emlrtMCInfo *location);

/* Function Definitions */

/*
 * Arguments    : const emlrtStack *sp
 *                const mxArray *u
 *                const emlrtMsgIdentifier *parentId
 *                int8_T y[6]
 * Return Type  : void
 */
static void b_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u, const
  emlrtMsgIdentifier *parentId, int8_T y[6])
{
  static const int32_T dims[2] = { 1, 6 };

  emlrtCheckFiR2012b(sp, parentId, u, false, 2U, dims, eml_mx, b_eml_mx);
  i_emlrt_marshallIn(emlrtAlias(u), y);
  emlrtDestroyArray(&u);
}

/*
 * Arguments    : const emlrtStack *sp
 *                const char * b
 *                const char * c
 *                const char * d
 *                const char * e
 *                const char * f
 *                real_T g
 *                const char * h
 *                real_T i
 *                const char * j
 *                real_T k
 *                const char * l
 *                real_T m
 *                const char * n
 *                real_T o
 *                emlrtMCInfo *location
 * Return Type  : const mxArray *
 */
static const mxArray *b_numerictype(const emlrtStack *sp, const char * b, const
  char * c, const char * d, const char * e, const char * f, real_T g, const char
  * h, real_T i, const char * j, real_T k, const char * l, real_T m, const char *
  n, real_T o, emlrtMCInfo *location)
{
  const mxArray *pArrays[14];
  const mxArray *m2;
  pArrays[0] = emlrtCreateString(b);
  pArrays[1] = emlrtCreateString(c);
  pArrays[2] = emlrtCreateString(d);
  pArrays[3] = emlrtCreateString(e);
  pArrays[4] = emlrtCreateString(f);
  pArrays[5] = emlrtCreateDoubleScalar(g);
  pArrays[6] = emlrtCreateString(h);
  pArrays[7] = emlrtCreateDoubleScalar(i);
  pArrays[8] = emlrtCreateString(j);
  pArrays[9] = emlrtCreateDoubleScalar(k);
  pArrays[10] = emlrtCreateString(l);
  pArrays[11] = emlrtCreateDoubleScalar(m);
  pArrays[12] = emlrtCreateString(n);
  pArrays[13] = emlrtCreateDoubleScalar(o);
  return emlrtCallMATLABR2012b(sp, 1, &m2, 14, pArrays, "numerictype", true,
    location);
}

/*
 * Arguments    : const emlrtStack *sp
 *                const mxArray *opt1
 *                const char_T *identifier
 * Return Type  : real_T
 */
static real_T c_emlrt_marshallIn(const emlrtStack *sp, const mxArray *opt1,
  const char_T *identifier)
{
  real_T y;
  emlrtMsgIdentifier thisId;
  thisId.fIdentifier = (const char *)identifier;
  thisId.fParent = NULL;
  thisId.bParentIsCell = false;
  y = d_emlrt_marshallIn(sp, emlrtAlias(opt1), &thisId);
  emlrtDestroyArray(&opt1);
  return y;
}

/*
 * Arguments    : const emlrtStack *sp
 * Return Type  : void
 */
static void codeCalculator_once(const emlrtStack *sp)
{
  emlrtAssignP(&e_eml_mx, NULL);
  emlrtAssignP(&d_eml_mx, NULL);
  emlrtAssignP(&c_eml_mx, NULL);
  emlrtAssignP(&b_eml_mx, NULL);
  emlrtAssignP(&eml_mx, NULL);
  emlrtAssignP(&e_eml_mx, numerictype(sp, "WordLength", 10.0, "FractionLength",
    0.0, "BinaryPoint", 0.0, "Slope", 1.0, "FixedExponent", 0.0, &emlrtMCI));
  emlrtAssignP(&d_eml_mx, b_numerictype(sp, "DataTypeMode",
    "Scaled double: binary point scaling", "DataType", "ScaledDouble",
    "WordLength", 10.0, "FractionLength", 0.0, "BinaryPoint", 0.0, "Slope", 1.0,
    "FixedExponent", 0.0, &emlrtMCI));
  emlrtAssignP(&c_eml_mx, b_numerictype(sp, "DataTypeMode",
    "Scaled double: binary point scaling", "DataType", "ScaledDouble",
    "WordLength", 5.0, "FractionLength", 0.0, "BinaryPoint", 0.0, "Slope", 1.0,
    "FixedExponent", 0.0, &emlrtMCI));
  emlrtAssignP(&b_eml_mx, numerictype(sp, "WordLength", 5.0, "FractionLength",
    0.0, "BinaryPoint", 0.0, "Slope", 1.0, "FixedExponent", 0.0, &emlrtMCI));
  emlrtAssignP(&eml_mx, fimath(sp, "RoundMode", "nearest", "RoundingMethod",
    "Nearest", "OverflowMode", "saturate", "OverflowAction", "Saturate",
    "ProductMode", "FullPrecision", "SumMode", "FullPrecision",
    "ProductWordLength", 32.0, "SumWordLength", 32.0, "MaxProductWordLength",
    65535.0, "MaxSumWordLength", 65535.0, "ProductFractionLength", 30.0,
    "ProductFixedExponent", -30.0, "SumFractionLength", 30.0, "SumFixedExponent",
    -30.0, "SumSlopeAdjustmentFactor", 1.0, "SumBias", 0.0,
    "ProductSlopeAdjustmentFactor", 1.0, "ProductBias", 0.0, "CastBeforeSum",
    true, "SumSlope", 9.3132257461547852E-10, "ProductSlope",
    9.3132257461547852E-10, &emlrtMCI));
  emlrtCheckDefaultFimathR2008b(&eml_mx);
}

/*
 * Arguments    : const emlrtStack *sp
 *                const mxArray *u
 *                const emlrtMsgIdentifier *parentId
 * Return Type  : real_T
 */
static real_T d_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u, const
  emlrtMsgIdentifier *parentId)
{
  real_T y;
  y = j_emlrt_marshallIn(sp, emlrtAlias(u), parentId);
  emlrtDestroyArray(&u);
  return y;
}

/*
 * Arguments    : const emlrtStack *sp
 *                const mxArray *T
 *                const char_T *identifier
 * Return Type  : void
 */
static void e_emlrt_marshallIn(const emlrtStack *sp, const mxArray *T, const
  char_T *identifier)
{
  emlrtMsgIdentifier thisId;
  thisId.fIdentifier = (const char *)identifier;
  thisId.fParent = NULL;
  thisId.bParentIsCell = false;
  f_emlrt_marshallIn(sp, emlrtAlias(T), &thisId);
  emlrtDestroyArray(&T);
}

/*
 * Arguments    : const emlrtStack *sp
 *                const mxArray *seq
 *                const char_T *identifier
 *                int8_T y[6]
 * Return Type  : void
 */
static void emlrt_marshallIn(const emlrtStack *sp, const mxArray *seq, const
  char_T *identifier, int8_T y[6])
{
  emlrtMsgIdentifier thisId;
  thisId.fIdentifier = (const char *)identifier;
  thisId.fParent = NULL;
  thisId.bParentIsCell = false;
  b_emlrt_marshallIn(sp, emlrtAlias(seq), &thisId, y);
  emlrtDestroyArray(&seq);
}

/*
 * Arguments    : const emlrtStack *sp
 *                const int16_T u
 * Return Type  : const mxArray *
 */
static const mxArray *emlrt_marshallOut(const emlrtStack *sp, const int16_T u)
{
  const mxArray *y;
  const mxArray *b_y;
  const mxArray *m0;
  y = NULL;
  b_y = NULL;
  m0 = emlrtCreateNumericMatrix(1, 1, mxINT16_CLASS, mxREAL);
  *(int16_T *)emlrtMxGetData(m0) = u;
  emlrtAssign(&b_y, m0);
  emlrtAssign(&y, emlrtCreateFIR2013b(sp, eml_mx, e_eml_mx, "simulinkarray", b_y,
    false, false));
  return y;
}

/*
 * Arguments    : const emlrtStack *sp
 *                const mxArray *u
 *                const emlrtMsgIdentifier *parentId
 * Return Type  : void
 */
static void f_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u, const
  emlrtMsgIdentifier *parentId)
{
  emlrtMsgIdentifier thisId;
  static const char * fieldNames[3] = { "sort_WL", "normalize_WL", "result_WL" };

  static const int32_T dims = 0;
  thisId.fParent = parentId;
  thisId.bParentIsCell = false;
  emlrtCheckStructR2012b(sp, parentId, u, 3, fieldNames, 0U, &dims);
  thisId.fIdentifier = "sort_WL";
  g_emlrt_marshallIn(sp, emlrtAlias(emlrtGetFieldR2017b(sp, u, 0, 0, "sort_WL")),
                     &thisId);
  thisId.fIdentifier = "normalize_WL";
  g_emlrt_marshallIn(sp, emlrtAlias(emlrtGetFieldR2017b(sp, u, 0, 1,
    "normalize_WL")), &thisId);
  thisId.fIdentifier = "result_WL";
  h_emlrt_marshallIn(sp, emlrtAlias(emlrtGetFieldR2017b(sp, u, 0, 2, "result_WL")),
                     &thisId);
  emlrtDestroyArray(&u);
}

/*
 * Arguments    : const emlrtStack *sp
 *                const char * b
 *                const char * c
 *                const char * d
 *                const char * e
 *                const char * f
 *                const char * g
 *                const char * h
 *                const char * i
 *                const char * j
 *                const char * k
 *                const char * l
 *                const char * m
 *                const char * n
 *                real_T o
 *                const char * p
 *                real_T q
 *                const char * r
 *                real_T s
 *                const char * t
 *                real_T u
 *                const char * v
 *                real_T w
 *                const char * x
 *                real_T y
 *                const char * ab
 *                real_T bb
 *                const char * cb
 *                real_T db
 *                const char * eb
 *                real_T fb
 *                const char * gb
 *                real_T hb
 *                const char * ib
 *                real_T jb
 *                const char * kb
 *                real_T lb
 *                const char * mb
 *                boolean_T nb
 *                const char * ob
 *                real_T pb
 *                const char * qb
 *                real_T rb
 *                emlrtMCInfo *location
 * Return Type  : const mxArray *
 */
static const mxArray *fimath(const emlrtStack *sp, const char * b, const char
  * c, const char * d, const char * e, const char * f, const char * g, const
  char * h, const char * i, const char * j, const char * k, const char * l,
  const char * m, const char * n, real_T o, const char * p, real_T q, const char
  * r, real_T s, const char * t, real_T u, const char * v, real_T w, const char *
  x, real_T y, const char * ab, real_T bb, const char * cb, real_T db, const
  char * eb, real_T fb, const char * gb, real_T hb, const char * ib, real_T jb,
  const char * kb, real_T lb, const char * mb, boolean_T nb, const char * ob,
  real_T pb, const char * qb, real_T rb, emlrtMCInfo *location)
{
  const mxArray *pArrays[42];
  const mxArray *m3;
  pArrays[0] = emlrtCreateString(b);
  pArrays[1] = emlrtCreateString(c);
  pArrays[2] = emlrtCreateString(d);
  pArrays[3] = emlrtCreateString(e);
  pArrays[4] = emlrtCreateString(f);
  pArrays[5] = emlrtCreateString(g);
  pArrays[6] = emlrtCreateString(h);
  pArrays[7] = emlrtCreateString(i);
  pArrays[8] = emlrtCreateString(j);
  pArrays[9] = emlrtCreateString(k);
  pArrays[10] = emlrtCreateString(l);
  pArrays[11] = emlrtCreateString(m);
  pArrays[12] = emlrtCreateString(n);
  pArrays[13] = emlrtCreateDoubleScalar(o);
  pArrays[14] = emlrtCreateString(p);
  pArrays[15] = emlrtCreateDoubleScalar(q);
  pArrays[16] = emlrtCreateString(r);
  pArrays[17] = emlrtCreateDoubleScalar(s);
  pArrays[18] = emlrtCreateString(t);
  pArrays[19] = emlrtCreateDoubleScalar(u);
  pArrays[20] = emlrtCreateString(v);
  pArrays[21] = emlrtCreateDoubleScalar(w);
  pArrays[22] = emlrtCreateString(x);
  pArrays[23] = emlrtCreateDoubleScalar(y);
  pArrays[24] = emlrtCreateString(ab);
  pArrays[25] = emlrtCreateDoubleScalar(bb);
  pArrays[26] = emlrtCreateString(cb);
  pArrays[27] = emlrtCreateDoubleScalar(db);
  pArrays[28] = emlrtCreateString(eb);
  pArrays[29] = emlrtCreateDoubleScalar(fb);
  pArrays[30] = emlrtCreateString(gb);
  pArrays[31] = emlrtCreateDoubleScalar(hb);
  pArrays[32] = emlrtCreateString(ib);
  pArrays[33] = emlrtCreateDoubleScalar(jb);
  pArrays[34] = emlrtCreateString(kb);
  pArrays[35] = emlrtCreateDoubleScalar(lb);
  pArrays[36] = emlrtCreateString(mb);
  pArrays[37] = emlrtCreateLogicalScalar(nb);
  pArrays[38] = emlrtCreateString(ob);
  pArrays[39] = emlrtCreateDoubleScalar(pb);
  pArrays[40] = emlrtCreateString(qb);
  pArrays[41] = emlrtCreateDoubleScalar(rb);
  return emlrtCallMATLABR2012b(sp, 1, &m3, 42, pArrays, "fimath", true, location);
}

/*
 * Arguments    : const emlrtStack *sp
 *                const mxArray *u
 *                const emlrtMsgIdentifier *parentId
 * Return Type  : void
 */
static void g_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u, const
  emlrtMsgIdentifier *parentId)
{
  static const int32_T dims[2] = { 0, 0 };

  emlrtCheckFiR2012b(sp, parentId, u, false, 2U, dims, eml_mx, c_eml_mx);
  k_emlrt_marshallIn(emlrtAlias(u));
  emlrtDestroyArray(&u);
}

/*
 * Arguments    : const emlrtStack *sp
 *                const mxArray *u
 *                const emlrtMsgIdentifier *parentId
 * Return Type  : void
 */
static void h_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u, const
  emlrtMsgIdentifier *parentId)
{
  static const int32_T dims[2] = { 0, 0 };

  emlrtCheckFiR2012b(sp, parentId, u, false, 2U, dims, eml_mx, d_eml_mx);
  l_emlrt_marshallIn(emlrtAlias(u));
  emlrtDestroyArray(&u);
}

/*
 * Arguments    : const mxArray *src
 *                int8_T ret[6]
 * Return Type  : void
 */
static void i_emlrt_marshallIn(const mxArray *src, int8_T ret[6])
{
  const mxArray *mxInt;
  int32_T i0;
  mxInt = emlrtImportFiIntArrayR2008b(src);
  for (i0 = 0; i0 < 6; i0++) {
    ret[i0] = (*(int8_T (*)[6])emlrtMxGetData(mxInt))[i0];
  }

  emlrtDestroyArray(&mxInt);
  emlrtDestroyArray(&src);
}

/*
 * Arguments    : const emlrtStack *sp
 *                const mxArray *src
 *                const emlrtMsgIdentifier *msgId
 * Return Type  : real_T
 */
static real_T j_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src, const
  emlrtMsgIdentifier *msgId)
{
  real_T ret;
  static const int32_T dims = 0;
  emlrtCheckBuiltInR2012b(sp, msgId, src, "double", false, 0U, &dims);
  ret = *(real_T *)emlrtMxGetData(src);
  emlrtDestroyArray(&src);
  return ret;
}

/*
 * Arguments    : const mxArray *src
 * Return Type  : void
 */
static void k_emlrt_marshallIn(const mxArray *src)
{
  const mxArray *mxInt;
  mxInt = emlrtImportFiIntArrayR2008b(src);
  emlrtDestroyArray(&mxInt);
  emlrtDestroyArray(&src);
}

/*
 * Arguments    : const mxArray *src
 * Return Type  : void
 */
static void l_emlrt_marshallIn(const mxArray *src)
{
  const mxArray *mxInt;
  mxInt = emlrtImportFiIntArrayR2008b(src);
  emlrtDestroyArray(&mxInt);
  emlrtDestroyArray(&src);
}

/*
 * Arguments    : const emlrtStack *sp
 *                const char * b
 *                real_T c
 *                const char * d
 *                real_T e
 *                const char * f
 *                real_T g
 *                const char * h
 *                real_T i
 *                const char * j
 *                real_T k
 *                emlrtMCInfo *location
 * Return Type  : const mxArray *
 */
static const mxArray *numerictype(const emlrtStack *sp, const char * b, real_T c,
  const char * d, real_T e, const char * f, real_T g, const char * h, real_T i,
  const char * j, real_T k, emlrtMCInfo *location)
{
  const mxArray *pArrays[10];
  const mxArray *m1;
  pArrays[0] = emlrtCreateString(b);
  pArrays[1] = emlrtCreateDoubleScalar(c);
  pArrays[2] = emlrtCreateString(d);
  pArrays[3] = emlrtCreateDoubleScalar(e);
  pArrays[4] = emlrtCreateString(f);
  pArrays[5] = emlrtCreateDoubleScalar(g);
  pArrays[6] = emlrtCreateString(h);
  pArrays[7] = emlrtCreateDoubleScalar(i);
  pArrays[8] = emlrtCreateString(j);
  pArrays[9] = emlrtCreateDoubleScalar(k);
  return emlrtCallMATLABR2012b(sp, 1, &m1, 10, pArrays, "numerictype", true,
    location);
}

/*
 * Arguments    : const mxArray * const prhs[5]
 *                int32_T nlhs
 *                const mxArray *plhs[1]
 * Return Type  : void
 */
void codeCalculator_api(const mxArray * const prhs[5], int32_T nlhs, const
  mxArray *plhs[1])
{
  int8_T seq[6];
  real_T opt1;
  real_T opt2;
  real_T equ;
  int16_T out;
  emlrtStack st = { NULL,              /* site */
    NULL,                              /* tls */
    NULL                               /* prev */
  };

  (void)nlhs;
  st.tls = emlrtRootTLSGlobal;

  /* Marshall function inputs */
  emlrt_marshallIn(&st, emlrtAliasP(prhs[0]), "seq", seq);
  opt1 = c_emlrt_marshallIn(&st, emlrtAliasP(prhs[1]), "opt1");
  opt2 = c_emlrt_marshallIn(&st, emlrtAliasP(prhs[2]), "opt2");
  equ = c_emlrt_marshallIn(&st, emlrtAliasP(prhs[3]), "equ");
  e_emlrt_marshallIn(&st, emlrtAliasP(prhs[4]), "T");

  /* Invoke the target function */
  out = codeCalculator(seq, opt1, opt2, equ);

  /* Marshall function outputs */
  plhs[0] = emlrt_marshallOut(&st, out);
}

/*
 * Arguments    : void
 * Return Type  : void
 */
void codeCalculator_atexit(void)
{
  emlrtStack st = { NULL,              /* site */
    NULL,                              /* tls */
    NULL                               /* prev */
  };

  mexFunctionCreateRootTLS();
  st.tls = emlrtRootTLSGlobal;
  emlrtEnterRtStackR2012b(&st);
  emlrtLeaveRtStackR2012b(&st);
  emlrtDestroyRootTLS(&emlrtRootTLSGlobal);
  codeCalculator_xil_terminate();
  emlrtDestroyArray(&eml_mx);
  emlrtDestroyArray(&b_eml_mx);
  emlrtDestroyArray(&c_eml_mx);
  emlrtDestroyArray(&d_eml_mx);
  emlrtDestroyArray(&e_eml_mx);
}

/*
 * Arguments    : void
 * Return Type  : void
 */
void codeCalculator_initialize(void)
{
  emlrtStack st = { NULL,              /* site */
    NULL,                              /* tls */
    NULL                               /* prev */
  };

  mexFunctionCreateRootTLS();
  st.tls = emlrtRootTLSGlobal;
  emlrtClearAllocCountR2012b(&st, false, 3U, "ForceOff");
  emlrtEnterRtStackR2012b(&st);
  if (emlrtFirstTimeR2012b(emlrtRootTLSGlobal)) {
    codeCalculator_once(&st);
  }
}

/*
 * Arguments    : void
 * Return Type  : void
 */
void codeCalculator_terminate(void)
{
  emlrtStack st = { NULL,              /* site */
    NULL,                              /* tls */
    NULL                               /* prev */
  };

  st.tls = emlrtRootTLSGlobal;
  emlrtLeaveRtStackR2012b(&st);
  emlrtDestroyRootTLS(&emlrtRootTLSGlobal);
}

/*
 * File trailer for _coder_codeCalculator_api.c
 *
 * [EOF]
 */
