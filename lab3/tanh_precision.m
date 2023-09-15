x = 32.4472;

x = single(x);
num2str(x)
disp(['Single Floating-Point Representation of x: ', num2str(x)]);

result_original      = (exp(x) - exp(-x))/(exp(x) + exp(-x));

result_with_grouping = (1 - exp(-(x+1)))/(1+ exp(-(x+1)));
disp(['Single Floating-Point Representation of result: ', num2str(result_original)]);

difference = (result_original - result_with_grouping) / result_original;


