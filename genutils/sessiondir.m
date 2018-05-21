function sessionDir = sessiondir(mouse, date, session, localOrRemote)
narginchk(3, 4);

if nargin == 3
    localOrRemote = 'local';
end

sessionDir = fullfile(dataroot(localOrRemote), mouse, date, num2str(session));

end

