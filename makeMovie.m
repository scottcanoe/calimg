mouse = 'CP1';
date = '2018-06-12';
expnum = '1';

% rawmov = loadMov(mouse, date, expnum);
% frameInfo = loadFrameInfo(mouse, date, expnum);
% seqType = 'random drifting gratings';
% 
% mov = prepMov(rawmov);
% frames = labelMov(mov, frameInfo, seqType);

v = VideoWriter('CP1_random_drifting_gratings.avi', 'Motion JPEG AVI');
v.FrameRate = 30;
open(v);
for ii=1:size(mov,1)
    writeVideo(v, frames(ii).cdata);
end
close(v);
