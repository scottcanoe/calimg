
numFrames = 50;
numYPix = 256;
numXPix = 512;
mov = zeros([numFrames, numYPix, numXPix], 'uint16');
for ii=1:numFrames
    mov(ii, :, :) = ii * ones([numYPix, numXPix]);
end