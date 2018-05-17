function processed = dFF(traces, varargin)
% Computes dF/F for one or more traces. If a matrix of traces is given,
% then it is assumed that rows are individual traces. Can also
% 'normalize'/squash the traces using percentiles.

frameRate = parseVarargin(varargin, 'FrameRate', 30);
windowSecs = parseVarargin(varargin, 'Window', 10);
window = [int32(ceil(windowSecs*frameRate)) 0];

shape = size(traces);
assert(length(shape) == 2);

if or(shape(1) == 1, shape(2) == 1)
    % row or column vector (given one trace).
    processed = traces - movmin(traces, window);
        
else
    % Do many traces at once.
    processed = traces - movmin(traces, window, 2);
end

end