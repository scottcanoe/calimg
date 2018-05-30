function mov = loadMov(mouse, date, expnum, localOrRemote, varargin)
% LOADMOV Loads registered movie in session directory.
% LOADMOV(mouse, date, expnum)
% LOADMOV(mouse, date, expnum [,localOrRemote] [,frameSpecForTSSRead])

narginchk(3, 6);
if nargin == 3
    localOrRemote = 'local';
end
if nargin > 3 && ~ischar(localOrRemote)
    if isempty(varargin)
        varargin = {localOrRemote};
    else
        varargin = {{localOrRemote}, varargin};
    end
    localOrRemote = 'local';
end

sesDir = sessiondir(mouse, date, expnum, localOrRemote);
mov = tss_read(fullfile(sesDir, 'mov'), varargin{:});

end