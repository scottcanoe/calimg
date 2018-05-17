function frameInfo = createFrameInfo(mouse, date, expnum, varargin)
% CREATEFRAMEINFO Generate frame-aligned stimulus metadata for an imaging
% session. 
% CREATEFRAMEINFO(mouse, date, expnum).
% CREATEFRAMEINFO(mouse, date, expnum, Specs).
%
% Possible keyed arguments:
%   - 'CalibrationSequence' : gets passed into SyncDataManager.
%   - 'StimCodes' : gets passed into SyncDataManager.


% Parse arguments.
expnum = num2str(expnum);
sesDir = sessiondir(mouse, date, expnum);
if ~exist(sesDir, 'dir')
    error('Session directory does not exist');
end

calibrationSequence = parseVarargin(varargin, 'CalibrationSequence', []);
stimCodes = parseVarargin(varargin, 'StimCodes', []);

% Load sync data and process it with SyncDataManager class.
SyncData = loadSyncData(mouse, date, expnum);
sdm = SyncDataManager('CalibrationSequence', calibrationSequence, ...
                      'StimCodes', stimCodes);
sdm.run(SyncData);             

% Load movie, and remove trailing unneeded frames.
frameStarts = find(diff(SyncData('FrameOut')));
frameStarts = frameStarts(frameStarts < sdm.ExperimentStop);

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

end