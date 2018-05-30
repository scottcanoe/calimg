% 
% mouse = 'CP1';
% dates = {'2018-05-01', '2018-05-04'};
% seqSpecs = sequenceSpecs;
% clear S
% S = struct;
% activeEventValues = seqSpecs.EventValues(2:6);
% activeLabels = seqSpecs.Labels(2:6);
% 
% for ii=1:2
%     mov = double(loadMov(mouse, dates{ii}, '1'));
%     numYPix = size(mov, 2);
%     numXPix = size(mov, 3);
%     
%     S(ii).frameInfo = loadFrameInfo(mouse, dates{ii}, '1');
%     
%     eventValues = extractfield(S(ii).frameInfo, 'EventValue');
%     
%     S(ii).movies = {[], [], [], [], []};
%     S(ii).labels = {};
%     
%     % Collect indices.
%     for jj = 1:length(activeEventValues)
%         
%         curEventValue = activeEventValues(jj);
%         if isclose(curEventValue, 1.0)
%             isGray = true;
%         else
%             isGray = false;
%         end
%         curLabel = activeLabels{jj};
%         
%         ixStruct = getElementIndices(eventValues, activeEventValues(jj));
%     
%         % Make it so each set of indices is only as long as its shortest seq.
%         if ~isGray
%             N = min(arrayfun(@(s)length(s.ix), ixStruct));
%             for kk=1:length(ixStruct)
%                 ixStruct(kk).ix = ixStruct(kk).ix(1:N);
%             end
%         else
%             N = 4;
%         end
%         
%         % Collect frames.
%         myMov = zeros(N, numYPix, numXPix, 'double');
%         for frameNum=1:N
%             frameIndices = arrayfun(@(s)s.ix(frameNum), ixStruct);
%             frames = mov(frameIndices, :, :);
%             meanFrame = squeeze(mean(frames, 1));
%                         
%             % Store frame and label.
%             myMov(frameNum, :, :) = meanFrame;
%             S(ii).labels{length(S(ii).labels)+1} = curLabel;
%             
%         end
%         
%         % Store movie.
%         S(ii).movies{jj} = myMov;
%         
%     end
%     
%     % Make a master movie.
%     numFrames = sum(cellfun(@(m)size(m, 1), S(ii).movies));
%     S(ii).mov = zeros(numFrames, numYPix, numXPix);
%     count = 1;
%     for jj=1:length(S(ii).movies)
%         myMov = S(ii).movies{jj};
%         for kk=1:size(myMov, 1)
%             S(ii).mov(count, :, :) = myMov(kk, :, :);
%             count = count + 1;
%         end
%     end
%     
% end
%
% save('S.mat', 'S');

S = load('S.mat', 'S');
S = S.S;

for ii=1:2
    mov = prepMovie(S(ii).mov);
    mov = dFF(mov);
    labeledMov = zeros([size(mov) 3]);
    for kk=1:length(S(ii).labels)
        frame = squeeze(mov(kk, :, :));
        frame = insertText(frame, [10 10], S(ii).labels{kk}, ...
                           'FontSize', 32);
        labeledMov(kk, :, :, :) = frame;
    end
    S(ii).labeledMov = labeledMov;
end

lm1 = S(1).labeledMov;
lm2 = S(2).labeledMov;

fig = figure;

ax1 = subplot(1, 2, 1);
im1 = image(ax1, squeeze(lm1(1, :, :, :)));
pbaspect(ax1, [1 1 1]);
title(ax1, 'ABCD Day 1');

ax2 = subplot(1, 2, 2);
im2 = image(ax2, squeeze(lm2(1, :, :, :)));
pbaspect(ax2, [1 1 1]);
title(ax2, 'ABCD Day 4');

v = VideoWriter('ABCD.avi', 'Motion JPEG AVI');
v.FrameRate = 1;
open(v);

numFrames = size(lm1, 1);
for ii=1:numFrames
    im1.CData = squeeze(lm1(ii, :, :, :));
    im2.CData = squeeze(lm2(ii, :, :, :));
    F = getframe(fig);
    writeVideo(v, F);
end

close(v);




