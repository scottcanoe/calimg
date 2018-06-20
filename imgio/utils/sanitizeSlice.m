function [pos_start, pos_stop] = sanitizeSlice(start, stop, len)
% UNTITLED Summary of this function goes here
%   Detailed explanation goes here

narginchk(3, 3);

if start == 0
    error('start index cannot be zero');
end

if stop == 0
    error('stop index cannot be zero');
end

if abs(start) > len
    error(['start index ' num2str(start) ' is out of bounds']);
end

if abs(stop) > len
    error(['stop index ' num2str(stop) ' is out of bounds']);
end

if start < 1
    pos_start = start + len + 1;
else
    pos_start = start;
end

if stop < 1
    pos_stop = stop + len + 1;
else
    pos_stop = stop;
end

end

