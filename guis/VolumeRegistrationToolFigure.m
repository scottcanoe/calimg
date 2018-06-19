function varargout = VolumeRegistrationToolFigure(varargin)
% VOLUMEREGISTRATIONTOOLFIGURE MATLAB code for VolumeRegistrationToolFigure.fig
%      VOLUMEREGISTRATIONTOOLFIGURE, by itself, creates a new VOLUMEREGISTRATIONTOOLFIGURE or raises the existing
%      singleton*.
%
%      H = VOLUMEREGISTRATIONTOOLFIGURE returns the handle to a new VOLUMEREGISTRATIONTOOLFIGURE or the handle to
%      the existing singleton*.
%
%      VOLUMEREGISTRATIONTOOLFIGURE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in VOLUMEREGISTRATIONTOOLFIGURE.M with the given input arguments.
%
%      VOLUMEREGISTRATIONTOOLFIGURE('Property','Value',...) creates a new VOLUMEREGISTRATIONTOOLFIGURE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before VolumeRegistrationToolFigure_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to VolumeRegistrationToolFigure_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help VolumeRegistrationToolFigure

% Last Modified by GUIDE v2.5 19-Jun-2018 11:11:02

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @VolumeRegistrationToolFigure_OpeningFcn, ...
                   'gui_OutputFcn',  @VolumeRegistrationToolFigure_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before VolumeRegistrationToolFigure is made visible.
function VolumeRegistrationToolFigure_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to VolumeRegistrationToolFigure (see VARARGIN)

% Choose default command line output for VolumeRegistrationToolFigure
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes VolumeRegistrationToolFigure wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = VolumeRegistrationToolFigure_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in LoadReferenceVolumeButton.
function LoadReferenceVolumeButton_Callback(hObject, eventdata, handles)
% hObject    handle to LoadReferenceVolumeButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in LoadTestVolumeButton.
function LoadTestVolumeButton_Callback(hObject, eventdata, handles)
% hObject    handle to LoadTestVolumeButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in RefreshButton.
function RefreshButton_Callback(hObject, eventdata, handles)
% hObject    handle to RefreshButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function XTrimLabel_Callback(hObject, eventdata, handles)
% hObject    handle to XTrimLabel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of XTrimLabel as text
%        str2double(get(hObject,'String')) returns contents of XTrimLabel as a double


% --- Executes during object creation, after setting all properties.
function XTrimLabel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to XTrimLabel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function YTrimLabel_Callback(hObject, eventdata, handles)
% hObject    handle to YTrimLabel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of YTrimLabel as text
%        str2double(get(hObject,'String')) returns contents of YTrimLabel as a double


% --- Executes during object creation, after setting all properties.
function YTrimLabel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to YTrimLabel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ZTrimLabel_Callback(hObject, eventdata, handles)
% hObject    handle to ZTrimLabel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ZTrimLabel as text
%        str2double(get(hObject,'String')) returns contents of ZTrimLabel as a double


% --- Executes during object creation, after setting all properties.
function ZTrimLabel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ZTrimLabel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in EstimateDisplacementButton.
function EstimateDisplacementButton_Callback(hObject, eventdata, handles)
% hObject    handle to EstimateDisplacementButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
