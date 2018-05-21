function path = dataroot(localOrRemote)
% Returns the root directory where data is stored. 

narginchk(0, 1);
if nargin == 0
    localOrRemote = 'local';
end

if strcmp(localOrRemote, 'local')
    % Return local dataroot.
    path = getenv('CALIMG_DATAROOT');
    if isempty(path)
        msg = 'Cannot find environment variable for CALIMG_DATAROOT.';
        msg = [msg ' Did you open MATLAB via command line (required for linux)?'];
        msg = [msg ' Has the environment variable been set properly?'];
        warning(msg);
    end
    
elseif strcmp(localOrRemote, 'remote')
    % Return remote dataroot.
    path = getenv('CALIMG_DATAROOT_REMOTE');
    if isempty(path)
        msg = 'Cannot find environment variable for CALIMG_DATAROOT_REMOTE.';
        msg = [msg ' Did you open MATLAB via command line (required for linux)?'];
        msg = [msg ' Has the environment variable been set properly?'];
        warning(msg);
    end
else
    error('"localOrRemote" argument must be either "local" or "remote"');
end

