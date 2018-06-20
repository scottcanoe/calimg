function label = eventValueToLabel(val, seqSpecs)
% EVENTVALUETOLABEL Summary of this function goes here
%   Detailed explanation goes here

narginchk(2, 2);

[~, index] = min(abs(val - seqSpecs.EventValues));
label = seqSpecs.Labels{index};

end

