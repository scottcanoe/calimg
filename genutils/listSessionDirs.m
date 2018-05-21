function sesDirs = listSessionDirs(mouse, localOrRemote)
% LISTSESSIONDIRS Get paths to all session directories for a given mouse.

narginchk(1, 2);
if nargin == 1
    localOrRemote = 'local';
end
sesDirs = {};
dateDirs = listDates(mouse, localOrRemote);
for ii=1:numel(dateDirs)
    date = dateDirs{ii};
    expNumDirs = listExpNums(mouse, date, localOrRemote);
    for jj=1:numel(expNumDirs)
        expnum = expNumDirs{jj};
        sesDirs{numel(sesDirs)+1} = fullfile(dataroot(localOrRemote), ...
                                             mouse, date, expnum); %#ok<AGROW>
    end
end

