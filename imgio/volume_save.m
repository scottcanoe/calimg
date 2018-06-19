function [] = volume_save(parentDir, vol, extension)
% volume_save(parentDir, vol)
% volume_save(parentDir, vol, extension)
% volume extension is '.tiff'. '.tif' is also allowed.

% Handle argument patterns.
narginchk(2, 3);
if nargin == 2
    extension = '.tiff';
end

% Check extension.
if ~(strcmp(extension, '.tif') || strcmp(extension, '.tiff'))
    error(['Illegal extension ' extension ' for tiff files.']);
end

% Check parentDir doesn't already exist. Then create it.
parentDir = asdir(parentDir);
if exist(parentDir, 'dir')
    error(['directory ' parentDir ' already exists.']);
end
mkdir(parentDir);

% Write the files.
numFrames = size(vol, 3);
nDigits = length(num2str(numFrames));
for ii = 1:numFrames
    
    numString = num2str(ii);
    
    % Make front-padding string of zeros.
    front = num2str(zeros(1, nDigits - length(numString)));
    front = front(find(~isspace(front)));
    filename = fullfile(parentDir, [front numString extension]);
    imwrite(squeeze(vol(:, :, ii)), filename);
end

end