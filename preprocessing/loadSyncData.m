

function SyncData = loadSyncData(arg1, arg2, arg3)
% LOADSYNCDATA Returns a containers.Map object of signals. 
% 'time' is always present, and usually 'AnalogEvents', 'FrameOut', 
% 'FrameTrigger', and 'Strobes' are also available.
% LOADSYNCDATA Prompts user to select a sync episode file with uigetfile.
% LOADSYNCDATA(filename) Call with path to sync episode file.
% LOADSYNCDATA(mouse, date, expnum) Call mouse/date/expnum pattern.

if nargin == 0
    [file, path] = uigetfile(fullfile(dataroot, '*.h5'));
    filename = fullfile(path, file);
elseif nargin == 1
    filename = arg1;
elseif nargin == 3
    mouse = arg1;
    date = arg2;
    expnum = num2str(arg3);
    sesDir = sessiondir(mouse, date, expnum);
    files = dir(fullfile(sesDir, 'Episode*.h5'));
    filename = fullfile(sesDir, files(1).name);
else
    error('Bad arg structure.');
end

% Define a constant used for scaling time array.
clockRate = 20000000;

% Start loading HDF5.
info = h5info(filename);

%% Read HDF5.
SyncData = containers.Map;
for j=1:length(info.Groups)
    for k = 1:length(info.Groups(j).Datasets)
        datasetName = info.Groups(j).Datasets(k).Name;
        datasetPath = strcat(info.Groups(j).Name,'/', datasetName);
        dataset = h5read(filename, datasetPath)';
        % load digital line in binary:
        if(strcmp(info.Groups(j).Name,'/DI'))
            dataset(dataset>0) = 1;
        end
        % Create time variable out of gCtr, accounting for 20MHz sample
        % rate.
        if(strcmp(info.Groups(j).Name,'/Global'))
            dataset = double(dataset) ./ clockRate;
            datasetName = 'time';
        end
        SyncData(datasetName) = dataset;
    end
end

end


