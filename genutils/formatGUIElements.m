function formatGUIElements(handles)
% Applies standard system-specific formatting to a handles structure of GUI
% elements
if ~isa(handles,'struct')
    return;
end

% Define parameters to apply for specific gui objects
switch computer
    case {'GLNX86','GLNXA64'}
        textFontSize = 9;
        editFontSize = 9;
        pushbuttonFontSize = 9;
    case {'PCWIN','PCWIN64'}
        textFontSize = 10;
        editFontSize = 10;
        pushbuttonFontSize = 10;
    case 'MACI64'
        textFontSize = 12;
        editFontSize = 10;
        pushbuttonFontSize = 12;
end

fieldNames = fieldnames(handles);
for iF = 1:length(fieldNames)
    obj = handles.(fieldNames{iF});
    %fprintf('%s:%s\n',fieldNames{iF},class(obj));
    switch class(obj)
        case 'matlab.ui.Figure'
        case 'matlab.graphics.axis.Axes'
        case 'matlab.ui.container.Panel'
        case 'matlab.ui.container.Menu'
            formatMenu(obj);
        case 'matlab.ui.container.Tab'
        case 'matlab.ui.control.UITable'
        case 'matlab.ui.control.UIControl'
            formatUIControl(obj);
    end
end


    function formatMenu(hObject)
        if ispc && isequal(get(hObject,'BackgroundColor'), ...
                get(0,'defaultUicontrolBackgroundColor'))
            set(hObject,'BackgroundColor','white');
        end
    end

    function formatUIControl(hObject)
        %fprintf('%s\n',get(hObject,'Style'));
        switch get(hObject,'Style')
            case 'checkbox'
            case 'togglebutton'
            case 'edit'
                if ispc && isequal(get(hObject,'BackgroundColor'), ...
                        get(0,'defaultUicontrolBackgroundColor'))
                    set(hObject,'BackgroundColor','white');
                end
                set(hObject,'FontSize',editFontSize);
            case 'text'
                set(hObject,'FontSize',textFontSize);
            case 'pushbutton'
                set(hObject,'Fontsize',pushbuttonFontSize);
            case 'popupmenu'
                if ispc && isequal(get(hObject,'BackgroundColor'), ...
                        get(0,'defaultUicontrolBackgroundColor'))
                    set(hObject,'BackgroundColor','white');
                end
            case 'radiobutton'
            case 'listbox'
                if ispc && isequal(get(hObject,'BackgroundColor'), ...
                        get(0,'defaultUicontrolBackgroundColor'))
                    set(hObject,'BackgroundColor','white');
                end
            case 'slider'
                if isequal(get(hObject,'BackgroundColor'), ...
                        get(0,'defaultUicontrolBackgroundColor'))
                    set(hObject,'BackgroundColor',[.9 .9 .9]);
                end
        end
    end

end