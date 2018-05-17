function path = dataroot(newDataRoot)
% Returns or sets the value of 'CALIMG_DATAROOT" environment variable.

if nargin == 0
    % Return environment variable.
    path = getenv('CALIMG_DATAROOT');
    if isempty(path)
        msg = 'Cannot find environment variable for CALIMG_DATAROOT.';
        msg = [msg ' Did you open MATLAB via command line (required for linux)?'];
        msg = [msg ' Has the environment variable been set properly?'];
        warning(msg);
    end
    
else
    % Check existence.
    if ~exist(newDataRoot, 'dir')
        msg = 'New data root is not an existing directory';
        warning(msg);
    end
    setenv('CALIMG_DATAROOT', newDataRoot);
    path = newDataRoot;
end

