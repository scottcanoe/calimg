function [] = process_random_drifting_gratings(mouse, date, expnum)

% Prepare some values and do some light validation.
expnum = num2str(expnum);
sesDir = sessiondir(mouse, date, expnum);
if ~exist(sesDir, 'dir')
    error('Directory does not exist.');
end

% Define parameters used in exp01_SequentialGratings.m.
eventValues = [0.0, 1.0, 1.5, 2.0, 2.5, 3.0, 3.5, 4.0, 4.5];


%% Create 'frameInfo.mat' file, find experiment bounds, and trim it.
disp('Creating frameInfo.');
frameInfo = createFrameInfo(mouse, date, expnum, 'EventValues', eventValues);

% - Find index of last frame captured during experiment.
lastFrameIndex = length(frameInfo);

% - Find index of first frame that happens during the experiment (i.e., where
%   the stim code stops being 0.
vals = extractfield(frameInfo, 'EventValue');
firstFrameIndex = 1;
while vals(firstFrameIndex) == 0
    firstFrameIndex = firstFrameIndex + 1;
end

% - Finally, trim the frame info and save it.
frameInfo = frameInfo(firstFrameIndex:lastFrameIndex); %#ok<NASGU>
save(fullfile(sesDir, 'frameInfo.mat'), 'frameInfo');
clear vals; % no longer up-to-date.

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
db(1).diameter      = 2; % Taken at 2X. Make this dynamic later.
assignin('base', 'db', db);

% % Finally, run Suite2P.
master_file_exp01_SequentialGratings;

%% Do some cleanup (e.g., delete redundant files.)

% - Delete raw movie file to clear up disk space.
files = dir(fullfile(sesDir, 'Image*.raw'));
filename = fullfile(sesDir, files(1).name);
delete(filename);

% - Delete input directory to clear up disk space.
rmdir(fullfile(s2p.inputRoot, mouse, date, expnum), 's');

% - Move registration results into main folder.
regDir = fullfile(s2p.registrationRoot, mouse, date, expnum, 'Plane1');
destDir = fullfile(sesDir, 'mov');
% mkdir(destDir);
movefile(regDir, destDir);
rmdir(fullfile(s2p.registrationRoot, mouse, date, expnum), 's');

% - Move results into main folder.
resDir = fullfile(s2p.resultsRoot, mouse, date, expnum);
copyfile(resDir, sesDir);
rmdir(resDir, 's');

end