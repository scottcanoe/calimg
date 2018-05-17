function [] = tss_save(parentDir, mov, extension, framesPerFile)
% TSS_SAVE(parentDir, mov)
% TSS_SAVE(parentDir, mov, extension)
% TSS_SAVE(parentDir, mov, extension, framesPerFile)

narginchk(2, 4);
if nargin == 2
    extension = '.tiff';
    framesPerFile = 1000;
elseif nargin == 3
    framesPerFile = 1000;
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

start = 1;
numFrames = size(mov, 1);
fileCount = 1;
nDigits = length(num2str(numFrames));
while true
    
    % Make filename with front-padded string of zeros.
    numString = num2str(fileCount);
    front = num2str(zeros(1, nDigits - length(numString)));
    front = front(find(~isspace(front)));
    filename = fullfile(parentDir, [front numString extension]);
    
    % Get chunk of movie and save it.
    stop = start + framesPerFile - 1;
    if stop >= numFrames
        tiffstack_save(filename, mov(start:end, :, :));
        break
    else
        tiffstack_save(filename, mov(start:stop, :, :));
    end
    start = start + framesPerFile;
    fileCount = fileCount + 1;
    
end

end