function path = calimgRoot()
% CALIMGROOT Returns absolute path to the 'calimg' package.
funcName = [mfilename('fullpath') '.mat'];
[genutilsDir, ~, ~] = fileparts(funcName);
[path, ~, ~] = fileparts(genutilsDir);
path = abspath(path);
end