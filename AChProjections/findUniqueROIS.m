function uniqueROIs = findUniqueROIS(allROI,varargin)
% Only keep ROIs that do not overlap at all with comparison sets

disp('Finding unique ROIs...')

nComp = length(varargin);
nROI = allROI.NumObjects;
iKeep = true(1,nROI);
for iComp = 1:nComp
    compROI = varargin{iComp};
    for iN = 1:nROI
        for iC = 1:compROI.NumObjects
        if sum(sum(allROI.Masks{iN}.*compROI.Masks{iC})) > 0
            iKeep(iN) = false;
        end
        
        end
        
    end
end

uniqueROIs = allROI;
uniqueROIs.NumObjects = sum(iKeep);
uniqueROIs.PixelIdxList = uniqueROIs.PixelIdxList(iKeep);
uniqueROIs.Centroids = uniqueROIs.Centroids(iKeep);
uniqueROIs.Masks = uniqueROIs.Masks(iKeep);
uniqueROIs.ROIImage = zeros(uniqueROIs.ImageSize);
for iC = 1:uniqueROIs.NumObjects
    uniqueROIs.ROIImage(uniqueROIs.PixelIdxList{iC}) = iC;
end