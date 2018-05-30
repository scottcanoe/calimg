function mice = listMice(localOrRemote)
% LISTMICE Returns a list of all directories in the dataroot (excluding S2P).

narginchk(0, 1)
if nargin == 0
    localOrRemote = 'local';
end

mice = listDirs(dataroot(localOrRemote));
mice = removeString(mice, 'S2P');
