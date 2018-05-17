function info = h5_info(filename)
% H5_INFO(filename) returns a struct containing basic information about 
% an h5 movie file. The returned struct has the following fields:
%   frameSize : frame shape in pixels.
%   numFrames : the number of frames.
%   dtype : a char array describing the data type (e.g., 'uint16');
%   bytes : size of the file in bytes.
%   location : the path to the dataset contained in filename.

raw_info = h5info(filename);
dataset = raw_info.Datasets(1);
info = struct;
info.location = strcat('/', dataset.Name);
dshape = dataset.Dataspace.Size;
info.frameSize = [dshape(2) dshape(3)];
info.numFrames = dshape(1);

% Infer data type.
sample = h5read(filename, info.location, [1 1 1], [2 1 1]);
info.dtype = class(sample);

% Find size in bytes.
dirInfo = dir(filename);
info.bytes = dirInfo.bytes;
end

