function [] = exportAsAVI(mov, filename)

narginchk(2, 2);

v = VideoWriter(filename, 'Motion JPEG AVI');
v.FrameRate = 30;
open(v);
for ii=1:size(mov, 1)
    if ndims(mov) == 3
        frame = squeeze(mov(ii, :, :));
    elseif ndims(mov) == 4
        frame = squeeze(mov(ii, :, :, :));
    else
        error('')    
    end
    writeVideo(v, frame);
end
close(v);

end