function frameInfo = createFrameInfo(mouse, date, expnum, varargin)
% CREATEFRAMEINFO Generate frame-aligned stimulus metadata for an imaging
% session. 
% CREATEFRAMEINFO(mouse, date, expnum).
% CREATEFRAMEINFO(mouse, date, expnum, Specs).
%
% Possible keyed arguments:
%   - 'CalibrationSequence' : gets passed into SyncDataManager.
%   - 'EventValues' : gets passed into SyncDataManager.


% Parse arguments.
expnum = num2str(expnum);
sesDir = sessiondir(mouse, date, expnum);
if ~exist(sesDir, 'dir')
    error('Session directory does not exist');
end

calibrationSequence = parseVarargin(varargin, 'CalibrationSequence', []);
eventValues = parseVarargin(varargin, 'EventValues', []);

% Load sync data and process it with SyncDataManager class.
syncData = loadSyncData(mouse, date, expnum);
sed = StrobedEventDecoder('CalibrationSequence', calibrationSequence, ...
                          'EventValues', eventValues);
sed.run(syncData);             

% Load movie, and remove trailing unneeded frames.
frameStarts = find(diff(syncData('FrameOut')));
frameStarts = frameStarts(frameStarts < sed.ExperimentStop);

%% Create Frame Info. For now on, switch to t0 centered at beginning of the
% experiment -- not the beginning of Thorsync recording.
time = syncData('time');
t0 = time(sed.ExperimentStart);
time = time - t0;
frameTime = time(frameStarts);
frameInfo = struct('tStart', {}, ...
                   'tStop', {}, ...
                   'Voltage', {}, ...
                   'EventValue', {});

eventStarts = time(extractfield(sed.Events, 'Start'));
for ii = 1:length(frameTime)
    
    % Initialize single frame info with start/stop times.
    info = struct('tStart', frameTime(ii), ...
                  'tStop', NaN, ...
                  'Voltage', NaN, ...
                  'EventValue', NaN);
    
    if ii == length(frameTime)
        info.tStop = time(sed.ExperimentStop);
    else
        info.tStop = frameTime(ii+1);
    end
              
    % Find nearest (previous) event and use its voltage and event value fields.
    index = length(eventStarts(eventStarts <= info.tStart));
    if index == 0
        index = 1;
    end
    nearest = sed.Events(index);
    info.Voltage = nearest.Voltage;
    info.EventValue = nearest.EventValue;
    
    % Finally, add the frame's info to the growing list.
    frameInfo(length(frameInfo) + 1) = info;
    
end

end