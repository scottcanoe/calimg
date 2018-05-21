function dirs = listDirs(parentDir)
% LISTDIRS Get a list of directories in human-sorted order.

narginchk(1, 1)
contents = dir(parentDir);
dirs = cell(1, length(contents));
nDirs = 0;

for ii=1:length(contents)
    s = contents(ii);
    if and(s.isdir, ~ismember(s.name, '.', '..'))
        dirs{nDirs+1} = s.name;
        nDirs = nDirs + 1;
    end
end

if nDirs == 0
    dirs = {};
else
    dirs = humanSort(dirs(1:nDirs));
end
