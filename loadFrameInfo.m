function frameInfo = loadFrameInfo(mouse, date, expnum, localOrRemote)
% LOADFRAMEINFO Returns struct array containing frame metadata. 

narginchk(3, 4);

% Handle local or remote.
if nargin == 3
    localOrRemote = 'local';
end

sesDir = sessiondir(mouse, date, expnum, localOrRemote);
filename = fullfile(sesDir, 'frameInfo.mat');
S = load(filename);
frameInfo = S.frameInfo;
end