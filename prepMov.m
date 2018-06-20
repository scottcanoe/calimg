function mov = prepMov(mov, varargin)
% PREPMOVIE Prepares movie for viewing by rescaling and smoothing.

% narginchk(1, 2)
smoothNum = parseVarargin(varargin, 'Smooth', 5);

% Rescale.
mov = double(mov);
maxval = prctile(mov(:), 99);
mov = mov/maxval;
mov(mov>1) = 1;

% Smooth.
if smoothNum
    mov = smooth3(mov, 'box', [smoothNum 1 1]);
end

end

