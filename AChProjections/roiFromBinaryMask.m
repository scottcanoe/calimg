function [rois,fh] = roiFromBinaryMask(mask,minPixels,showROI,varargin)

if nargin < 2 || isempty(minPixels)
    minPixels = 0;
end

if nargin < 3 || isempty(showROI)
    showROI = false;
end

disp('Finding ROIs from mask ...')

cc = bwconncomp(mask,varargin{:});
iKeep = true(1,cc.NumObjects);
masks = cell(1,cc.NumObjects);
for iC = 1:cc.NumObjects
    if numel(cc.PixelIdxList{iC})<minPixels
        iKeep(iC) = false;
    else
        mask = zeros(cc.ImageSize);
        mask(cc.PixelIdxList{iC}) = 1;
        masks{iC} = mask;
    end
end
cc.NumObjects = sum(iKeep);
cc.PixelIdxList = cc.PixelIdxList(iKeep);
masks = masks(iKeep);

S = regionprops(cc,'Centroid');
Centroids = cell(1,cc.NumObjects);
for iC = 1:cc.NumObjects
    Centroids{iC} = S(iC).Centroid;
end

roiImage = zeros(cc.ImageSize);
for iC = 1:cc.NumObjects
    roiImage(cc.PixelIdxList{iC}) = iC;
end

rois = cc;
rois.Centroids = Centroids;
rois.Masks = masks;
rois.ROIImage = roiImage;

fh = [];

if showROI
    
    fh = figure;
    imagesc(rois.ROIImage);
    map = jet(rois.NumObjects+1);
    map(1,:) = [0 0 0];
    colormap(map);
    colorbar;

end