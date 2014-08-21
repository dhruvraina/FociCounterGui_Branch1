%Author: Dhruv Raina
%Last Edit: 080814

function varargout = focicountergui(varargin)
% FOCICOUNTERGUI M-file for focicountergui.fig
%      FOCICOUNTERGUI, by itself, creates a new FOCICOUNTERGUI or raises the existing
%      singleton*.
%
%      H = FOCICOUNTERGUI returns the handle to a new FOCICOUNTERGUI or the handle to
%      the existing singleton*.
%
%      FOCICOUNTERGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FOCICOUNTERGUI.M with the given input arguments.
%
%      FOCICOUNTERGUI('Property','Value',...) creates a new FOCICOUNTERGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before focicountergui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to focicountergui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help focicountergui

% Last Modified by GUIDE v2.5 21-Aug-2014 11:23:48

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @focicountergui_OpeningFcn, ...
    'gui_OutputFcn',  @focicountergui_OutputFcn, ...
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

%==========================================================================
%Initialization Code:

% --- Executes just before focicountergui is made visible.
function focicountergui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to focicountergui (see VARARGIN)

% Choose default command line output for focicountergui
handles.output = hObject;
handles.ImagePath = cd;
handles.OutputFolder = cd;
iniFile = fullfile(handles.ImagePath, 'FociCount_ini.mat');
if exist(iniFile, 'file')==2 %If it exists as a file
    initialValues = load(iniFile);
    if isfield(initialValues,'lastUsedImageFolder')
    handles.ImagePath = initialValues.lastUsedImageFolder; %From magicgui.m//matlabcentral.com
    end
    if isfield(initialValues,'lastUsedOutFolder')
    handles.OutputFolder = initialValues.lastUsedOutFolder;
    end
end
handles.ProcFlag=1; %processing+analysis default
handles.ChanFlag=1; %DAPI+FITC Default
handles.IntCutFlag=1; %un-normalized default
set(handles.rdbtProc, 'Value', 1);
set(handles.rdbt_fitc, 'Value', 1);
set(handles.rdbt_wsh, 'Value', 1);
handles.DateID = get(handles.etxDateID, 'String');
handles.NoFoci = str2double(get(handles.etxNoFoci, 'String')); %Getting Default Values
handles.LowArea = str2double(get(handles.etxLowArea, 'String'));
handles.HighArea = str2double(get(handles.etxHighArea, 'String'));
handles.GraphWhst = 1;
set(handles.rdbt_GraphWhst, 'Value', 1);
handles.GraphFin = 1;
set(handles.rdbt_GraphFin, 'Value', 1);
handles.GraphScat = 1;
set(handles.rdbt_GraphScat, 'Value', 1);
handles.GraphBar = 1;
set(handles.rdbt_GraphBar, 'Value', 1);
guidata(hObject, handles);


% UIWAIT makes focicountergui wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = focicountergui_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in rdbtAnaly.
function rdbtAnaly_Callback(hObject, eventdata, handles)
% hObject    handle to rdbtAnaly (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rdbtAnaly

% --- Executes on button press in rdbtProc.
function rdbtProc_Callback(hObject, eventdata, handles)
% hObject    handle to rdbtProc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rdbtProc

% --- Executes when selected object is changed in uiPanelRunMode.
function uiPanelRunMode_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uiPanelRunMode
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%   EventName: string 'SelectionChanged' (read only)
%   OldValue: handle of the previously selected object or empty if none was selected
%   NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)
procflag = get(eventdata.NewValue, 'Tag');
switch procflag
    case 'rdbtAnaly'
        clear handles.ProcFlag
        handles.ProcFlag=0;
        guidata(hObject, handles);
    case 'rdbtProc'
        clear handles.ProcFlag
        handles.ProcFlag=1;
        guidata(hObject, handles);
end


% --- Executes on button press in pbtDatPath.
function pbtDatPath_Callback(hObject, eventdata, handles)
% hObject    handle to pbtDatPath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% returnValue will be 0 (a double) if they click cancel.
% returnValue will be the path (a string) if they clicked OK.
clear returnValue
returnValue = uigetdir(handles.ImagePath,'Select folder');
if returnValue ~= 0
    % Assign the value if they didn't click cancel.
    handles.MainFolder = returnValue;
    handles.SubFolder = dir(returnValue);
    handles.MainFolder(handles.MainFolder=='\')='/';
    % Save the image folder in our ini file.
    lastUsedImageFolder = handles.MainFolder;
    save('FociCount_ini.mat', 'lastUsedImageFolder');
    sprinter = {};
for aa = 3:length(handles(:).SubFolder)
    bb=aa-2;
    foldvec{bb} = [handles.MainFolder '/' handles.SubFolder(aa).name];
    sprinter = [char(sprinter) '\n' char(foldvec{bb})];
end
handles.LoadPathVec=foldvec';
%sprinter = sprintf(sprinter);
%set(handles.lbxInputFold, 'string', sprinter); %Works for static text
set(handles.lbxInputFold, 'string', foldvec);
set(handles.txContFold, 'string', handles.LoadPathVec{1,1});
guidata(hObject, handles);
end

% --- Executes on button press in pbtReshuff.
function pbtReshuff_Callback(hObject, eventdata, handles)
% hObject    handle to pbtReshuff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.LoadPathVec = ReshuffleControl(handles.LoadPathVec);
set(handles.txContFold, 'string', handles.LoadPathVec{1,1});
guidata(hObject, handles);

% --- Executes on button press in pbtOutFold.
function pbtOutFold_Callback(hObject, eventdata, handles)
% hObject    handle to pbtOutFold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
returnValue = uigetdir(handles.OutputFolder, 'Select Output Folder');   
if returnValue ~= 0
    % Assign the value if they didn't click cancel.
    handles.OutputFolder = returnValue;
    handles.OutputFolder(handles.OutputFolder=='\')='/';
    guidata(hObject, handles);
    % Save the image folder in our ini file.
    lastUsedOutFolder = handles.OutputFolder;
    save('FociCount_ini.mat', 'lastUsedOutFolder', '-append');
set(handles.txOutput, 'String', handles.OutputFolder);
guidata(hObject, handles);
end

function etxDateID_Callback(hObject, eventdata, handles)
% hObject    handle to etxDateID (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of etxDateID as text
%        str2double(get(hObject,'String')) returns contents of etxDateID as a double
handles.DateID = get(handles.etxDateID, 'String');
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function etxDateID_CreateFcn(hObject, eventdata, handles)
% hObject    handle to etxDateID (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function etxLowArea_Callback(hObject, eventdata, handles)
% hObject    handle to etxLowArea (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of etxLowArea as text
%        str2double(get(hObject,'String')) returns contents of etxLowArea as a double
handles.LowArea = str2double(get(handles.etxLowArea, 'String'));
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function etxLowArea_CreateFcn(hObject, eventdata, handles)
% hObject    handle to etxLowArea (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function etxHighArea_Callback(hObject, eventdata, handles)
% hObject    handle to etxHighArea (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of etxHighArea as text
%        str2double(get(hObject,'String')) returns contents of etxHighArea as a double
handles.HighArea = str2double(get(handles.etxHighArea, 'String'));
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function etxHighArea_CreateFcn(hObject, eventdata, handles)
% hObject    handle to etxHighArea (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function etxNoFoci_Callback(hObject, eventdata, handles)
% hObject    handle to etxNoFoci (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of etxNoFoci as text
%        str2double(get(hObject,'String')) returns contents of etxNoFoci as a double
handles.NoFoci = str2double(get(handles.etxNoFoci, 'String'));
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function etxNoFoci_CreateFcn(hObject, eventdata, handles)
% hObject    handle to etxNoFoci (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% --- Executes on button press in pbtGO.
function pbtGO_Callback(hObject, eventdata, handles)
% hObject    handle to pbtGO (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

selcrit_inputs(1) = handles.HighArea;
selcrit_inputs(2) = handles.LowArea;
selcrit_inputs(3) = handles.NoFoci;
selcrit_inputs(4) = handles.rdbt_wsh;

graph_flags(1) = handles.GraphScat;
graph_flags(2) = handles.GraphBar;
graph_flags(3) = handles.GraphWhst;
graph_flags(4) = handles.GraphFin;
gettext = get(handles.etxNotes, 'string');
fileID = [handles.OutputFolder '/ExperimentNotes.txt' ];
fid = fopen(fileID, 'w');
fprintf(fid, gettext);
fclose(fid);
ImgLoader2(handles.DateID,handles.OutputFolder,handles.LoadPathVec,handles.ProcFlag, selcrit_inputs, graph_flags, handles.ChanFlag)
%++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% --- Executes on button press in rdbtIntDef.
function rdbtIntDef_Callback(hObject, eventdata, handles)
% hObject    handle to rdbtIntDef (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rdbtIntDef


% --- Executes on button press in rdbtIntNormCont.
function rdbtIntNormCont_Callback(hObject, eventdata, handles)
% hObject    handle to rdbtIntNormCont (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rdbtIntNormCont



% --- Executes on button press in rdbt_GraphWhst.
function rdbt_GraphWhst_Callback(hObject, eventdata, handles)
% hObject    handle to rdbt_GraphWhst (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rdbt_GraphWhst
handles.GraphWhst = get(handles.rdbt_GraphWhst, 'Value');
guidata(hObject,handles);

% --- Executes on button press in rdbt_GraphFin.
function rdbt_GraphFin_Callback(hObject, eventdata, handles)
% hObject    handle to rdbt_GraphFin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rdbt_GraphFin
handles.GraphFin = get(handles.rdbt_GraphFin, 'Value');
guidata(hObject,handles);

% --- Executes on button press in rdbt_GraphScat.
function rdbt_GraphScat_Callback(hObject, eventdata, handles)
% hObject    handle to rdbt_GraphScat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rdbt_GraphScat
handles.GraphScat = get(handles.rdbt_GraphScat, 'Value');
guidata(hObject,handles);

% --- Executes on button press in rdbt_GraphBar.
function rdbt_GraphBar_Callback(hObject, eventdata, handles)
% hObject    handle to rdbt_GraphBar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rdbt_GraphBar
handles.GraphBar = get(handles.rdbt_GraphBar, 'Value');
guidata(hObject,handles);


% --- Executes on selection change in lbxInputFold.
function lbxInputFold_Callback(hObject, eventdata, handles)
% hObject    handle to lbxInputFold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns lbxInputFold contents as cell array
%        contents{get(hObject,'Value')} returns selected item from lbxInputFold


% --- Executes during object creation, after setting all properties.
function lbxInputFold_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lbxInputFold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when selected object is changed in uipIntCut.
function uipIntCut_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uipIntCut
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)
intflag = get(eventdata.NewValue, 'Tag');
switch intflag
    case 'rdbtIntDef'
        clear handles.IntCutFlag
        handles.IntCutFlag=1;
        guidata(hObject, handles);
    case 'rdbtIntNormCont'
        clear handles.IntCutFlag
        handles.ProcFlag=0;
        guidata(hObject, handles);
end


function etxNotes_Callback(hObject, eventdata, handles)
% hObject    handle to etxNotes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of etxNotes as text
%        str2double(get(hObject,'String')) returns contents of etxNotes as a double


% --- Executes during object creation, after setting all properties.
function etxNotes_CreateFcn(hObject, eventdata, handles)
% hObject    handle to etxNotes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in pbtHelp.
function pbtHelp_Callback(hObject, eventdata, handles)
% hObject    handle to pbtHelp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if exist([cd '\ReadMe.txt'], 'file')
    textin = fileread([cd '\ReadMe.txt']);
else
    textin = ('missing readme file!');
end
msgbox(textin,'Help Box')


% --- Executes on button press in rdbt_wsh.
function rdbt_wsh_Callback(hObject, eventdata, handles)
% hObject    handle to rdbt_wsh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rdbt_wsh


%Watershed! Needs to be added!

% --- Executes when selected object is changed in uip_channel.
function uip_channel_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uip_channel 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)
chanflag = get(eventdata.NewValue, 'Tag');
switch chanflag
    case 'rdbt_fitc'
        clear handles.ChanFlag
        handles.ChanFlag=1;
        guidata(hObject, handles);
    case 'rdbt_cy5'
        clear handles.ChanFlag
        handles.ChanFlag=2;
        guidata(hObject, handles);
    case 'rdbt_cy5only'
        clear handles.ChanFlag
        handles.ChanFlag=3;
        guidata(hObject, handles);
end


% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
currdir = cd;
currdir(currdir=='\')='/';
run([currdir '/' 'SpotPrinter.m'])
