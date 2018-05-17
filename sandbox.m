mouse = '330873-A';
date = '2018-05-14';
expnum = '1';
stimCodes = (0:15)*(0.2);
createFrameInfo(mouse, date, expnum, 'StimCodes', stimCodes);

fname = fullfile(dataroot, mouse, date, expnum, 'frameInfo.mat');
clear frameInfo;
load(fname)
v = extractfield(frameInfo, 'Voltage');
c = extractfield(frameInfo, 'StimCode');

sd = loadSyncData(mouse,date,expnum);
ae = sd('AnalogEvents');
strobes = sd('Strobe');