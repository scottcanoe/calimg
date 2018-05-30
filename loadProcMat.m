function procmat = loadProcMat(mouse, date, expnum, localOrRemote)
% PROCFILE Load stored .mat file produced by using suite2ps gui.
% WARNING: this will be modified soon.

narginchk(3, 4);

if nargin == 3
    localOrRemote = 'local';
end

if ~ischar(expnum)
    expnum = num2str(expnum);
end

sesDir = sessiondir(mouse, date, expnum, localOrRemote);
fstruct = dir(fullfile(sesDir, 'F*proc.mat'));
fname = fullfile(fstruct.folder, fstruct.name);
procmat = load(fname);

end