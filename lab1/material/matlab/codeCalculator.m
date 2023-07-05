function out = codeCalculator(seq, opt1, opt2, equ, T)

    sorted_result = cast(seq, 'like', T.sort_WL);

    % No matter signed or unsigned, we all uses the same datapath.
    % sort, this would be implemented using bitonic sorters.
    if opt1 == 0
        sorted_result(:) = sort(seq);
    else
        sorted_result(:) = sort(seq, 'descend');
    end

    % disp("Sorted Result");
    sorted_result;

    cu_normalized = cast(sorted_result, 'like', T.normalize_WL);

    %Cumluation and Normalization
    if opt2 == 1

        for i = 1:length(sorted_result)
            if i == 1
                cu_normalized(1) = floor(sorted_result(1)*2 + sorted_result(1) / 3);
            else
                cu_normalized(i) = floor(cu_normalized(i-1)*2 + sorted_result(i) / 3);
            end

        end

    else
        % Shift the first number to become 0, others must follows
        if sorted_result(1) > 0
            % -1 for all number until first number is 0
                for j = 1:length(sorted_result)
                    cu_normalized(j) = cu_normalized(j) - sorted_result(1);
                    % disp("Cu normalized");
                    cu_normalized;
                end

        else
            % lt 0
            % +1 for all number until first number is 0
                for j = 1:length(sorted_result)
                    cu_normalized(j) = cu_normalized(j) + sorted_result(1);
                    % disp("Cu normalized");
                    cu_normalized;
                end
        end

    end

    % disp("Cumulated and Normalized");
    cu_normalized;

    result = cast(0, 'like', T.result_WL);
    temp_result = cast(0, 'like', T.result_WL);

    out = fi([], 1, 10, 0);
    out = cast(0, 'like', out);

    % Output equation
    if equ == 0
        % This simply performs sign extension
        result(:) = floor(((cu_normalized(4) + cu_normalized(5)*4) * cu_normalized(6)) / 3);
    else
        temp_result(:) = cu_normalized(6) * (cu_normalized(2) - cu_normalized(1));
        result(:) = abs(temp_result);
    end

    out(:) = result;

end
