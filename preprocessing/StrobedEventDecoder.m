classdef StrobedEventDecoder < handle & matlab.mixin.SetGet
    % SyncDataManager This class creates a struct array of events that
    % correspond to the image frame onsets.
    %  
    
    properties (Constant)

        DefaultCalibrationSequence = [];
        DefaultRequiredArrays = {'AnalogEvents', ...
                                 'Strobe', ...
                                 'FrameTrigger', ...
                                 'FrameOut', ...
                                 'time'};
        DefaultEventValues = [];
    
    end
    
    properties (SetAccess=protected)
        
        SyncData                % Map of sync data.
        Events                  % Struct array of all strobed events.
        ExperimentStart         % Index at which experiment started (i.e., first frame captured).
        ExperimentStop          % Index at which experiment stopped.
                        
    end
    
    properties
        
        CalibrationSequence       % Calibration sequence in 'AnalogEvents' line.
        RequiredArrays            % Used for validation purposes.
        EventValues               % Stimulus codes for discrete encoding.
  
    end
    
    methods
        
        function obj = StrobedEventDecoder(varargin)
            
            % Set property values.
            obj.CalibrationSequence = parseVarargin(varargin, ...
                                                   'CalibrationSequence',...
                                                    obj.DefaultCalibrationSequence);
            obj.RequiredArrays = parseVarargin(varargin, ...
                                              'RequiredArrays',...
                                               obj.DefaultRequiredArrays);
            obj.EventValues = parseVarargin(varargin, ...
                                           'EventValues', ...
                                            obj.DefaultEventValues);
            
            % Initialize all other properties.
            obj.reset();
        end
        
        function run(obj, SyncData)
            
            % First reset a bunch of temporary variables.
            obj.reset();
            
            % Do some light validation of SyncData.
            for ii=1:numel(obj.RequiredArrays)
                arrayName = obj.RequiredArrays{ii};
                if not(ismember(arrayName, keys(SyncData)))
                    error(['SyncData is missing a required array.' arrayName]);
                end
            end
        
            %% Determine boundaries of the experiment section.
            
            % Find where 'FrameTrigger' changes.
            frame_trigger = int32(SyncData('FrameTrigger'));
            ft_diffs = [0 diff(frame_trigger)'];
            ft_changed = int32(find(ft_diffs));
            trigger_off = ft_changed(2);
            
            % Find where 'Frame Out' changes.
            frame_out = int32(SyncData('FrameOut'));
            fout_diffs = [0 diff(frame_out)'];
            fout_changed = find(fout_diffs);
            fout_rise = fout_changed(1:2:end);
            
            % Set properties.
            obj.SyncData = SyncData;
            obj.ExperimentStart = fout_rise(1);
            dummy = fout_rise(fout_rise < trigger_off);
            obj.ExperimentStop = dummy(end);
            clear dummy;
        
            %% Create and process events.

            % Initialize events.
            obj.createEvents();

            % Calibrate analog event voltage values.
            if not(isempty(obj.CalibrationSequence))
                obj.calibrateVoltageData();
            end
            
            % Set their stimcodes.
            if not(isempty(obj.EventValues))
                obj.setEventValues();
            end
                                                        
        end
        
    end % End of public methods.
    
    methods (Access = protected)
            
        function reset(obj)
            obj.SyncData = containers.Map;
            obj.Events = struct([]);
            obj.ExperimentStart = NaN;
            obj.ExperimentStop = NaN;
        end
        
                      
        function createEvents(obj)
        
            %% Find indices of important strobe up/down events.
            
            % Get strobe event times, and estimate typical duration.
            strobes = int32(obj.SyncData('Strobe'));
            strobe_diffs = [0 diff(strobes)'];
            strobe_changed = int32(find(strobe_diffs));
            strobe_rise = strobe_changed(1:2:end);
            strobe_fall = strobe_changed(2:2:end);
            
            % Do some light validation, then generate events.
            assert(length(strobe_rise) == length(strobe_fall));
      
            %% Create events.
            obj.Events = struct('Start', {}, ...    % index
                                'Stop', {}, ...     % index
                                'Voltage', {}, ...
                                'EventValue', {}, ...
                                'Experiment', {});

            % Convenience variables.
            ae = obj.SyncData('AnalogEvents');
            
            % Manually add an initial event if there's no strobe at t = 0.
            % This event stretches from the beginning of the recording
            % until the first strobe occurs. The expression 
            % 'strobe_rise(1) ~= 1 is basically always true, but checking is 
            % done for completeness.
            if strobe_rise(1) ~= 1
                start = int32(1);
                stop = strobe_rise(1);
                newEvent = struct('Start', start, ...
                                  'Stop', stop, ...
                                  'Voltage', ae(start), ...
                                  'EventValue', NaN, ...
                                  'Experiment', obj.overlaps(start, stop));
                obj.Events(length(obj.Events)+1) = newEvent;
            end
            
            % Add middle events.
            for ii=1:length(strobe_rise)-1
                start = strobe_rise(ii);
                stop = strobe_rise(ii+1);
                newEvent = struct('Start', start, ...
                                  'Stop', stop, ...
                                  'Voltage', ae(start), ...
                                  'EventValue', NaN, ...
                                  'Experiment', obj.overlaps(start, stop));
                obj.Events(length(obj.Events)+1) = newEvent;
            end
            
            % Manually add a final event since there's no strobe at the end.
            % The final event runs from the last strobe until the end of
            % the data.
            start = strobe_rise(end);
            stop = length(ae);
            newEvent = struct('Start', start, ...
                              'Stop', stop, ...
                              'Voltage', ae(start), ...
                              'EventValue', NaN, ...
                              'Experiment', obj.overlaps(start, stop));
            obj.Events(length(obj.Events)+1) = newEvent;
            
        end
        
        
        function calibrateVoltageData(obj)
            % Finds the bias and compression in the 'AnalogEvents' signal,
            % and corrects both the signal and the 'Voltage' field in the
            % events.
            
            % Get events from calibration period.
            calSeq = obj.CalibrationSequence;
            calEvents = obj.Events(2:length(calSeq)+1);
            
            % Do linear regression.
            X_train = [ones(length(calSeq), 1) calSeq'];
            Y_train = extractfield(calEvents, 'Voltage')';
            B = X_train \ Y_train;
            b = B(1);
            m = B(2);
            
            % Modify all events and 'AnalogEvents' line.
            V = (extractfield(obj.Events, 'Voltage')- b) / m;
            for ii = 1:length(obj.Events)
                obj.Events(ii).Voltage = V(ii);
            end
            obj.SyncData('AnalogEvents') = (obj.SyncData('AnalogEvents')-b)/m;
                    
        end
        
        
        function setEventValues(obj)
            % Sets the 'StimCode' field of events that occur during
            % experiment.            
            for ii = 1:length(obj.Events)
%                 if ~obj.Events(ii).Experiment
%                     continue
%                 end
                val = obj.Events(ii).Voltage;
                [~, index] = min(abs(val - obj.EventValues));
                nearest = obj.EventValues(index);
                obj.Events(ii).EventValue = nearest;
            end
        end
        
        
        function tf = overlaps(obj, start, stop)
            % Small helper function used by 'SyncDataManager.createEvents()'. 
            % Determines whether a frame lies within the experimental region.
            % 'start' and 'stop' refer to the index of strobe(i) and the
            % index of strobe(i+1), (therefore, a frame stretches from 
            % index i to i+1). If the frame has any overlap with the
            % experiment period, then it is included.
            startInRange = and(start >= obj.ExperimentStart, ...
                               start < obj.ExperimentStop);
            stopInRange =  and(stop > obj.ExperimentStart, ...
                               stop <= obj.ExperimentStop);
            tf = int32(or(startInRange, stopInRange));
            
        end

    end
end

