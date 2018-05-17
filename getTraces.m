function traces = getTraces(arg1, arg2, arg3)
% GETTRACES Get fluorescence (neuropil subtracted) traces for ROIs that have
% been selected as cells.
% GETTRACES(procmat)
% GETTRACES(mouse, date, expnum)

if nargin == 1
    procmat = arg1;
elseif nargin == 3
    procmat = loadProcMat(arg1, arg2, arg3);
else
    error('bad argument structure');
end

IDs = getCellIDs(procmat);
Fcell = cell2mat(procmat.dat.Fcell);
FcellNeu = cell2mat(procmat.dat.FcellNeu);
numTimepoints = size(Fcell, 2);
traces = zeros([length(IDs), numTimepoints]);
for ii=1:length(IDs)
    traces(ii, :) = Fcell(IDs(ii), :) - FcellNeu(IDs(ii), :);
end
end

