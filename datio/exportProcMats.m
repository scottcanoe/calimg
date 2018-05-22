function [] = exportProcMats(mouse, date, expnum)
% EXPORTDATA Move data from local to remote.
narginchk(1, 3);
if nargin == 1
    exportMouseProcMats(mouse);
elseif nargin == 2
    exportDateProcMats(mouse, date);
elseif nargin == 3
    exportExpNumProcMats(mouse, date, expnum);
end
end

function [] = exportMouseProcMats(mouse)
    % Export all data for a given mouse. 
    dateDirs = listDates(mouse, 'local');
    for ii=1:numel(dateDirs)
        exportDateProcMats(mouse, dateDirs{ii});
    end
end

function [] = exportDateProcMats(mouse, date)
    % Export all data for a given mouse and date.
    expNumDirs = listExpNums(mouse, date, 'local');
    for ii=1:numel(expNumDirs)
        exportExpNumProcMats(mouse, date, expNumDirs{ii});
    end
end

function [] = exportExpNumProcMats(mouse, date, expnum)
    % Export data from a single session.
    localSesDir = sessiondir(mouse, date, expnum, 'local');
    remoteSesDir = sessiondir(mouse, date, expnum, 'remote');

    % Copy over .mat files.
    files = listFiles(fullfile(localSesDir, 'F*proc*.mat'));
    if length(files) > 0
        fname = files{1};
        copyfile(fname, remoteSesDir);
    end
end