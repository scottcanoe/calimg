classdef VolumeRegistrationTool < guiClass

    properties (Constant)
        guiFile = 'VolumeRegistrationToolFigure.fig'
    end
    
    properties
        referenceVolume  % A struct that includes volume and metadata.
        testVolume       % A struct that includes volume and metadata.
        T                % 4 x 4 transformation matrix.
    end
    
    methods
        
        function obj = VolumeRegistrationTool()
            obj.openGUI;
        end
        
    end
    
    methods (Access=protected)
        
        function guiCallback(obj, src, evnt)
            
            switch src
                case obj.handles.LoadReferenceVolumeButton
                    obj.LoadReferenceVolumeButtonPushed(evnt);
                case obj.handles.LoadTestVolumeButton
                    obj.LoadTestVolumeButtonPushed(evnt);
                case obj.handles.RefreshButton
                    obj.RefreshButtonPushed(evnt);
                case obj.handles.EstimateDisplacementButton
                    obj.EstimateDisplacementButtonPushed(evnt);
            
            end
        end
        
        function guiInit(obj)
            obj.handles.ReferenceVolumeAxes.XTick = [];
            obj.handles.ReferenceVolumeAxes.YTick = [];
            obj.handles.TestVolumeAxes.XTick = [];
            obj.handles.TestVolumeAxes.YTick = [];
        end
        
        function vol = trimVolume(obj, volType)
            
            if strcmp(volType, 'reference')
                vol = obj.referenceVolume.vol;
            elseif strcmp(volType, 'test')
                vol = obj.testVolume.vol;
            else
                error('AAAAAHHHH!!!!')
            end
            
            xlim = int32(str2num(obj.handles.XTrimLabel.String));
            ylim = int32(str2num(obj.handles.YTrimLabel.String));
            zlim = int32(str2num(obj.handles.ZTrimLabel.String));
            
            if ~isempty(xlim)
                vol = vol(:, xlim:end-xlim, :);
            end
            
            if ~isempty(ylim)
                vol = vol(ylim:end-ylim, :, :);
            end

            if ~isempty(zlim)
                vol = vol(:, :, zlim:end-zlim);
            end
        end
        
        function s = buildVolumeStruct(obj, parentDir)
            
            s = struct;
            s.parentDir = parentDir;
            vol = double(volume_read(parentDir));
            
            % Find middle plane to display.
            numZSlices = size(vol, 3);
            zmid = int32(numZSlices/2);
            zmid = max(zmid, 1);
            zmid = min(zmid, numZSlices);
            displayPlane = squeeze(vol(:, :, zmid));
            maxval = prctile(displayPlane(:), 99);
            displayPlane = displayPlane/maxval;
            displayPlane(displayPlane > 1) = 1;            
            s.displayPlane = displayPlane;
            
            % Gather attributes.
            xml = xml2struct(fullfile(parentDir, 'Experiment.xml'));
            xml = xml.ThorImageExperiment;
            s.pixelSizeUM = str2num(xml.LSM.Attributes.pixelSizeUM);
            s.stepSizeUM = str2num(xml.ZStage.Attributes.stepSizeUM);
            s.vol = vol;
            s.date = xml.Date.Attributes.date;
        end
    
        % Button pushed function: LoadReferenceVolumeButton
        function LoadReferenceVolumeButtonPushed(obj, event)
            
            % Load the volume.
            try
                startDir = dataroot;
            catch
                startDir = homedir;
            end
            parentDir = uigetdir(startDir);
            disp('Loading reference volume...');
            obj.referenceVolume = obj.buildVolumeStruct(parentDir);
                        
            % Update axes.
            displayPlane = obj.referenceVolume.displayPlane;
            im = imshow(displayPlane, [0 1], ...
                       'Parent', obj.handles.ReferenceVolumeAxes);
            obj.handles.ReferenceVolumeAxes.XLim = [0 im.XData(2)];
            obj.handles.ReferenceVolumeAxes.YLim = [0 im.YData(2)];               
           
            % Update labels.
            vol = obj.referenceVolume.vol;
            s = [num2str(size(vol, 1)) ' x ' num2str(size(vol, 2))];
            obj.handles.ReferenceVolumeImageSizeLabel.String = s;
            s = num2str(size(vol, 3));
            obj.handles.ReferenceVolumePlanesLabel.String = s;
           
            disp('Complete');
        end

        % Button pushed function: LoadTestVolumeButton
        function LoadTestVolumeButtonPushed(obj, event)
            
            % Load the volume.
            if ischar(event)
                disp('Loading test volume...');
                parentDir = event;
            else
                try
                    startDir = dataroot;
                catch
                    startDir = homedir;
                end
                parentDir = uigetdir(startDir);
            end
            obj.testVolume = obj.buildVolumeStruct(parentDir);
            
            % Update axes.
            displayPlane = obj.testVolume.displayPlane;
            im = imshow(displayPlane, [0 1], ...
                       'Parent', obj.handles.TestVolumeAxes);
            obj.handles.TestVolumeAxes.XLim = [0 im.XData(2)];
            obj.handles.TestVolumeAxes.YLim = [0 im.YData(2)];               
           
            % Update labels.
            vol = obj.testVolume.vol;
            s = [num2str(size(vol, 1)) ' x ' num2str(size(vol, 2))];
            obj.handles.TestVolumeImageSizeLabel.String = s;
            s = num2str(size(vol, 3));
            obj.handles.TestVolumePlanesLabel.String = s;
           
            disp('Complete');
        end

        % Button pushed function: RefreshTestVolumeButton
        function RefreshButtonPushed(obj, event)
            obj.LoadTestVolumeButtonPushed(obj.testVolume.parentDir);
        end

        % Button pushed function: EstimateDisplacementButton
        function EstimateDisplacementButtonPushed(obj, event)
            
            % Check to see if volumes are compatible.
            if ~all(size(obj.referenceVolume.vol)==size(obj.testVolume.vol))
                error('Volumes are not the same size');
            end
            
            if obj.referenceVolume.pixelSizeUM ~= obj.testVolume.pixelSizeUM
                error('Pixels sizes between volumes do not match.')
            else
                pixelSizeUM = obj.referenceVolume.pixelSizeUM;
            end
            
            if obj.referenceVolume.stepSizeUM ~= obj.testVolume.stepSizeUM
                error('Z step sizes between volumes do not match.')
            else
                stepSizeUM = obj.referenceVolume.stepSizeUM;
            end
            
            refVol = obj.trimVolume('reference');
            testVol = obj.trimVolume('test');
            disp(size(refVol));
            tic;
            [optimizer, metric] = imregconfig('monomodal');
            tform = imregtform(testVol, refVol, 'rigid', optimizer, metric);            
            toc;
            T = tform.T;
            obj.T = T;
            disp(T);
            
            xOff = T(4, 1);
            yOff = T(4, 2);
            zOff = T(4, 3);
            
            % Testing
%             pixelSizeUM = 1;
%             stepSizeUM = 1;
            
            if xOff < 0
                leadIn = 'Go right';
                p = -1;
            else
                leadIn = 'Go left';
                p = 1;
            end
            s = sprintf('%s %.1f um', leadIn, p*xOff*pixelSizeUM);
            obj.handles.XEstimateLabel.String = s;
            
            if yOff < 0
                leadIn = 'Go down';
                p = -1;
            else
                leadIn = 'Go up';
                p = 1;
            end
            s = sprintf('%s %.1f um', leadIn, p*yOff*pixelSizeUM);
            obj.handles.YEstimateLabel.String = s;

            if zOff < 0
                leadIn = 'Go up';
                p = -1;
            else
                leadIn = 'Go down';
                p = 1;
            end
            s = sprintf('%s %.1f um', leadIn, p*zOff*stepSizeUM);
            obj.handles.ZEstimateLabel.String = s;
            
        end
    end
end