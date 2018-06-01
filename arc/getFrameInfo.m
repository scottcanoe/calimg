function [frameInfo, sdm] = getFrameInfo(mouse, date, expnum)
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

sesDir = sessiondir(mouse, date, expnum);

% Load sync data and process it with SyncDataManager class.
SyncData = loadSyncData(mouse, date, expnum);
sdm = SyncDataManager('StimCodes', [0, 1.0, 1.5, 2.0, 2.5, 3.0, 3.5, 4.0, 4.5]);
sdm.run(SyncData);

% Load movie, and remove trailing unneeded frames.
frameStarts = find(diff(SyncData('FrameOut')));
frameStarts = frameStarts(frameStarts < sdm.ExperimentStop);
numTimepoints = length(frameStarts);

% mov = loadRawMovie(fullfile(sesDir, 'Image_0001_0001.raw'));
% if size(mov, 1) > numTimepoints
%     mov = mov(1:numTimepoints, :, :);
% end
% 
% % Save the movie as an h5 file.
% h5_save(fullfile(sesDir, 'Image_0001_0001.h5'), mov);     % DECOMMENT WHEN FINISHED

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