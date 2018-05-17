classdef ROI < handle & matlab.mixin.SetGet
    %UNTITLED2 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (SetAccess = private, Hidden = true)
        procMat
    end
    
    properties (SetAccess = private)
        ID
    end
    
    properties (Dependent = true)
        iscell       % Whether ROI has been classified as a cell.
        mimgProjAbs  % Correlation ROI shape is correlated to the shape on mean image.
        skew         % skewness of the neuropil-subtraced cell trace.
        std          % standard deviation of the cell trace, normalized to the size of the neuropil trace.
        footprint    % Spatial extent of correlatioin between ROI trace and nearby pixels.
        pct          % Mean distance of pixels from ROI center, normalized to same measure for a perfect disk.
        aspect_ratio % of an ellipse fit to the ROI
        cellProb     % Probability of being cell (accoring to classifier? Used for thresholding?)
    end
    
    properties (Dependent = true, Hidden = true)
        neuropilCoefficient     % multiplicative coefficient on neuropil signal.
        xpix         % xpix, ypix: x and y indices of pixels belonging to this max. 
        ypix         % These index into the valid part of the image (defined by ops.yrange, ops.xrange).
        ipix         % linearized indices
        isoverlap    % whether pixels overlap with other ROIs.
        lam          % lam, lambda: mask coefficients for corresponding pixels.
        lambda       % lambda is the same as lab, but normalized to 1.
        med          % median pixel
        
        % classifier-related
        std          % standard deviation of the cell trace, normalized to the size of the neuropil trace.
        skew    
        Fcell
        Fneu      
        cmpct
        aspect_ratio
        ellipse    
    end
    
    properties
        attrs    % struct for extra attributes.
        trace_   % neuropil and dFF corrected fluorescence trace.
    end
    
    
    methods
        
        function obj = ROI(procMat, ID)
            obj.procMat = procMat;
            obj.ID = ID;
            trace = obj.
        end
        
        function tf = get.iscell(obj)
            tf = obj.procMat.dat.stat(obj.ID).iscell;
        end
        
        function set.iscell(obj, tf)
            assert(ismember(tf, [0 1]));
            obj.procMat.dat.stat(obj.ID).iscell = tf;
        end
        
        function c = obj.neuropilCoefficient(obj)
            c = obj.procMat.dat.stat(obj.ID).neuropilCoefficient;
        end
    end
    
    
    
end

