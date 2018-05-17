function varargout = sortTraces(traces, statistic)
%SORTTRACES Summary of this function goes here
% sortedTraces = SORTTRACES(traces, statistic)
% [sortedTraces, sortingIndices] = SORTTRACES(traces, statistic)

narginchk(2, 2);

if strcmp(statistic, 'skew')
    sortVec = skewness(traces, 0, 2);
elseif strcmp(statistic, 'std')
    sortVec = std(traces, 0, 2);    
else
    error('Unsupported statistic');
end

[~, sortingIndices] = sort(sortVec, 'descend');
sortedTraces = zeros(size(traces));
for ii=1:size(traces, 1)
    sortedTraces(ii, :) = traces(sortingIndices(ii), :);
end

varargout{1} = sortedTraces;
if nargout == 2
    varargout{2} = sortingIndices;
end

end
