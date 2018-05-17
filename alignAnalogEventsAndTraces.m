function [time, analogEvents, traces] = alignAnalogEventsAndTraces(syncData, traces)


% Get relevant info from frame sync data lines for trimming to experiment
% start and stop times and frame times. 

% Find where experiment started and stopped based on frame trigger line.
frameTrigger = int32(syncData('FrameTrigger'));
frameTriggerChanged = find(diff(frameTrigger));
numFT = length(frameTriggerChanged);
assert(or(numFT == 1, numFT == 2));
expStart = frameTriggerChanged(1);
if numFT == 1
    expStop = size(traces, 2);
else
    expStop = frameTriggerChanged(2);
end

% Find where frames were captured.
frameOut = syncData('FrameOut');
frameOutUp = find(diff(frameOut));
frameOutUp = frameOutUp(frameOutUp <= expStop);

% Get time array, and center at zero.
time = syncData('time');
time = time(frameOutUp);
time = time - time(1);

analogEvents = syncData('AnalogEvents');
analogEvents = analogEvents(frameOutUp);

% Trim traces.
maxFrames = min(size(traces, 2), length(time));
time = time(1:maxFrames);
analogEvents = analogEvents(1:maxFrames);
traces = traces(:, 1:maxFrames);

end

