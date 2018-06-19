mouse = '401622-732';
% v = volume_read(fullfile(dataroot, mouse, '1', 'Untitled_001'));
% v_left  = volume_read(fullfile(dataroot, mouse, '2-left', 'Untitled_001'));
% v_right = volume_read(fullfile(dataroot, mouse, '3-right', 'Untitled_001'));
% v_up = volume_read(fullfile(dataroot, mouse, '4-up', 'Untitled_001'));
% v_down = volume_read(fullfile(dataroot, mouse, '5-down', 'Untitled_001'));
% v_sup = volume_read(fullfile(dataroot, mouse, '6-superior', 'Untitled_001'));
% v_inf = volume_read(fullfile(dataroot, mouse, '7-inferior', 'Untitled_001'));

% zmin = 150;
% zmax = 250;
% v_1 = v(:, :, zmin:zmax);
% v_left_1 = v_left(:, :, zmin:zmax);
% v_right_1 = v_right(:, :, zmin:zmax);
% v_up_1 = v_up(:, :, zmin:zmax);
% v_down_1 = v_down(:, :, zmin:zmax);
% v_sup_1 = v_sup(:, :, zmin:zmax);
% v_inf_1 = v_inf(:, :, zmin:zmax);

[optimizer, metric] = imregconfig('monomodal');
tform = imregtform(v_inf_1, v_1, 'rigid', optimizer, metric);
