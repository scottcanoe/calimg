function frames = labelMov(mov, frameInfo, seqType)

frames = struct('cdata', {}, 'colormap', {});
eventValues = extractfield(frameInfo, 'EventValue');
seqSpecs = sequenceSpecs(seqType);
for ii=1:size(mov, 1)
    label = eventValueToLabel(eventValues(ii), seqSpecs);
    f = squeeze(mov(ii, :, :));
    cdata = insertText(f, [10, 10], label, 'FontSize', 24);
    frames(ii).cdata = cdata;
end

end