function [] = playMov(mov, frameInfo, varargin)

FPS = parseVarargin(varargin, 'FPS', 15);
mov = prepMov(mov);
if nargin == 2
    frames = labelMov(mov, frameInfo);
    implay(frames, FPS);
else
    implay(mov, FPS);
end

end