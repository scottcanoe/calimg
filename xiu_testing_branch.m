function cells = loadCells(arg1, arg2, arg3)
% LOADROIS Load struct array of ROIs and their associated info.
% LOADROID(procmat)
% LOADROID(mouse, date, expnum)

if nargin == 1
    procmat = arg1;
elseif nargin == 3
    procmat = loadProcMat(arg1, arg2, arg3);
else
    error('bad argument structure');
end

IDs = getCellIDs(procmat);

% Initialize struct array to hold cells.
cells(length(IDs)) = struct();
cells(1).ID = 0;
cells(1).iscell = true;
cells(1).neuropilCoefficient = 0;
cells(1).xpix = [];
cells(1).ypix = [];
cells(1).ipix = [];
cells(1).npix = 0;
cells(1).isoverlap = false;
cells(1).lam = 0;
cells(1).lambda = 0;
cells(1).med = [];
cells(1).std = 0;
cells(1).skew = 0;
cells(1).pct = 0;
cells(1).footprint = 0;
cells(1).mimgProjAbs = 0;
cells(1).aspect_ratio = 0;
cells(1).Fcell = [];
cells(1).Fneu = [];
cells(1).trace = [];

Fcell = cell2mat(procmat.dat.Fcell);
FcellNeu = cell2mat(procmat.dat.FcellNeu);

for ii = 1:length(IDs)
    stat = procmat.dat.stat(ii);
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