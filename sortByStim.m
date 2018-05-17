function varargout = sortByStim(traces, intSignal)
% SORTBYSTIM 
% sortedTraces = SORTBYSTIM(traces, intSignal)
% [sortedTraces, sortingIndices] = SORTBYSTIM(traces, intSignal)

ae = int32(intSignal);
aeChanged = find(diff(ae));
aeUp = aeChanged(1:2:end);
aeDown = aeChanged(2:2:end);

assert(length(aeUp) == length(aeDown));
numEvents = length(aeUp) - 1;
numCells = size(traces, 1);
sortVec = zeros([numCells, 1]);

for ii = 1:numCells
    stimVals = zeros(numEvents);
    grayVals = zeros(numEvents);
    
    for jj = 1:numEvents
        stimVals(jj) = mean(traces(ii, aeUp(jj):aeDown(jj)));
        grayVals(jj) = mean(traces(ii, aeDown(jj):aeUp(jj+1)));
    end
    sortVec(ii) = mean(stimVals) / mean(grayVals);
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

