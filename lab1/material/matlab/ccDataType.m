function datatype = ccDataType(dt,sort_WL,normalize_WL,result_WL)

    switch dt
        case 'double'
            datatype.sort_WL = double([]);
            datatype.normalize_WL = double([]);
            datatype.result_WL = double([]);
        case 'single'
            datatype.sort_WL = single([]);
            datatype.normalize_WL = single([]);
            datatype.result_WL = single([]);
        case 'fixed'
            F = fimath('RoundingMethod', 'Floor');

            datatype.sort_WL = fi([], 1, sort_WL, 0,F);
            datatype.normalize_WL = fi([], 1, normalize_WL, 0,F);
            datatype.result_WL = fi([], 1, result_WL, 0,F);
        case 'scaled'
            % This runs computation in double but store data in fix point, a debugging type
            % To check how far your range for your fix-point, want to get all the possible range.
            datatype.sort_WL = fi([], 1, sort_WL, 0, 'DataType', 'ScaledDouble');
            datatype.normalize_WL = fi([], 1, normalize_WL, 0, 'DataType', 'ScaledDouble');
            datatype.result_WL = fi([], 1,  result_WL, 0, 'DataType', 'ScaledDouble');
    end

end