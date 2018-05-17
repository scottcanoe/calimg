function [M, shifts, template] = motion_correct_rigid(mouse, date, session)
% Returns motion corrected movie 'M'.

gcp;    % Start multiprocessing pool.

% Read data.
sesdir = get_sessiondir(mouse, date, session);
tiffdir = fullfile(sesdir, 'frames (downsampled)');
Y = tiffstack_read(tiffdir);
Y = single(Y);
outfile = fullfile(sesdir, 'motion_corrected.mat');
options = NoRMCorreSetParms('d1', size(Y,1), ...
                            'd2', size(Y,2), ...
                            'memmap', true, ...
                            'mem_batch_size', 1000, ...
                            'mem_filename', outfile, ...
                            'output_type', 'memmap', ...
                            'use_parallel', true, ...
                            'bin_width', 50, ...
                            'max_shift', 15, ...
                            'us_fac', 50, ...
                            'init_batch', 200);

tic; [~, ~, ~] = normcorre_batch(Y, options); toc

% Add necessary variables, if they don't already exist.
data = matfile([outfile(1:end-3), 'mat'], 'Writable', true);
vars = who('-file', filename);
if ~(any(strcmp(vars, 'sizY')) && any(strcmp(vars, 'nY')))
    Y = data.Y;
    if ~any(strcmp(vars, 'sizY')) 
        data.sizY = size(Y);
    end
    if ~any(strcmp(vars, 'nY')) 
        data.nY = min(Y(:));
    end
end

end