function [] = h5_save(filename, mov, loc)
% H5_SAVE(filename, mov)
% H5_SAVE(filename, mov, loc)

narginchk(2, 3)

% Handle default dataset name.
if nargin == 2
    loc = '/mov';
end

% Add leading backslash, if necessary.
if ~strcmp(loc(1), '/')
    loc = strcat('/', loc);
end

% Create the h5 file, and write to it.
h5create(filename, loc, size(mov), 'Datatype', class(mov));
h5write(filename, loc, mov);

end

