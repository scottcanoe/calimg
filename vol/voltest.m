% V = volume_read(fullfile(dataroot, 'vol1'));
% refVol = V(125:387, 125:387, 80:120);
% volume_save(fullfile(dataroot, 'refVol'), refVol);


xOffset = 0; % in microns.
yOffset = 0;  % in microns.
zOffset = -10;  % in microns.

pixelSizeUM = 0.805;
stepSizeUM = 0.5;

xOffset = int32(xOffset/pixelSizeUM);
yOffset = int32(yOffset/pixelSizeUM);
zOffset = int32(zOffset/stepSizeUM);

testVol = V(125 + yOffset : 387 + yOffset, ...
            125 + xOffset : 387 + xOffset, ...
             80 + zOffset : 120 + zOffset);
parentDir = fullfile(dataroot, 'testVol');
rmdir(parentDir, 's');
volume_save(parentDir, testVol);
copyfile(fullfile(dataroot, 'Experiment.xml'), parentDir);