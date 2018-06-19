% mouse = '401622-732';
% date = '2018-06-14';
% 
% %%
% sups = struct;
% topDir = fullfile(dataroot, mouse, date);
% s = dir(fullfile(topDir, '*sup*'));
% supDirs = extractfield(s, 'name');
% for ii=1:4
%     parentDir = fullfile(topDir, supDirs{ii}, 'Untitled_001');
%     vol = volume_read(parentDir);
%     sups(ii).name = supDirs{ii};
%     sups(ii).vol = vol;
% end
% 
% infs = struct;
% topDir = fullfile(dataroot, mouse, date);
% s = dir(fullfile(topDir, '*inf*'));
% infDirs = extractfield(s, 'name');
% for ii=1:4
%     parentDir = fullfile(topDir, infDirs{ii}, 'Untitled_001');
%     vol = volume_read(parentDir);
%     infs(ii).name = infDirs{ii};
%     infs(ii).vol = vol;
% end

%%

% for ii=2:4
%     [optimizer, metric] = imregconfig('monomodal');
%     tic
%     disp(['Running ' sups(ii).name]);
%     tform = imregtform(trimVol(sups(ii).vol), trimVol(sups(1).vol), ...
%                        'rigid', optimizer, metric);
%     toc
%     sups(ii).T = tform.T;
% end

for ii=2:4
    [optimizer, metric] = imregconfig('monomodal');
    tic
    disp(['Running ' infs(ii).name]);
    tform = imregtform(trimVol(infs(ii).vol), trimVol(infs(1).vol), ...
                       'rigid', optimizer, metric);
    toc
    infs(ii).T = tform.T;
end

function trimmed = trimVol(vol)
    zmin = 50; zmax = 150;
    margin = 25;
    trimmed = vol(margin:end-margin, margin:end-margin, zmin:zmax);
end

