function normalizedTraces = normalizeTraces(traces, percentile)
% NORMALIZETRACES 

narginchk(1, 2);

if nargin == 1
    percentile = 100;
end

normalizedTraces = zeros(size(traces));
for ii=1:size(traces, 1)
    tr = traces(ii, :);
    normalizedTraces(ii, :) = tr / prctile(tr, percentile);
end

end

