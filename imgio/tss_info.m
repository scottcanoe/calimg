function varargout = tss_info(parentDir)
% tiffseries_info(parentDir) Returns a struct containing basic information about 
% a series of multi-page tiffs. The returned struct has the following fields:
%   frameSize : frame shape (pixels).
%   numFrames : the number of frames across all files.
%   dtype : a char array describing the data type (e.g., 'uint16');
%   bytes : size of all tiffs on disk together.
%   filenames : absolute paths to files.
%
% collectiveInfo = TIFFSERIES(__)
% [collectiveInfo, individualInfos] = TIFFSERIES(___)
% Make sure parentDir has a trailing backslash.
parentDir = asdir(parentDir);

% Find files with both extensions '.tif' and '.tiff'.
files = [dir(fullfile(parentDir, '*.tif')) ...
         dir(fullfile(parentDir, '*.tiff'))];

% Get all file names into a cell array, and add up bytes.
numStacks = length(files);
if numStacks == 0
    error('No tiffs in this directory');
end

filenames = cell(numStacks, 1);
numBytes = 0;
for ii = 1:numStacks
    f = files(ii);
    numBytes = numBytes + f.bytes;
    filenames{ii} = f.name;
end

% Convert filenames into full path filenames.
filenames = humanSort(filenames);
for ii=1:length(filenames)
    f = filenames{ii};
    filenames{ii} = abspath([parentDir f]);
end

% Get info for each one.
indivInfos = struct('frameSize', {}, ...
                    'numFrames', {}, ...
                    'dtype', {}, ...
                    'bytes', {});
             
for ii = 1:length(filenames)
    indivInfos(ii) = tiffstack_info(filenames{ii});
end

info.frameSize = indivInfos(1).frameSize;
info.numFrames = sum(extractfield(indivInfos, 'numFrames'));
info.dtype = indivInfos(1).dtype;
info.bytes = sum(extractfield(indivInfos, 'bytes'));
info.filenames = filenames;

varargout{1} = info;
if nargout == 2
    varargout{2} = indivInfos;
end

end