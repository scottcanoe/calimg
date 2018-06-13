function mov = prepMov(mov, smoothNum)
% PREPMOVIE Prepares movie for viewing by rescaling and smoothing.

narginchk(1, 2)
if nargin == 1
    smoothNum = 5;
end

% Rescale.
mov = double(mov);
maxval = prctile(mov(:), 99);
mov = mov/maxval;
mov(mov>1) = 1;

% Smooth.
mov = smooth3(mov, 'box', [smoothNum 1 1]);

end

