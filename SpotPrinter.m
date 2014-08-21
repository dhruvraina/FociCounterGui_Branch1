function varargout = SpotPrinter(varargin)
% SPOTPRINTER M-file for SpotPrinter.fig
%      SPOTPRINTER, by itself, creates a new SPOTPRINTER or raises the existing
%      singleton*.
%
%      H = SPOTPRINTER returns the handle to a new SPOTPRINTER or the handle to
%      the existing singleton*.
%
%      SPOTPRINTER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SPOTPRINTER.M with the given input arguments.
%
%      SPOTPRINTER('Property','Value',...) creates a new SPOTPRINTER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before SpotPrinter_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to SpotPrinter_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help SpotPrinter

% Last Modified by GUIDE v2.5 20-Aug-2014 16:49:15

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @SpotPrinter_OpeningFcn, ...
    'gui_OutputFcn',  @SpotPrinter_OutputFcn, ...
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


% --- Executes just before SpotPrinter is made visible.
function SpotPrinter_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to SpotPrinter (see VARARGIN)

% Choose default command line output for SpotPrinter
handles.output = hObject;

handles.ImagePath = cd;
handles.OutputFolder = cd;
iniFile = fullfile(handles.ImagePath, 'SpotPrinter_ini.mat');
if exist(iniFile, 'file')==2 %If it exists as a file
    initialValues = load(iniFile);
    if isfield(initialValues,'lastUsedInFolder')
        handles.ImagePath = initialValues.lastUsedInFolder; %From magicgui.m//matlabcentral.com
    end
    if isfield(initialValues,'lastUsedOutFolder')
        handles.OutputFolder = initialValues.lastUsedOutFolder;
    end
end
handles.RunFlag = 0;
handles.NoFoci = 10;
handles.HiIntCut = 65535;
handles.LowIntCut = 0;
handles.LowArCut = 7;
handles.HiArCut = 60;
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes SpotPrinter wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = SpotPrinter_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)                 %RUNNNNN!!!
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
InputVars{1} = handles.RunFlag;
InputVars{2} = handles.HiArCut;
InputVars{3} = handles.LowArCut;
InputVars{4} = handles.LowIntCut;
InputVars{5} = handles.HiIntCut;
spotprinter_backend(handles.TestFile, handles.OutputFolder, InputVars);

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
returnValue = uigetdir(handles.OutputFolder, 'Select Output Folder');      %Image outputs
if returnValue ~= 0
    % Assign the value if they didn't click cancel.
    handles.OutputFolder = [returnValue '/'];
    handles.OutputFolder(handles.OutputFolder=='\')='/';
    guidata(hObject, handles);
    % Save the image folder in our ini file.
    lastUsedOutFolder = handles.OutputFolder;
    save('SpotPrinter_ini.mat', 'lastUsedOutFolder', '-append');
    guidata(hObject, handles);
end

% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)                 %LOAD IMAGES
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clear returnValue
[filename, pathname] = uigetfile(handles.ImagePath,'Select folder');
if pathname ~= 0
    % Assign the value if they didn't click cancel.
    handles.TestFile = [pathname filename];
    handles.TestFile(handles.TestFile=='\')='/';
    % Save the image folder in our ini file.
    lastUsedInFolder = pathname;
    save('SpotPrinter_ini.mat', 'lastUsedInFolder');
    load(handles.TestFile);
    int_cutoffO = int_cutoffL*65535;
    set(handles.edit4, 'String', int_cutoffO)
    handles.LowIntCut = int_cutoffL;
    guidata(hObject, handles);
end


function edit3_Callback(hObject, eventdata, handles)                       %NUMBER OF FOCI CUTOFF
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double
handles.NoFoci = str2double(get(handles.edit3, 'String'));
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit1_Callback(hObject, eventdata, handles)                       %LOW AREA CUTOFF
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double
handles.LowArCut = str2double(get(handles.edit1, 'String'));
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit2_Callback(hObject, eventdata, handles)                       %HIGH AREA CUTOFF
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double
handles.HiArCut = str2double(get(handles.edit2, 'String'));
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when selected object is changed in uipanel4.     
function uipanel4_SelectionChangeFcn(hObject, eventdata, handles)          %RUN MODE
% hObject    handle to the selected object in uipanel4
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)

runflag = get(eventdata.NewValue, 'Tag');
switch runflag
    case 'radiobutton1' %Run One Image
        clear handles.RunFlag
        handles.RunFlag=0;
        guidata(hObject, handles);
    case 'radiobutton2' %Run Multiple Images
        clear handles.RunFlag
        handles.RunFlag=1;
        guidata(hObject, handles);
end



function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double
handles.LowIntCut = str2double(get(handles.edit4, 'String'));
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double
handles.HiIntCut = str2double(get(handles.edit5, 'String'));
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)                 %Calculate Control Intensities for Cutoffs
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clear returnValue
[filename, pathname] = uigetfile(handles.ImagePath,'Select Control for Cutoff Determination: ');
if pathname ~= 0
    % Assign the value if they didn't click cancel.
    handles.ControlPath = [pathname filename];
    handles.ControlPath(handles.ControlPath=='\')='/';
load(handles.ControlPath);
    int_cutoffO = int_cutoffL*65535;
    set(handles.edit4, 'String', int_cutoffO)
    handles.LowIntCut = int_cutoffL;
    guidata(hObject, handles);
end
