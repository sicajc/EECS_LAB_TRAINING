integer i;

always @(*)
begin
    // Initialization
    sum = 0;
    for(i = 0;i<N;i=i+1)
    begin
        sum = sum + partial_sum[i];
    end
end


always@(*)
begin
    // This generates a MAC tree, Output at product, must consider the maximum number of product length to accommodate all possible value.
    product = 0;
    product = mult[0] * K1 + mult[0] * K1;
    product = mult[1] * K2 + product;
    product = mult[3] * K3 + product;
    product = mult[4] * K4 + product;
end
