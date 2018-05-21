function dates = listDates(mouse, localOrRemote)

narginchk(1, 2);
if nargin == 1
    localOrRemote = 'local';
end
mouseDir = fullfile(dataroot(localOrRemote), mouse);
dates = listDirs(mouseDir);
end

