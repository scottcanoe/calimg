function resized = downsampleMovie(mov, spec)
% Performs spatial downsampling on data.
% DOWNSAMPLEMOVIE(mov, scale)
% DOWNSAMPLEMOVIE(mov, [numrows, numcols])

numFrames = size(mov, 1);

if isscalar(spec)
    
    % Resample one frame to see resulting image size.
    frameShape = size(imresize(squeeze(mov(1, :, :)), spec));
    d1 = frameShape(1); d2 = frameShape(2);
    
else
    % We are given resulting frame shape explicitly.
    d1 = spec(1); d2 = spec(2);
    
end

% Finally, initialize the new matrix and populate it.
resized = zeros(numFrames, d1, d2, class(mov));
for ii = 1:numFrames
    resized(ii, :, :) = imresize(squeeze(mov(ii, :, :)), spec);
end

end

