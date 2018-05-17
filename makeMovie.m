mouse = 'Cambria';
date = '2018-05-04';
expnum = '3';

tiffsDir = fullfile(s2p.registrationRoot, mouse, date, expnum, 'Plane1');
fname = [date '_' expnum '_' mouse '_2P_plane1_1.tif'];
rawmov = tiffstack_read(fullfile(tiffsDir, fname));

% Rescale.
mov = double(rawmov);
maxval = prctile(mov(:), 98);
mov = mov/maxval;
mov(mov>1) = 1;

% Smooth.
mov = smooth3(mov, 'box', [5 1 1]);
if exist('movie.avi', 'file')
    delete('movie.avi');
end
outFile = '/home/scott/Movies/';
outFile = [outFile mouse '_' date '_' expnum '.avi'];
v = VideoWriter(outFile, 'Motion JPEG AVI');
v.FrameRate = 30;
open(v);
for ii=1:size(mov,1)
    frame = squeeze(mov(ii, :, :));
    writeVideo(v, frame);
end
close(v);

