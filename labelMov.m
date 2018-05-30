function frames = labelMov(mov, frameInfo)

frames = struct('cdata', {}, 'colormap', {});
eventValues = extractfield(frameInfo, 'EventValue');
seqSpecs = sequenceSpecs;
for ii=1:size(mov, 1)
    label = eventValueToLabel(eventValues(ii), seqSpecs);
    f = squeeze(mov(ii, :, :));
    cdata = insertText(f, [10, 10], label, 'FontSize', 24);
    frames(ii).cdata = cdata;
end

end