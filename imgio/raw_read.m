function mov = raw_read(filename, startFrame, stopFrame)

narginchk(1, 3)

% Get info about dataset to read.
info = raw_info(filename);
numFrames = info.numFrames;
numXPix = info.frameSize(2);
numYPix = info.frameSize(1);
dataChunkSize = numXPix * numYPix;

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

% Seek past non-requested frames.
curFrame = 1;
fid = fopen(filename);
while curFrame < startFrame
    fseek(fid, 2 * dataChunkSize, 0);
    curFrame = curFrame + 1;
end

% Load frames.
mov = zeros(stopFrame-startFrame, numYPix, numXPix, 'uint16');
ix = 1;
while curFrame < stopFrame
        % Read frame data.
    frame = uint16(fread(fid, dataChunkSize, 'uint16', 0, 'l'));
    
    % Reshape it into 2D array.
    frame = reshape(frame, numXPix, numYPix);
    
    % Flip and rotate to get correct orientation.
    frame = fliplr(rot90(frame, -1));
    
    % Finally, add the frame and increment counters.
    mov(ix, :, :) = frame;
    ix = ix + 1;
    curFrame = curFrame + 1;
    
end

