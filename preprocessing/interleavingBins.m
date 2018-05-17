function bins = interleavingBins(vals)
% INTERLEAVINGBINS Generate a vector of bin edges such that each interior
% edge lies (halfway) between a pair of consecutive values in 'vals'. The
% outermost edges are guaranteed to be strictly below and strictly above
% the 'vals' min and max, respectively.

% Make sure 'vals' is sorted.
vals = sort(vals);

% Make bin edges.
bins = zeros(1, numel(vals) + 1);
bins(2:end-1) = vals(1:end-1) + diff(vals) / 2.0;
bins(1) = vals(1) - abs(bins(2) - vals(1));
bins(end) = vals(end) + abs(vals(end) - bins(end-1));

end

