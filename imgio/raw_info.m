function info = raw_info(filename)

% RAW_INFO(filename) returns a struct containing basic information about 
% a Thorlabs raw image file. The returned struct has the following fields:
%   frameSize : frame shape in pixels.
%   numFrames : the number of frames.
%   dtype : a char array describing the data type (e.g., 'uint16');
%   bytes : size of the file in bytes.

% Separate the provided filename into parts, and find associated XML file.
filename = abspath(filename);
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

if or(numZSlices ~= 1, numChannels ~= 1)
    msg = 'imgio currently only supports single-plane, single-channel';
    msg = [msg ' movies when using raw format.'];
    error(msg);
end

% Infer number of time points.
fileInfo = dir(filename);
fileBytes = fileInfo.bytes;
bytesPerFrame = 2 * numXPix * numYPix;
numTimepoints = uint16(fileBytes/bytesPerFrame);

info.frameSize = [numYPix numXPix];
info.numFrames = numTimepoints;
info.dtype = 'uint16';
info.bytes = fileBytes;

end

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