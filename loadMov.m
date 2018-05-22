function mov = loadMov(mouse, date, expnum, localOrRemote)
% Load registered movies located in session directory.

narginchk(3, 4);
if nargin == 3
    localOrRemote = 'local';
end
expnum = num2str(expnum);
sesDir = sessiondir(mouse, date, expnum, localOrRemote);
mov = tss_read(fullfile(sesDir, 'mov'));

end