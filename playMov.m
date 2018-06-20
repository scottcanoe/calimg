function [] = playMov(mov, frameInfo, seqType)


mov = prepMov(mov);
FPS = 30;
if nargin == 3
    frames = labelMov(mov, frameInfo, seqType);
    implay(frames, FPS);
else
    mov = permute(mov, [2 3 1]);
    implay(mov, FPS);
end

end