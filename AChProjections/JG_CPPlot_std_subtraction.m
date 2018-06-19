
%%
mouse = 'CP1';
date = '2018-06-13';
expnum = '1';
mov = double(loadMov(mouse, date, expnum));
frameInfo = loadFrameInfo(mouse, date, expnum);
ix_start = 5000 + 800;
ix_stop = 10000 + 3800;
mov = mov(ix_start:ix_stop, :, :);
frameInfo = frameInfo(ix_start:ix_stop);
eventValues = extractfield(frameInfo, 'EventValue');

%%
stimOff = find(eventValues == 0);
stimOn = find(eventValues > 0);

movOff = mov(stimOff, :, :);
movOffStd = squeeze(std(movOff, 0, 1));

movOn = mov(stimOn, :, :);
movOnStd = squeeze(std(movOn, 0, 1));

tempOff = movOffStd - movOnStd;
tempOn = movOnStd - movOffStd;
movOffStd = tempOff;
movOnStd = tempOn;

rawStd = squeeze(std(mov,0,1));
save('plotdata.mat', 'rawStd', 'movOnStd');

%%
load plotdata.mat

thresholds = [0.2, 0.3, 0.4];

for iT = 1:length(thresholds)
    
    threshold = thresholds(iT);
    
    disp(['Threshold = ' num2str(threshold)]);
    
    rawStd = rawStd - min(min(rawStd));
    rawStd = rawStd / max(max(rawStd));
    
    stdMask = rawStd > threshold; % All puncta
    
    onMask = movOnStd > 0.25 * max(max(movOnStd)); % Puncta on during stim
    offMask = movOnStd < 0.25 * min(min(movOnStd)); % Puncta on during gray
    
    %%
    minPixels = 5;
    onROI = roiFromBinaryMask(onMask,minPixels);
    offROI = roiFromBinaryMask(offMask,minPixels);
    stdROI = roiFromBinaryMask(stdMask,minPixels);
    bothROI = findUniqueROIS(stdROI,onROI,offROI);
    
    
    %%
    
    allPunctaImage = zeros(size(onMask));
    allPunctaImage(onROI.ROIImage > 0) = 1;
    allPunctaImage(offROI.ROIImage > 0) = 2;
    allPunctaImage(bothROI.ROIImage > 0) = 3;
    
    % Define values needed to make scale bar.
    fovPix = 512;  % pixels in fov.
    fovMic = 412.22;   % microns in fov.
    micPerPix = fovMic/fovPix;
    barLengthMic = 100;
    barLengthPix = int32(round(barLengthMic/micPerPix));
    xPad = 20;
    yPad = 20;
    lineWidth = 2;
    xMid = xPad + barLengthMic/2;
    
    % Make the figure.
    fh = figure('NumberTitle','off',...
        'Name',sprintf('Threshold = %0.2f',threshold));
    p = get(0,'screensize');
    wh = [0.6 0.6].*p(3:4);
    xy0 = p(1:2)+0.5*p(3:4) - wh/2;
    set(fh,'position', [xy0 wh]);
    set(fh,'Units','Normalized','renderer', 'Painters');
    
    ax1 = axes('Position',[0.05 0.05 (0.5-0.05/2-0.05) 0.9]);
    
    imagesc(rawStd);
    colormap(ax1, gray);
    %colorbar
    ax1.XTick = [];
    ax1.YTick = [];
    axis image
    
    % Add scale bar
    hold on
    plot([xPad, barLengthPix], [fovPix-yPad, fovPix - yPad], ...
        'Color', 'w', 'LineWidth', lineWidth);
    text(double(xPad),double(fovPix-2.5*yPad),...
        [num2str(barLengthMic) ' \mum'],'Color',[1 1 1],'FontSize',20);
    
    ax2 = axes('Position',[0.5+0.05/2 0.05 (0.5-0.05/2-0.05) 0.9]);
    
    % title(sprintf('Both Mask thresh=%0.2f',threshold)); % Put title on with illustrator.
    ax2.XTick = [];
    ax2.YTick = [];
    axis image
    
    hold(ax2,'on');
    for iR = 1:onROI.NumObjects
        roi = onROI.PixelIdxList{iR};
        [y,x] = ind2sub(onROI.ImageSize,roi);
        bound = boundary(x,y);
        pOn = patch(x(bound),y(bound),rgb('CornflowerBlue'));
        pOn.LineStyle = 'none';
    end
    
    for iR = 1:offROI.NumObjects
        roi = offROI.PixelIdxList{iR};
        [y,x] = ind2sub(offROI.ImageSize,roi);
        bound = boundary(x,y);
        pOff = patch(x(bound),y(bound),rgb('FireBrick'));
        pOff.LineStyle = 'none';
    end
    
    for iR = 1:bothROI.NumObjects
        roi = bothROI.PixelIdxList{iR};
        [y,x] = ind2sub(bothROI.ImageSize,roi);
        bound = boundary(x,y);
        pBoth = patch(x(bound),y(bound),rgb('LimeGreen'));
        pBoth.LineStyle = 'none';
    end
    ax2.XLim = ax1.XLim;
    ax2.YLim = ax1.YLim;
    ax2.YDir = 'reverse';
    
    legPlots = [pOn pOff pBoth];
    legStrs = {sprintf('On (n=%i)',onROI.NumObjects),...
        sprintf('Off (n=%i)',offROI.NumObjects),...
        sprintf('Both (n=%i)',bothROI.NumObjects)};
    legend(ax2, legPlots,legStrs,'Location','West','AutoUpdate','off',...
        'FontSize',20,'Position',[0.8545,0.8953,0.0944,0.0891])
    
    % Add scale bar
    hold on
    plot(ax2,[xPad, barLengthPix], [fovPix-yPad, fovPix - yPad], ...
        'Color', 'k', 'LineWidth', lineWidth);
    text(ax2,double(xPad),double(fovPix-2.5*yPad),...
        [num2str(barLengthMic) ' \mum'],'Color',[0 0 0],'FontSize',20);
    
    outfile = sprintf('CP_thresh-%0.2f.eps',threshold);
    print(fh,outfile,'-depsc');
    movefile(outfile,'EPS Images')
    
    
    %%
    
    % Make the figure.
    fh = figure('NumberTitle','off',...
        'Name',sprintf('Threshold = %0.2f',threshold));
    p = get(0,'screensize');
    wh = [0.4 0.6].*p(3:4);
    xy0 = p(1:2)+0.5*p(3:4) - wh/2;
    set(fh,'position', [xy0 wh]);
    set(fh,'Units','Normalized','renderer', 'Painters');
    
    imagesc(rawStd);
    ax1 = gca;
    colormap(ax1, gray);
    ax1.XTick = [];
    ax1.YTick = [];
    axis image
    
    hold(ax1,'on');
    
    for iR = 1:onROI.NumObjects
        roi = onROI.PixelIdxList{iR};
        [y,x] = ind2sub(onROI.ImageSize,roi);
        bound = boundary(x,y);
        pOn = plot(x(bound),y(bound),'color',rgb('Cyan'));
    end
    
    for iR = 1:offROI.NumObjects
        roi = offROI.PixelIdxList{iR};
        [y,x] = ind2sub(offROI.ImageSize,roi);
        bound = boundary(x,y);
        pOff = plot(x(bound),y(bound),'color',rgb('Red'));
    end
    
    for iR = 1:bothROI.NumObjects
        roi = bothROI.PixelIdxList{iR};
        [y,x] = ind2sub(bothROI.ImageSize,roi);
        bound = boundary(x,y);
        pBoth = plot(x(bound),y(bound),'color',rgb('Yellow'));
    end
    
    set(findobj(fh,'Type','Line'),'LineWidth',2);
    legPlots = [pOn pOff pBoth];
    legStrs = {sprintf('On (n=%i)',onROI.NumObjects),...
        sprintf('Off (n=%i)',offROI.NumObjects),...
        sprintf('Both (n=%i)',bothROI.NumObjects)};
    legend(legPlots,legStrs,'Location','EastOutside','AutoUpdate','off',...
        'FontSize',20)
    
    % Add scale bar
    plot([xPad, barLengthPix], [fovPix-yPad, fovPix - yPad], ...
        'Color', 'w', 'LineWidth', lineWidth);
    text(double(xPad),double(fovPix-2.5*yPad),...
        [num2str(barLengthMic) ' \mum'],'Color',[1 1 1],'FontSize',20);
    
    outfile = sprintf('OL_thresh-%0.2f.eps',threshold);
    print(fh,outfile,'-depsc');
    movefile(outfile,'EPS Images')
    
    
    %%
    
    % Make the figure.
    fh = figure('NumberTitle','off',...
        'Name',sprintf('Threshold = %0.2f',threshold));
    p = get(0,'screensize');
    wh = [0.4 0.6].*p(3:4);
    xy0 = p(1:2)+0.5*p(3:4) - wh/2;
    set(fh,'position', [xy0 wh]);
    set(fh,'Units','Normalized','renderer', 'Painters');
    
    imagesc(rawStd);
    ax1 = gca;
    colormap(ax1, gray);
    ax1.XTick = [];
    ax1.YTick = [];
    axis image
    
    hold(ax1,'on');
    
    for iR = 1:stdROI.NumObjects
        roi = stdROI.PixelIdxList{iR};
        [y,x] = ind2sub(stdROI.ImageSize,roi);
        bound = boundary(x,y);
        pStd = plot(x(bound),y(bound),'color',rgb('Cyan'));
    end
    
    set(findobj(fh,'Type','Line'),'LineWidth',2);
    
    % Add scale bar
    plot([xPad, barLengthPix], [fovPix-yPad, fovPix - yPad], ...
        'Color', 'w', 'LineWidth', lineWidth);
    text(double(xPad),double(fovPix-2.5*yPad),...
        [num2str(barLengthMic) ' \mum'],'Color',[1 1 1],'FontSize',20);
    
    outfile = sprintf('STD_thresh-%0.2f.eps',threshold);
    print(fh,outfile,'-depsc');
    movefile(outfile,'EPS Images')
    
end
