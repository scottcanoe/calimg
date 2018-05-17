mouse = '328890-B';
date = '2018-03-07';
expnum = '1';
traces = getTraces(mouse, date, expnum);
netMean = mean(traces, 1);

sd = loadSyncData(mouse, date, expnum);

frameTrigger = sd('FrameTrigger');
frameTriggerUp = find(diff(frameTrigger));
expStart = frameTrigger(1);

strobes = sd('Strobe');
strobeUp = find(diff(strobes));
strobeUp = strobeUp(strobeUp > expStart);

frameOut = sd('FrameOut');
frameOutUp = find(diff(frameOut));

time = sd('time');
time = time(frameOutUp);
time = time - time(1);

ae = sd('AnalogEvents');
ae = ae(frameOutUp);

maxFrames = min([length(netMean) length(time)]);
time = time(1:maxFrames);
netMean = netMean(1:maxFrames);
ae = ae(1:maxFrames);
frameOut = frameOut(1:maxFrames);
traces = traces(:, 1:maxFrames);

netMean = netMean - min(netMean);
netMean = netMean / max(netMean);

% Divide into stimOn/stimOff periods.
stimMeans = zeros(length(netMean));
numStims = 0;
grayMeans = zeros(length(netMean));
numGrays = 0;

for ii=1:length(netMean)
    stimLevel = ae(ii);
    if ae(ii) > 0.5
        stimMeans(numStims + 1) = netMean(ii);
        numStims = numStims + 1;
    else
        grayMeans(numGrays + 1) = netMean(ii);
        numGrays = numGrays + 1;
    end
end

stimMeans = stimMeans(1:numStims);
grayMeans = grayMeans(1:numGrays);

meanStim = mean(stimMeans);
meanGray = mean(grayMeans);

stim = ae;
stim(stim > 1) = 1;

plot(time, netMean);
hold on;
plot(time, stim);