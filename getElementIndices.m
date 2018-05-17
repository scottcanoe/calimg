function ix = getElementIndices(codes, eltCode)
% GETELEMENTINDICES Returns indices that define where a particular stimulus 
% element occurs.

% Prepare the return value.
ix = struct('ix', {});

% Make an indicator function, and find where it rises and falls.
indicator = int32([0, codes == eltCode, 0]);

% If this stimulus isn't found, return immediately.
if ~any(indicator)
    return
end

indicatorDiffs = diff(indicator);
indicatorChanged = int32(find(indicatorDiffs));
indicatorRise = indicatorChanged(1:2:end);
indicatorFall = indicatorChanged(2:2:end);
assert(length(indicatorRise) == length(indicatorFall));

for ii=1:length(indicatorRise)
    start =  indicatorRise(ii);
    stop  =  indicatorFall(ii) - 1;
    ix(length(ix)+1) =  struct('ix', start:stop);
end

end

