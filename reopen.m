
mouse = '330873-A';
date = '2018-05-14';
expnum = '1';
% mov = tss_read(fullfile(dataroot, mouse, date, expnum, 'mov'));

if exist('m', 'var')
    delete(m)
end
startFrame = 1;
stopFrame = 250;
% mov = mov(startFrame:stopFrame, :, :);

m = MovieViewer('manual');
m.chooseSessionManually('local', mouse, date, expnum, ...
                         startFrame, stopFrame, mov);

