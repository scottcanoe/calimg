
function [] = downsampleAndSave(mouse, date, session_ID, savepath)

sesdir = sessiondir(mouse, date, session_ID);
mov = h5_read(fullfile(sesdir, 'mov.hdf5'));
mov = downsampleMovie(mov, 0.5);
tiffstack_save(fullfile(sesdir, 'frames (resampled)'), mov);

end