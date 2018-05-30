function path = homedir()
% Returns absolute path to home directory.

if isunix
    path = getenv('HOME');
else
    path = getenv('USERPROFILE');
end

if isempty(path)
    error('Cannot find home directory');
end

