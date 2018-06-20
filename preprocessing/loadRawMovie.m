function imData = loadRawMovie(arg1, arg2, arg3)
% LOADRAWMOVIE Returns a 3D array of movie data indexed like (T,Y,X). 
% 'FrameTrigger', and 'Strobes' are also available.
% LOADRAWMOVIE Prompts user to select a raw image file with uigetfile.
% LOADRAWMOVIE(filename) Call with path to raw image file.
% LOADRAWMOVIE(mouse, date, expnum) Call using mouse/date/expnum pattern.

if nargin == 0
    [file, path] = uigetfile(fullfile(dataroot, 'Image*.raw'));
    filename = fullfile(path, file);
elseif nargin == 1
    filename = arg1;
elseif nargin == 3
    mouse = arg1;
    date = arg2;
    expnum = num2str(arg3);
    sesDir = sessiondir(mouse, date, expnum);
    files = dir(fullfile(sesDir, 'Image*.raw'));
    filename = fullfile(sesDir, files(1).name);
else
    error('Bad arg structure.');
end

% Separate the provided filename into parts, and find associated XML file.
[parentDir, ~, ~] = fileparts(filename);
xmlFilename = fullfile(parentDir, 'Experiment.xml');
if ~exist(xmlFilename, 'file')
    error('Cannot find associated Experiment.xml file.');
end
imInfo = xml2struct(xmlFilename);

% Determine image file information from metadata
numXPix = str2num(imInfo.ThorImageExperiment.LSM.Attributes.pixelX);
numYPix = str2num(imInfo.ThorImageExperiment.LSM.Attributes.pixelY);
numZSlices = str2num(imInfo.ThorImageExperiment.ZStage.Attributes.steps);
activeChannels = de2bi_tl(str2num(imInfo.ThorImageExperiment.Wavelengths.ChannelEnable.Attributes.Set));
activeChannelsList = find(activeChannels==1);
numChannels = sum(activeChannelsList);
captureMode = str2num(imInfo.ThorImageExperiment.CaptureMode.Attributes.mode);

if or(captureMode ~= 1, numChannels ~= 1)
    msg = 'This function currently only supports single-plane, single-channel';
    msg = [msg ' movies. Fall back on original Thorlabs scripts.'];
    error(msg);
end

% Infer number of time points.
fileInfo = dir(filename);
fileBytes = fileInfo.bytes;
bytesPerFrame = 2 * numXPix * numYPix;
numTimepoints = uint16(fileBytes/bytesPerFrame);
if rem(fileBytes, bytesPerFrame) ~= 0
    error('Problem with number of bytes...');
end

% % Prepare to start reading data from the file.
fid = fopen(filename);

% % Create storage array to hold data as it is read out.
imData = zeros(numTimepoints, numYPix, numXPix, 'uint16');
dataChunkSize = numXPix * numYPix;
tic
for ii = 1:numTimepoints
    
    % Read frame data.
    frame = uint16(fread(fid, dataChunkSize, 'uint16', 0, 'l'));
    
    % Reshape it into 2D array.
    frame = reshape(frame, numXPix, numYPix);
    
    % Flip and rotate to get correct orientation.
    frame = fliplr(rot90(frame, -1));
    
    % Add frame to movie array.
    imData(ii, :, :) = frame;
end
toc
% Close file now that readout is completed.
fclose(fid);

% End of experiment readout function.
end

%------------------------------------------------------------------------------%


function [output] = de2bi_tl(input)
    % Function to convert a decimal number to a binary array

    % Check if input is decimal 0. If so, return 'false'
    if input == 0
        output=false;
        return
    end

    % Make sure input is a positive integer. If not, return error.
    if input ~= abs(round(input))
        error('Input must be a non-negative integer. Returning output = NaN');
        output = NaN;
        return
    end

    % Determine how many bytes will be required to store result.
    maxPower = floor(log2(input));

    %Create logical array for output
    output = false(1, maxPower);

    %Determine highest possible relevent power of two
    testPower = maxPower;

    %Loop to count off the highest powers on down to the lowest power.
    inputTemp = input;
    for I = maxPower:-1:0
        if inputTemp>=2^I
            output(I+1) = 1;
            inputTemp = inputTemp-2^I;
            if inputTemp == 0
                break
            end
        end
    end
end
% End of de2bi_tl code

