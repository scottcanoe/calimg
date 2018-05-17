function numTimepoints = numFramesInRawFile(mouse, date, expnum)

narginchk(3, 3);

% Check existence.
expnum = num2str(expnum);
sesDir = sessiondir(mouse, date, expnum);
files = dir(fullfile(sesDir, 'Image*.raw'));
filename = fullfile(sesDir, files(1).name);

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

if or(numZSlices ~= 1, numChannels ~= 1)
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

