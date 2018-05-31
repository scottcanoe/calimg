function dirname = asdir(dirname)
% Adds a trailing backslash to 'name' if it doesn't already have one.
if ~strcmp(dirname(end), filesep)
    dirname = [dirname filesep];
end

end

