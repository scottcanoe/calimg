function cells = loadCells(arg1, arg2, arg3)
% LOADCELLS Load struct array of ROIs that are cells and their associated info.
% LOADCELLS(procmat)
% LOADCELLS(mouse, date, expnum)

if nargin == 1
    procmat = arg1;
elseif nargin == 3
    procmat = loadProcMat(arg1, arg2, arg3);
else
    error('bad argument structure');
end

% Find IDs of cells (i.e., ROIs with 'iscell' = true).
iscellCells = extractfield(procmat.dat.stat, 'iscell');
iscell = zeros(size(iscellCells), 'logical');
for ii=1:length(iscell)
    iscell(ii) = cell2mat(iscellCells(ii));
end
IDs = find(iscell)';

% Initialize struct array to hold cells.
cells(length(IDs)) = struct();

Fcell = cell2mat(procmat.dat.Fcell);
FcellNeu = cell2mat(procmat.dat.FcellNeu);

for ii = 1:length(IDs)
    stat = procmat.dat.stat(IDs(ii));
    cells(ii).ID = IDs(ii);
    cells(ii).iscell = stat.iscell;
    cells(ii).neuropilCoefficient = stat.neuropilCoefficient;
    cells(ii).xpix = stat.xpix;
    cells(ii).ypix = stat.ypix;
    cells(ii).ipix = stat.ipix;
    cells(ii).npix = length(cells(ii).ipix);
    cells(ii).isoverlap = stat.isoverlap;
    cells(ii).lam = stat.lam;
    cells(ii).lamda = stat.lambda;
    cells(ii).med = stat.med;
    cells(ii).std = stat.std;
    cells(ii).skew = stat.skew;
    cells(ii).pct = stat.skew;
    cells(ii).footprint = stat.footprint;
    cells(ii).mimgProjAbs = stat.mimgProjAbs;
    cells(ii).aspect_ratio = stat.aspect_ratio;
    cells(ii).Fcell = Fcell(IDs(ii), :);
    cells(ii).FcellNeu = FcellNeu(IDs(ii), :);
    cells(ii).trace = dFF(cells(ii).Fcell - ...
                          cells(ii).neuropilCoefficient * cells(ii).FcellNeu);
end

end