function [] = process_exp01_SequentialGratings(mouse, date, expnum)

% Prepare some values and do some light validation.
expnum = num2str(expnum);
sesDir = sessiondir(mouse, date, expnum);
if ~exist(sesDir, 'dir')
    error('Directory does not exist.');
end

% Define parameters used in exp01_SequentialGratings.m.
stimCodes = 0.0:0.2:3.0;
nPresentations = 50;  % Number of sequences per block.
nBlocks = 4;

% The following table mirrors the structure in exp01_SequentialGratings.m.
%
% Stim. | Voltage | Description
% ------------------------------
%   0   |   0.0   | interblock?
%   1   |   0.2   | A (ABCD)
%   2   |   0.4   | B (ABCD)
%   3   |   0.6   | C (ABCD)
%   4   |   0.8   | D (ABCD)
%   5   |   1.0   | gray (ABCD)
%   6   |   1.2   | D (DCBA)
%   7   |   1.4   | C (DCBA)
%   8   |   1.6   | B (DCBA)
%   9   |   1.8   | A (DCBA)
%  10   |   2.0   | gray (DCBA)
%  11   |   2.2   | A (ABCD novel timing)
%  12   |   2.4   | A (ABCD novel timing)
%  13   |   2.6   | A (ABCD novel timing)
%  14   |   2.8   | A (ABCD novel timing)
%  15   |   3.0   | A (ABCD novel timing)

%% Create 'frameInfo.mat' file, find experiment bounds, and trim it.
disp('Creating frameInfo.');
frameInfo = createFrameInfo(mouse, date, expnum, 'StimCodes', stimCodes);

% - Find index of last frame captured during experiment.
lastFrameIndex = length(frameInfo);

% - Find index of first frame that happens during the experiment (i.e., where
%   the stim code stops being 0.
codes = extractfield(frameInfo, 'StimCode');
firstFrameIndex = 1;
while codes(firstFrameIndex) == 0
    firstFrameIndex = firstFrameIndex + 1;
end

% - Finally, trim the frame info and save it.
frameInfo = frameInfo(firstFrameIndex:lastFrameIndex);
save(fullfile(sesDir, 'frameInfo.mat'), 'frameInfo');
clear codes; % no longer up-to-date.

%% Load raw movie, trim it, and save it as a tiff series readable by Suite2P.

% - Load and trim the movie.
disp('Loading raw movie, and removing unneeded frames.');
mov = loadRawMovie(mouse, date, expnum);
if size(mov, 1) > lastFrameIndex
    mov = mov(1:lastFrameIndex, :, :);
end
mov = mov(firstFrameIndex:end, :, :);

% - Save it in a Suite2P-compatible format and location.
disp('Saving movie as a tiff series in Suite 2Ps input root.');
tiffseries_save(fullfile(s2p.inputRoot, mouse, date, expnum), mov);
clear mov; % Free up some memory.

%% Run Suite2P.
% - Create the database.
clear db;
db(1).mouse_name    = mouse;
db(1).date          = date;
db(1).expts         = expnum;
db(1).diameter      = 14; % Taken at 2X. Make this dynamic later.
assignin('base', 'db', db);

% % Finally, run Suite2P.
master_file_exp01_SequentialGratings;

%% Do some cleanup (e.g., delete redundant files.).

% - Delete raw movie file to clear up disk space?
% files = dir(fullfile(sesDir, 'Image*.raw'));
% filename = fullfile(sesDir, files(1).name);
% delete(filename);

end