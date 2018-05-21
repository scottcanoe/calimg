function files = listFiles(parentDir, includeDirs)
% LISTFILES Get a list of files in human-sorted order. Directories can be
% excluded by settings 'includeDirs' to false.

narginchk(1, 2)
if nargin==1
    includeDirs = true;
end
contents = dir(parentDir);
files = cell(1, length(contents));
nFiles = 0;
ignore = {'.', '..', 'Thumbs.db', '.DS_Store'};
for ii=1:length(contents)
    s = contents(ii);
    if ismember(s.name, ignore)
        continue
    end
    if and(s.isdir, includeDirs == false)
        continue
    end
    
    files{nFiles+1} = s.name;
    nFiles = nFiles + 1;
end

if nFiles == 0
    files = {};
else
    files = humanSort(files(1:nFiles));
end
