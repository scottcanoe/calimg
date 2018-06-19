classdef guiClass < handle
    
    properties (Abstract,Constant)
        guiFile
    end
    
    methods (Abstract,Access=protected)
        guiInit(obj);
        guiCallback(obj,src,evnt);
    end
    
    events
        GUIOpening
        GUIClosing
    end
    
    properties (Hidden=true)
        hGUI
        handles
    end
    
    methods
        
        function delete(obj)
            if ~isempty(obj.hGUI)
                obj.closeGUI;
            end
        end
        
        function openGUI(obj)
            if ~isempty(obj.hGUI)
                figure(obj.hGUI);
            else
                try
                    fh = openfig(obj.guiFile,'new','invisible');
                    hObjs = guihandles(fh);
                    set(findobj(fh,'-property','Callback'),'Callback',...
                        @(src,evnt)guiCallback(obj,src,evnt));
                    formatGUIElements(hObjs);
                    obj.hGUI = fh;
                    obj.handles = hObjs;
                    obj.guiInit;
                    set(fh,'Visible','on','Name',class(obj));
                    set(fh,'CloseRequestFcn',@(src,evnt)closeGUI(obj));
                    notify(obj,'GUIOpening');
                catch ME
                    handleError(ME,true,...
                        sprintf('%s: GUI Opening Failure',class(obj)));
                    delete(fh);
                    obj.handles = [];
                    obj.hGUI = [];
                end
            end
            drawnow;
        end
        
        function closeGUI(obj)
            notify(obj,'GUIClosing');
            delete(obj.handles.figure1);
            obj.handles = [];
            obj.hGUI = [];
        end
        
    end
    
end