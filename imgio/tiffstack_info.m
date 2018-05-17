function info = tiffstack_info(filename)

% TIFFSTACK_INFO(filename) returns a struct containing basic information about 
% a multiimage tiff. The returned struct has the following fields:
%   frameSize : frame shape in pixels.
%   numFrames : the number of frames.
%   dtype : a char array describing the data type (e.g., 'uint16');
%   bytes : size of the file in bytes.

raw_info = imfinfo(filename);
info = struct;

info.numFrames = length(raw_info);

% Infer data type.
sample = squeeze(imread(filename, 1));
info.frameSize = size(sample);
info.dtype = class(sample);

% Find size in bytes.
dirInfo = dir(filename);
info.bytes = dirInfo.bytes;
end
