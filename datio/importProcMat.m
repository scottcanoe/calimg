function [] = importProcMat(mouse, date, expnum, varargin)
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
    % Import all procmats for a given mouse.
    if ~exist(fullfile(dataroot('local'), mouse), 'dir')
        mkdir(fullfile(dataroot('local'), mouse));
    end
    
    dateDirs = listDates(mouse, 'remote');
    for ii=1:numel(dateDirs)
        importDate(mouse, dateDirs{ii}, movie);
    end
end

function [] = importDate(mouse, date, movie)
    % Import all procmats for a given mouse and date.
    if ~exist(fullfile(dataroot('local'), mouse, date), 'dir')
        mkdir(fullfile(dataroot('local'), mouse, date));
    end
    expNumDirs = listExpNums(mouse, date, 'remote');
    for ii=1:numel(expNumDirs)
        importSession(mouse, date, expNumDirs{ii}, movie);
    end
end

function [] = importSession(mouse, date, expnum, movie)
    % Import procmat from a single session.
    
    if ~exist(fullfile(dataroot('local'), mouse, date, expnum), 'dir')
        mkdir(fullfile(dataroot('local'), mouse, date, expnum));
    end       
    
    localSesDir = sessiondir(mouse, date, expnum, 'local');
    remoteSesDir = sessiondir(mouse, date, expnum, 'remote');

    % Copy over procmat.
    file = dir(fullfile(remoteSesDir, '*proc.mat'));
    if isempty(file)
        return
    end
    source = fullfile(file.folder, file.name);
    copyfile(source, localSesDir);
    
    % Copy over frameInfo
    file = dir(fullfile(remoteSesDir, 'frameInfo.mat'));
    if isempty(file)
        errordlg(['missing frameInfo.mat for ',mouse,',',date,',',expnum]);
    end
    source = fullfile(file.folder, file.name);
    copyfile(source, localSesDir);
end