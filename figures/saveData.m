numTimepoints = 3000;
sesDir = sessiondir('328890-C', '2017-12-21', 3);
sd = loadSyncData(fullfile(sesDir, 'Episode001.h5'));
time = sd('time');
frameOut = sd('Frame Out');
strobes = sd('Strobe');

% Zero out strobes during calibration sequence.
strobes(1:1.32e5) = 0;

strobeUp = find(diff(strobes));
midPoints = zeros(1, length(strobeUp)-1);
for ii = 1:length(strobeUp)-1
    a = strobeUp(ii); b = strobeUp(ii+1);
    midPoints(ii) = uint32(a + (b-a)/2);
end

ae = zeros(1, length(frameOut));
for ii = 1:length(midPoints)-1
    a = midPoints(ii); b = midPoints(ii+1);
    m = 1/(b-a);
    X = 1:(b-a);
    Y = m*X;
    ae(a:b-1) = Y;
end

stimulus = zeros(1, numTimepoints);
frameTime = zeros(1, numTimepoints);
frameOutUp = find(diff(frameOut));
for ii = 1:numTimepoints
    stimulus(ii) = ae(frameOutUp(ii));
    frameTime(ii) = time(frameOutUp(ii));
end

% Shift 't' so t0 is at first frame capture.
frameTime = frameTime - frameTime(1);
% plot(strobes, 'b');
% hold on
% plot(frameOutUp, sig, 'r');

save('signals.mat', 'frameTime', 'stimulus');
% save('frame.mat'
