function mov = tss_read(parentDir, startFrame, stopFrame)
% TSS_READ(filename)
% TSS_READ(filename, numFrames)
% TSS_READ(filename, startFrame, stopFrame)

narginchk(1, 3)

[info, indivInfos] = tss_info(parentDir);

if nargin == 1
    startFrame = 1;
    stopFrame = info.numFrames;

elseif nargin == 2
    if startFrame <= 0
        error('Cannot read non-positive number of frames');
    end
    stopFrame = startFrame;
    startFrame = 1;
end

[startFrame, stopFrame] = sanitizeSlice(startFrame, stopFrame, info.numFrames);

% Find where stack-centric indices are.
[stackStart, relStart] = flatIndex_to_stackIndex(startFrame, indivInfos);
[stackStop, relStop] = flatIndex_to_stackIndex(stopFrame, indivInfos);

% Collect all frames at once if all are contained in one file.
if stackStart == stackStop
    mov = squeeze(tiffstack_read(info.filenames{stackStart}, relStart, relStop));
    return
end

% Otherwise, collect frames from each stack individually.
mov = zeros([stopFrame-startFrame+1, info.frameSize], info.dtype);

% Read chunk from first stack.
stackInfo = indivInfos(stackStart);
numToRead = stackInfo.numFrames - relStart + 1;
mov(1:numToRead, :, :) = tiffstack_read(info.filenames{stackStart},relStart,-1);
framesStored = numToRead;

% Read chunks from middle stacks.
for ii=stackStart+1:stackStop-1
    stackInfo = indivInfos(ii);
    numToRead = stackInfo.numFrames;
    chunk = tiffstack_read(info.filenames{ii}, 1, -1);
    mov(framesStored + 1: framesStored + numToRead, :, :) = ...
        tiffstack_read(info.filenames{ii}, 1, -1);
    framesStored = framesStored + numToRead;
end

% Read final chunk.
numToRead = relStop;
mov(framesStored + 1: framesStored + numToRead, :, :) = ...
    tiffstack_read(info.filenames{stackStop}, 1, relStop);


mov = squeeze(mov);
    
end

function [stackNum, frameNum] = flatIndex_to_stackIndex(flatIndex, indivInfos)
    indStart = 1;
    for stackNum=1:length(indivInfos)
        indices = indStart : indStart + indivInfos(stackNum).numFrames - 1;
        frameNum = find(indices == flatIndex);

        % If we haven't found the start yet, continue.
        if isempty(frameNum)
            indStart = indices(end) + 1;
        else
            return
        end
    end
end