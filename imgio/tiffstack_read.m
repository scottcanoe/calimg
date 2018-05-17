function mov = tiffstack_read(filename, startFrame, stopFrame)
% TIFFSTACK_READ(filename)
% TIFFSTACK_READ(filename, numFrames)
% TIFFSTACK_READ(filename, startFrame, stopFrame)
% Supports negative indices for 'stopFrame', where -1 refers to the last
% frame. For example, tiffseries_read(filename, 50, -1) will read all frames
% from 50 until the end.

narginchk(1, 3)

info = tiffstack_info(filename);
numFrames = info.numFrames;

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
tsStack = TIFFStack(filename);
mov = permute(tsStack(:, :, startFrame:stopFrame), [3 1 2]);
mov = squeeze(mov);
end

