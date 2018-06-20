function mov = tiffseries_read(parentDir, startFrame, stopFrame)
% TIFFSERIES_READ(parentDir)
% TIFFSERIES_READ(parentDir, numFrames)
% TIFFSERIES_READ(parentDir, startFrame, stopFrame)
% Supports negative indices for 'stopFrame', where -1 refers to the last
% frame. For example, tiffseries_read(filename, 50, -1) will read all frames
% from 50 until the end.

% Get info about tiff stack.
info = tiffseries_info(parentDir);
numTiffs = info.numFrames; 
d1 = info.frameSize(1);
d2 = info.frameSize(2);

if nargin == 1
    startFrame = 1;
    stopFrame = numTiffs;

elseif nargin == 2
    if startFrame <= 0
        error('Cannot read non-positive number of frames');
    end
    stopFrame = startFrame;
    startFrame = 1;
end

[startFrame, stopFrame] = sanitizeSlice(startFrame, stopFrame, numTiffs);
numToRead = stopFrame - startFrame + 1;
mov = zeros(numToRead, d1, d2, info.dtype);
counter = 1;
for ii = startFrame:stopFrame
    frame = imread(info.filenames{ii});
    mov(counter, :, :) = frame;
    counter = counter + 1;
end
mov = squeeze(mov);
end



