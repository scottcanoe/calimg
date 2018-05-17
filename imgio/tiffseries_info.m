function info = tiffseries_info(parentDir)
% tiffseries_info(parentDir) returns a struct containing basic information about 
% a series of single-page tiffs. The returned struct has the following fields:
%   frameSize : size of frame (pixels).
%   numFrames : the number of frames (i.e., the number of tiffs).
%   dtype : a char array describing the data type (e.g., 'uint16');
%   bytes : size of all tiffs on disk together.
%   filenames : File paths.

if nargin == 0
    error('Not enough input arguments');
end


% Make sure parentDir has a trailing backslash.
parentDir = asdir(parentDir);

% Find files with both extensions '.tif' and '.tiff'.
files = [dir([parentDir '*.tif']); dir([parentDir '*.tiff'])];

% Get all file names into a cell array, and add up bytes.
numFrames = length(files);
filenames = cell(numFrames, 1);
numBytes = 0;
for ii = 1:numFrames
    f = files(ii);
    numBytes = numBytes + f.bytes;
    filenames{ii} = f.name;
end

% Convert filenames into full path filenames.
filenames = humanSort(filenames);
for ii=1:numFrames
    f = filenames{ii};
    filenames{ii} = [parentDir f]; 
end

% Read one file to find the image shape and dtype.
frame = imread(filenames{ii});

% Create the info struct.
info = struct();
info.frameSize = size(frame);
info.numFrames = numFrames;
info.dtype = class(frame);
info.bytes = numBytes;
info.filenames = filenames;

end

