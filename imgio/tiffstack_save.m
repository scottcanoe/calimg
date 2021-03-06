function [] = tiffstack_save(filename, mov)
% TIFSTACK_SAVE(filename, mov)

narginchk(2, 2)
% Estimate size of tiffstack, and write as bigtiff if size is over 3.5 GB.
nGB = numel(mov) * dtypeBits(class(mov)) * 1.01 / 1e9; 
if nGB > 3.5
    options.big = true;
else
    options.big = false;
end

options.message = false;

% Change dimensions, then save tiff.
permutedMov = permute(mov, [2 3 1]);
saveastiff(permutedMov, filename, options);

end