function [] = importData(mouse, date, expnum)
% IMPORTDATA Move data from remote to local.
narginchk(1, 3);
if nargin == 1
    importMouse(mouse);
elseif nargin == 2
    importDate(mouse, date);
elseif nargin == 3
    importSession(mouse, date, expnum);
end
end

function [] = importMouse(mouse)
    % Export all data for a given mouse.
    if ~exist(fullfile(dataroot('local'), mouse), 'dir')
        mkdir(fullfile(dataroot('local'), mouse));
    end
    
    dateDirs = listDates(mouse, 'local');
    for ii=1:numel(dateDirs)
        importDate(mouse, dateDirs{ii});
    end
end

function [] = importDate(mouse, date)
    % Export all data for a given mouse and date.
    if ~exist(fullfile(dataroot('local'), mouse, date), 'dir')
        mkdir(fullfile(dataroot('local'), mouse, date));
    end
    expNumDirs = listExpNums(mouse, date, 'local');
    for ii=1:numel(expNumDirs)
        importSession(mouse, date, expNumDirs{ii});
    end
end

function [] = importSession(mouse, date, expnum)
    % Export data from a single session.
    
    if ~exist(fullfile(dataroot('local'), mouse, date, expnum), 'dir')
        mkdir(fullfile(dataroot('local'), mouse, date, expnum));
    end       
    
    localSesDir = sessiondir(mouse, date, expnum, 'local');
    remoteSesDir = sessiondir(mouse, date, expnum, 'remote');

    % Copy over .mat files.
    matFiles = listFiles(fullfile(localSesDir, '*.mat'));
    for ii=1:numel(matFiles)
        remoteFile = fullfile(remoteSesDir, matFiles{ii});
        copyfile(remoteFile, localSesDir);
    end
    
    % Copy registered movie file.
    regDir = fullfile(RemoteSesDir, 'mov');
    if exist(regDir, 'dir')
        destDir = fullfile(localSesDir, 'mov');
        mkdir(destDir);
        copyfile(regDir, destDir);
    end
end