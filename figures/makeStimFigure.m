
mouse = '328890-B';
date = '2018-03-07';
expnum = '1';
procmat = loadProcMat(mouse, date, expnum);

% Load traces and sort by skewness.
rawTraces = dFF(getTraces(procmat));
IDs = 1:size(rawTraces, 1);
[traces, ix_sort] = sortTraces(rawTraces, 'skew');
IDs = IDs(ix_sort);
traces = traces(1:200, :);
IDs = IDs(1:200);

% Load sync data, and so some trimming.
syncData = loadSyncData(mouse, date, expnum);
[time, analogEvents, traces] = alignAnalogEventsAndTraces(syncData, traces);
stimCodes = [0.0, 1.0, 1.5, 2.0, 2.5, 3.0, 3.5, 4.0, 4.5];
analogEvents = digitizeAnalogEvents(analogEvents, stimCodes);

% Look at orientations only (not drift direction).
analogEvents(analogEvents == 1.5) = 1;
analogEvents(analogEvents == 2.5) = 2;
analogEvents(analogEvents == 3.5) = 3;
analogEvents(analogEvents == 4.5) = 4;

% Make on/off signals per stimulus orientation.
ae1 = zeros(size(analogEvents));
ae1(analogEvents == 1) = 1;
ae1cl = rgb('light blue');

ae2 = zeros(size(analogEvents));
ae2(analogEvents == 2) = 1;
ae2cl = rgb('light green');

ae3 = zeros(size(analogEvents));
ae3(analogEvents == 3) = 1;
ae3cl = rgb('light red');

ae4 = zeros(size(analogEvents));
ae4(analogEvents == 4) = 1;
ae4cl = rgb('light gray');

aeStim = analogEvents;
aeStim(aeStim >= 1) = 1;

% Find orientation-tuned cells.
[traces1, sort_ix1] = sortByStim(traces, ae1);
IDs1 = IDs(sort_ix1);

[traces2, sort_ix2] = sortByStim(traces, ae2);
IDs2 = IDs(sort_ix2);

[traces3, sort_ix3] = sortByStim(traces, ae3);
IDs3 = IDs(sort_ix3);

[traces4, sort_ix4] = sortByStim(traces, ae4);
IDs4 = IDs(sort_ix4);

[tracesStim, sort_ixStim] = sortByStim(traces, aeStim);
IDsStim = IDs(sort_ixStim);    

IDs0 = [119, 114, 133, 168, 179];
traces0 = zeros([length(IDs0), size(rawTraces, 2)]);
for ii=1:length(IDs0)
    traces0(ii, :) = rawTraces(IDs0(ii), :);
end
[~, ~, traces0] = alignAnalogEventsAndTraces(syncData, traces0);

fig = figure;
set(gcf, 'renderer', 'Painters');


numPlots = 5;
tmin = 200;
tmax = 400;
nStart = 0;
activeTraces = normalizeTraces(tracesStim);
activeIDs = IDsStim;

for ii=1:numPlots
    subplot(numPlots, 1, ii);
    axis tight;
    area(time, ae1, 'EdgeColor', ae1cl, 'FaceColor', ae1cl);
    hold on;
    area(time, ae2, 'EdgeColor', ae2cl, 'FaceColor', ae2cl);
    area(time, ae3, 'EdgeColor', ae3cl, 'FaceColor', ae3cl);
    area(time, ae4, 'EdgeColor', ae4cl, 'FaceColor', ae4cl);
    %plot(time, activeTraces(ii + nStart, :), 'k');
    plot(time, activeTraces(ii, :), 'k');
    hold off;
    
    xlim([tmin, tmax]);
    if ii ~= numPlots
        xticks([]);
        xticklabels([]);
    else

    end
    cellID = activeIDs(ii + nStart);
    yticks([]);
    yticklabels([]);
end
print(gcf, '/home/scott/plot.eps', '-depsc');





