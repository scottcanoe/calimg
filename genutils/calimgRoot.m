function path = calimgRoot()
    % Returns top-level 'calimg' directory.
    funcName = [mfilename('fullpath') '.mat'];
    [genutilsDir, ~, ~] = fileparts(funcName);
    [path, ~, ~] = fileparts(genutilsDir);
end