function vol = volume_read(parentDir)

vol = tiffseries_read(parentDir);
vol = permute(vol, [2, 3, 1]);

end