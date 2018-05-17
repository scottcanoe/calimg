function path = homedir()
% Returns absolute path to home directory.

if isunix
    path = asdir(getenv('HOME'));
else
    path = asdir(getenv('USERPROFILE'));
end

if isempty(path)
    error('Cannot find home directory');
end

