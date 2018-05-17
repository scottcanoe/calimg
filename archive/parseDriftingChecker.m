
strobedStartStop = true; % Should not need this after 2017-02-09.

sesDir = sessiondir('328890-C', '2018-02-09', 2);
sd = loadSyncData(fullfile(sesDir, 'Episode001.h5'));
time = sd('time');
frameTrigger = int32(sd('FrameTrigger'));
ae = sd('AnalogEvents');
ae(ae < 0.25) = 0;
frameOut = int32(sd('FrameOut'));
strobe = int32(sd('Strobe'));

% Zero out strobes and analoge event line during calibration sequence.
strobeChanged = find(diff(strobe));
strobeUp = strobeChanged(1:2:end);
strobeDown = strobeChanged(2:2:end);
strobe(1:strobeDown(6)+1) = 0;
ae(1:strobeDown(6)+1) = 0;

% If recording start/stop is strobed (which it should no longer be after my
% modifications on 2017-02-09), then remove those start/stop strobes.
if strobedStartStop
    strobe(1:strobeDown(7)+1) = 0;
    ae(1:strobeDown(7)+1) = 0;
    strobe(strobeUp(end)-1:end) = 0;
    ae(strobeUp(end)-1:end) = 0;
end

% Find indices of frame out.
frameOutChanged = find(diff(frameOut));
frameOutUp = frameOutChanged(1:2:end);

% Find frame time.
frameTime = time(frameOutUp);
frameTime = frameTime - frameTime(1);

% Find phase flip times.
phaseArray = zeros(length(time), 1);
phaseCode1 = 1;
phaseCode2 = 2;
swap = NaN;
for ii=1:length(strobeUp)-1
    phaseArray(strobeUp(ii):strobeUp(ii+1)) = phaseCode1;
    swap = phaseCode1;
    phaseCode1 = phaseCode2;
    phaseCode2 = swap;
end
phase = phaseArray(frameOutUp);

% Find bar positions.
barPos = ae(frameOutUp);

% Make a description.
barPosDesc = '`barPos` = {1 through 2.5 if horizontal; 3 through 4.5 if vertical.}\n';
phaseDesc = '`phase` = {0 if gray screen; 1 or 2 otherwise.}\n';
info = [barPosDesc phaseDesc];

% Save info.
saveFile = fullfile(sesDir, 'frameInfo.mat');
save(saveFile, 'frameTime', 'barPos', 'phase', 'info');

