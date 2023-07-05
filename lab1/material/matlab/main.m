clc;
clear;


%================================================================
%  Output word Length for each layer
%================================================================
input_WL     = 5;
sort_WL      = 5;
normalize_WL = 5;
result_WL    = 10;

T = ccDataType('scaled',sort_WL,normalize_WL,result_WL);
%================================================================
%  Testing of Code Caculator
%================================================================
% test_seq = [6,1,4,7,12,15];
test_seq     = [6,1,4,7,12,15];
extreme_case_lower_bound = [-8,-8,-8,-8,-8,-8];
extreme_case_upper_bound = [15,15,15,15,15,15];

opt1 = 0;
opt2 = 1;
equ  = 0;

t = fi([],1,input_WL,0);
test_seq = cast(test_seq,'like',t);
extreme_case_lower_bound = cast(extreme_case_lower_bound,'like',t);
extreme_case_upper_bound = cast(extreme_case_upper_bound,'like',t);


buildInstrumentedMex codeCalculator -o codeCalculator_mex ...
    -args {test_seq,opt1,opt2,equ,T} -histogram


disp("Common case");
result1 = codeCalculator_mex(test_seq,opt1,opt2,equ,T)
disp("Negative Extreme case");
result2 = codeCalculator_mex(extreme_case_lower_bound,opt1,opt2,1,T)
disp("Positive Extreme case");
result3 = codeCalculator_mex(extreme_case_upper_bound,opt1,opt2,equ,T)


%================================================================
%  Fixed point verification
%================================================================
% Verify results
% Show instrumentatinResults can suggest you the optimal width you should use for the best result
showInstrumentationResults codeCalculator_mex -proposeWL -defaultDT numerictype(1, 12, 6)

% Code generation
codegen codeCalculator ...
    -args {test_seq,opt1,opt2,equ,T} -config:lib -report
