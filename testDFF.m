% 
% a = 0.5 * ones(250, 512, 512) + 0.5 * randn([250, 512, 512]) + 0.5;
% a(a < 0) = 0;
% b = dFF(a);
% 
% figure
% plot(a(:, 10, 10), 'black')
% hold on
% plot(b(:, 10, 10), 'red')
mouse = '330873-A';
date = '2018-05-14';
expnum = '1';
numFrames = 1000;

mov = loadMov(mouse, date, expnum, numFrames);
mov = prepMov(mov);

frameInfo = loadFrameInfo(mouse, date, expnum);
frameInfo = frameInfo(1:numFrames);

frames = labelMov(mov, frameInfo);

% m = permute(mov, [2 3 1]);
implay(frames);