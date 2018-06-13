function [] = importData(mouse, date, expnum, varargin)
% IMPORTDATA Move data from remote to local.
narginchk(1, 4);
movie = parseVarargin(varargin, 'Movie', true);
if nargin == 1
    importMouse(mouse, movie);
elseif nargin == 2
    importDate(mouse, date, movie);
elseif nargin == 3
    importSession(mouse, date, expnum, movie);
end
end

function [] = importMouse(mouse, movie)
    % Export all data for a given mouse.
    if ~exist(fullfile(dataroot('local'), mouse), 'dir')
        mkdir(fullfile(dataroot('local'), mouse));
    end
    
    dateDirs = listDates(mouse, 'remote');
    for ii=1:numel(dateDirs)
        importDate(mouse, dateDirs{ii}, movie);
    end
end

function [] = importDate(mouse, date, movie)
    % Export all data for a given mouse and date.
    if ~exist(fullfile(dataroot('local'), mouse, date), 'dir')
        mkdir(fullfile(dataroot('local'), mouse, date));
    end
    expNumDirs = listExpNums(mouse, date, 'remote');
    for ii=1:numel(expNumDirs)
        importSession(mouse, date, expNumDirs{ii}, movie);
    end
end

function [] = importSession(mouse, date, expnum, movie)
    % Export data from a single session.
    
    if ~exist(fullfile(dataroot('local'), mouse, date, expnum), 'dir')
        mkdir(fullfile(dataroot('local'), mouse, date, expnum));
    end       
    
    localSesDir = sessiondir(mouse, date, expnum, 'local');
    remoteSesDir = sessiondir(mouse, date, expnum, 'remote');

    % Copy over all files.
    files = listFiles(remoteSesDir);
    files = removeString(files, {'Image_0001_0001.raw', 'mov'});
    for ii=1:numel(files)
        source = fullfile(remoteSesDir, files{ii});
        copyfile(source, localSesDir);
    end
    
    % Copy movie file.
    if movie
        regDir = fullfile(remoteSesDir, 'mov');
        if exist(regDir, 'dir')
            destDir = fullfile(localSesDir, 'mov');
            mkdir(destDir);
            copyfile(regDir, destDir);
        else
            rawFile = fullfile(remoteSesDir, 'Image_0001_0001.raw');
            if exist(rawFile, 'file')
                copyfile(rawFile, localSesDir);
            end
        end
    end    
end