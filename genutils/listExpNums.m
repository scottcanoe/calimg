function expNums = listExpNums(mouse, date, localOrRemote)

narginchk(2, 3);
if nargin == 2
    localOrRemote = 'local';
end
dateDir = fullfile(dataroot(localOrRemote), mouse, date);
expNums = listDirs(dateDir);
end

