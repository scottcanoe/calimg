function mice = listMice(localOrRemote)
% LISTFILES Get a list of files in human-sorted order. Directories can be
% excluded by settings 'includeDirs' to false.

narginchk(0, 1)
if nargin == 0
    localOrRemote = 'local';
end

contents = dir(dataroot(localOrRemote));
dirs = cell(1, length(contents));
nDirs = 0;
ignore = {'.', '..', 'Thumbs.db', '.DS_Store', 'S2P'};
for ii=1:length(contents)
    s = contents(ii);
    if or(ismember(s.name, ignore), ~s.isdir)
        continue
    end
    
    dirs{nDirs+1} = s.name;
    nDirs = nDirs + 1;
end

if nDirs == 0
    mice = {};
else
    mice = humanSort(dirs(1:nDirs));
end
