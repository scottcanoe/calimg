function dirs = listDirs(parentDir)
% LISTFILES Get a list of files in human-sorted order. Directories can be
% excluded by settings 'includeDirs' to false.

narginchk(1, 1)
contents = dir(parentDir);
dirs = cell(1, length(contents));
nDirs = 0;
ignore = {'.', '..', 'Thumbs.db', '.DS_Store'};
for ii=1:length(contents)
    s = contents(ii);
    if or(ismember(s.name, ignore), ~s.isdir)
        continue
    end
    
    dirs{nDirs+1} = s.name;
    nDirs = nDirs + 1;
end

if nDirs == 0
    dirs = {};
else
    dirs = humanSort(dirs(1:nDirs));
end
