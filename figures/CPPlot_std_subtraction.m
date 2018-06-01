
% mouse = 'CP1';
% date = '2018-05-04';
% expnum = '1';
% rawMov = double(loadMov(mouse, date, expnum));
% frameInfo = loadFrameInfo(mouse, date, expnum);
% eventValues = extractfield(frameInfo, 'EventValue');
% 
% stimOff = find(eventValues == 1);
% stimOn = find(eventValues < 0.95);
% 
% movOff = rawMov(stimOff, :, :);
% movOffStd = squeeze(std(movOff, 0, 1));
% 
% movOn = rawMov(stimOn, :, :);
% movOnStd = squeeze(std(movOn, 0, 1));
% 
% tempOff = movOffStd - movOnStd;
% tempOn = movOnStd - movOffStd;
% movOffStd = tempOff;
% movOnStd = tempOn;
% 
% rawStd = squeeze(std(rawMov,0,1));
% save('plotdata.mat', 'rawStd', 'movOnStd');

%%
load plotdata.mat

rawStd = rawStd - min(min(rawStd));
rawStd = rawStd / max(max(rawStd));

threshold = 0.3;
stdMask = rawStd > threshold; % All puncta

onMask = movOnStd > threshold * max(max(movOnStd)); % Puncta on during stim
offMask = movOnStd < threshold * min(min(movOnStd)); % Puncta on during gray

allPunctaImage = zeros(size(onMask));
allPunctaImage(onMask) = 1;
allPunctaImage(offMask) = 2;
allPunctaImage(stdMask & ~(onMask | offMask)) = 3;

% Define values needed to make scale bar.
fovPix = 512;  % pixels in fov.
fovMic = 45;   % microns in fov.
micPerPix = fovMic/fovPix;
barLengthMic = 10;
barLengthPix = int32(round(barLengthMic/micPerPix));
xPad = 20;
yPad = 20;
lineWidth = 2;
xMid = xPad + barLengthMic/2;

% Make the figure.
figure
set(gcf, 'renderer', 'Painters');
ax1 = subplot(1, 2, 1);
im1 = imagesc(rawStd);
colormap(ax1, inferno);
colorbar
ax1.XTick = [];
ax1.YTick = [];
axis image

% Add scale bar
hold on
plot([xPad, barLengthPix], [fovPix-yPad, fovPix - yPad], ...
     'Color', 'w', 'LineWidth', lineWidth);

ax2 = subplot(1, 2, 2);
% allPunctaImage = medfilt2(allPunctaImage, [3 3]); % Optionally try to get rid of single-pixel puncta.
imagesc(allPunctaImage);
colorbar
ourColors = [rgb('white');
             rgb('medium blue');
             rgb('dark yellow');
             rgb('black')];
colormap(ax2, ourColors)
% title(sprintf('Both Mask thresh=%0.2f',threshold)); % Put title on with illustrator.
ax2.XTick = [];
ax2.YTick = [];
axis image

print(gcf, '/home/scott/CP.eps', '-depsc');
