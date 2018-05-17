function procmat = loadProcMat(mouse, date, expnum)
% PROCFILE Load stored .mat file produced by using suite2ps gui.

narginchk(3, 3);

if ~ischar(expnum)
    expnum = num2str(expnum);
end

procDir = fullfile(s2p.resultsRoot, mouse, date, expnum);
fstruct = dir(fullfile(procDir, 'F*proc.mat'));
fname = fullfile(fstruct.folder, fstruct.name);
procmat = load(fname);

end

