function cellIDs = getCellIDs(arg1, arg2, arg3)
% GETCELLIDS Retrieve IDs of ROIs that have been selected as cells.
% GETCELLIDS(procmat)
% GETCELLIDS(mouse, date, expnum)

if nargin == 1
    procmat = arg1;
elseif nargin == 3
    procmat = loadProcMat(arg1, arg2, arg3);
else
    error('bad argument structure');
end

iscellCells = extractfield(procmat.dat.stat, 'iscell');
iscell = zeros(size(iscellCells), 'logical');
for ii=1:length(iscell)
    iscell(ii) = cell2mat(iscellCells(ii));
end
cellIDs = find(iscell)';
end

