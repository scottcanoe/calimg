function info = volume_info(parentDir)
% tiffseries_info(parentDir) returns a struct containing basic information about 
% a series of single-page tiffs. The returned struct has the following fields:
%   frameSize : size of frame (pixels).
%   numFrames : the number of frames (i.e., the number of tiffs).
%   dtype : a char array describing the data type (e.g., 'uint16');
%   bytes : size of all tiffs on disk together.
%   filenames : File paths.

narginchk(1, 1);
info = tiffseries_info(parentDir);

end