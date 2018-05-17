% This script demonstrates how to read a scanimage tiff and save the green
% channel data as a directory containing single frame tiffs. We don't use
% red channels in our lab so I don't know how to use Suite2P in
% multichannel mode, but this should get you started. Note that this relies
% on the 'imgio' library, so make sure it's in your path.
%
% This

% Read the data.
fname = 'GCaMP_mRuby_p12_005.tif';
[~, Aout, ~] = scim_openTif(fname);

% Extract the green channel and reorder the axes.
mov = squeeze(Aout(:, :, 1, :));
mov = permute(mov, [3 1 2]);

% 
mov = uint16(mov);
% Save the tiffs.
outDir = 'tiffs';
tiffseries_save(outDir, mov);
