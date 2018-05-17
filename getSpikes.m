function spikes = getSpikes(arg1, arg2, arg3)
% GETSPIKES Get OASIS-deconvolved data for ROIs that have been selected as cells.
% GETSPIKES(procmat)
% GETSPIKES(mouse, date, expnum)

if nargin == 1
    procmat = arg1;
elseif nargin == 3
    procmat = loadProcMat(arg1, arg2, arg3);
else
    error('bad argument structure');
end

IDs = getCellIDs(procmat);

% Get spikes.
F = cell2mat(procmat.dat.sp);
numTimepoints = size(F, 2);
spikes = zeros([length(IDs), numTimepoints], class(F));
for ii=1:length(IDs)
    spikes(ii, :) = F(IDs(ii), :);
end
end

