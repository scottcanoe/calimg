function [] = processRawData(mouse, date, expnum, calibrationSequence, stimCodes)
% PROCESSRAWDATA Generate frame-aligned stimulus metadata for an imaging
% session, and convert raw movie file to an hdf5 store.
% After merging the contents of Thorimage- and Thorsync-created directories into
% a single "session directory", call this function to 
%
% * 1) Convert the raw movie file into a hdf5 store (with trailing frames
% removed), and 
% * 2) generate 'frameInfo' - a struct array containing information
% corresponding to each frame in the movie - and save it as 'frameInfo.mat' in
% the session directory. 
% 
% 'frameInfo' has the following fields:
% * tStart: start time of frame.
% * tStop: stop time of frame.
% * Voltage: value of AnalogEvents signal during the frame.
% * StimCode: stimulus code associated with Voltage. NOT YET IMPLEMENTED
%
% PROCESSRAWDATA displays a dialog for selecting a session directory, and
% then triggers the processing.
% PROCESSRAWDATA(sesDir) processes data given a session directory.
narginchk(3, 5);
if nargin == 5
    
expnum = num2str(expnum);
sesDir = sessiondir(mouse, date, expnum);
if ~exist(sesDir, 'dir')
    error('Directory does not exist');
end
       
% Load sync data and process it with SyncDataManager class.
SyncData = loadSyncData(mouse, date, expnum);
sdm = SyncDataManager(); %#ok<NASGU>
if nargin == 3
    sdm = SyncDataManager();
elseif nargin == 4
    sdm = SyncDataManager('CalibrationSequence', calibrationSequence);
else
    sdm = SyncDataManager('CalibrationSequence', calibrationSequence, ...
                          'StimCodes', stimCodes);
end
sdm.run(SyncData);             

% Load movie, and remove trailing unneeded frames.
frameStarts = find(diff(SyncData('FrameOut')));
frameStarts = frameStarts(frameStarts < sdm.ExperimentStop);
numTimepoints = length(frameStarts);

% Load and save movie as a tiff series.
mov = loadRawMovie(mouse, date, expnum);
if size(mov, 1) > numTimepoints
    mov = mov(1:numTimepoints, :, :);
end
tiffseries_save(fullfile(s2p.inputRoot, mouse, date, expnum), mov);

%% Create Frame Info. For now on, switch to t0 centered at beginning of the
% experiment -- not the beginning of Thorsync recording.
time = SyncData('time');
t0 = time(sdm.ExperimentStart);
time = time - t0;
frameTime = time(frameStarts);
frameInfo = struct('tStart', {}, ...
                   'tStop', {}, ...
                   'Voltage', {}, ...
                   'StimCode', {});

eventStarts = time(extractfield(sdm.Events, 'Start'));
for ii = 1:length(frameTime)
    
    % Initialize single frame info with start/stop times.
    info = struct('tStart', frameTime(ii), ...
                  'tStop', NaN, ...
                  'Voltage', NaN, ...
                  'StimCode', NaN);
    
    if ii == length(frameTime)
        info.tStop = time(sdm.ExperimentStop);
    else
        info.tStop = frameTime(ii+1);
    end
              
    % Find nearest event and use its voltage and stimcode fields.
    [~, index] = min(abs(info.tStart - eventStarts));
    nearest = sdm.Events(index);
    info.Voltage = nearest.Voltage;
    info.StimCode = nearest.StimCode;
    
    % Finally, add the frame's info to the growing list.
    frameInfo(length(frameInfo) + 1) = info;
    
end

% Save frame info.
save(fullfile(sesDir, 'frameInfo.mat'), 'frameInfo');

end