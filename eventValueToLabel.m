function label = eventValueToLabel(val, seqSpecs)
% EVENTVALUETOLABEL Summary of this function goes here
%   Detailed explanation goes here

narginchk(1, 2);
if nargin == 1
    seqSpecs = sequenceSpecs;
end

[~, index] = min(abs(val - seqSpecs.EventValues));
label = seqSpecs.Labels{index};

end

