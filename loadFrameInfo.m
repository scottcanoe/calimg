function frameInfo = loadFrameInfo(arg1, arg2, arg3)
% LOADFRAMEINFO Returns struct array containing frame metadata. 
% LOADFRAMEINFO Prompts user to select a sync episode file with uigetfile.
% LOADFRAMEINFO(filename) Call with path to sync episode file.
% LOADFRAMEINFO(mouse, date, expnum) Call mouse/date/expnum pattern.

if nargin == 0
    [file, path] = uigetfile(fullfile(dataroot, '*.mat'));
    filename = fullfile(path, file);
elseif nargin == 1
    filename = arg1;
elseif nargin == 3
    mouse = arg1;
    date = arg2;
    expnum = num2str(arg3);
    sesDir = sessiondir(mouse, date, expnum);
    files = dir(fullfile(sesDir, 'frameInfo.mat'));
    filename = fullfile(sesDir, files(1).name);
else
    error('Bad arg structure.');
end
S = load(filename);
frameInfo = S.frameInfo;
end