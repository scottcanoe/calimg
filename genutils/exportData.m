function [] = exportData(mouse, date, expnum)
% EXPORTDATA Move data from local to remote.
narginchk(1, 3);
if nargin == 1
    exportMouseData(mouse);
elseif nargin == 2
    exportDateData(mouse, date);
elseif nargin == 3
    exportExpNumData(mouse, date, expnum);
end
end

function [] = exportMouseData(mouse)
    % Export all data for a given mouse. 
    dateDirs = listDates(mouse, 'local');
    for ii=1:numel(dateDirs)
        exportDateData(mouse, dateDirs{ii});
    end
end

function [] = exportDateData(mouse, date)
    % Export all data for a given mouse and date.
    expNumDirs = listExpNums(mouse, date, 'local');
    for ii=1:numel(expNumDirs)
        exportExpNumData(mouse, date, expNumDirs{ii});
    end
end

function [] = exportExpNumData(mouse, date, expnum)
    % Export data from a single session.
    localSesDir = sessiondir(mouse, date, expnum, 'local');
    remoteSesDir = sessiondir(mouse, date, expnum, 'remote');

    % Copy over .mat files.
    matFiles = listFiles(fullfile(localSesDir, '*.mat'));
    for ii=1:numel(matFiles)
        source = fullfile(localSesDir, matFiles{ii});
        copyfile(source, remoteSesDir);
    end
    
    % Copy registered movie file.
    regDir = fullfile(localSesDir, 'mov');
    if exist(regDir, 'dir')
        destDir = fullfile(remoteSesDir, 'mov');
        mkdir(destDir);
        copyfile(regDir, destDir);
    end
end