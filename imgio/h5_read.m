function mov = h5_read(filename, startFrame, stopFrame)
% H5_READ(filename)
% H5_READ(filename, numFrames)
% H5_READ(filename, startFrame, stopFrame)
% Supports negative indexing.

narginchk(1, 3)

% Get info about dataset to read.
info = h5_info(filename);
numFrames = info.numFrames;
d1 = info.frameSize(1);
d2 = info.frameSize(2);

if nargin == 1
    startFrame = 1;
    stopFrame = numFrames;

elseif nargin == 2
    if startFrame <= 0
        error('Cannot read non-positive number of frames');
    end
    stopFrame = startFrame;
    startFrame = 1;
end

[startFrame, stopFrame] = sanitizeSlice(startFrame, stopFrame, numFrames);
count = stopFrame - startFrame + 1;
mov = squeeze(h5read(filename, info.location, [startFrame 1 1], [count d1 d2]));

end

