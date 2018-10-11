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

% Last Modified by GUIDE v2.5 28-Oct-2014 11:13:01

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
handles.ProcFlag=1;                                                        %processing+analysis default
handles.IntCutFlag=1;                                                      %default intensity thresholding
handles.BitDepth=16;
set(handles.rdbt_16bit, 'Value', 1);
set(handles.rdbtProc, 'Value', 1);
set(handles.rdbt_wsh, 'Value', 1);                                         %watershed
handles.wflag = 1;
handles.DateID = get(handles.etxDateID, 'String');
handles.NoFoci = str2double(get(handles.etxNoFoci, 'String'));             %Getting Default Values
handles.LowArea = str2double(get(handles.etxLowArea, 'String'));
handles.HighArea = str2double(get(handles.etxHighArea, 'String'));
handles.GraphWhst = 1;                                                     %graph settings
set(handles.rdbt_GraphWhst, 'Value', 1);
handles.GraphFin = 1;
set(handles.rdbt_GraphFin, 'Value', 1);
handles.GraphScat = 1;
set(handles.rdbt_GraphScat, 'Value', 1);
handles.GraphBar = 1;
set(handles.rdbt_GraphBar, 'Value', 1);
set(handles.rdbtIntNormCont, 'Value', 1);
set(handles.pop_thresh, 'Value', 1);                                       %Spot Detection thresholding
set(handles.tx_offset, 'String', 1.4);
set(handles.slider1, 'Value', str2double('1.4'));
set(handles.pop_fl1, 'Value', 2);                                          %Channel Selection
set(handles.pop_fl2, 'Value', 1);
handles.fl1chan = 1;
handles.fl2chan = 0;
guidata(hObject, handles);
%What's New:
if exist([cd '\WhatsNew.txt'], 'file')
    textin = strtrim(fileread([cd '\WhatsNew.txt']));
else
    textin = ('ChangeLog is missing! (Does not affect program functioning)');
end
whatsnewhand = msgbox(textin,'Changes in this Version');
uiwait(whatsnewhand);

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

% --- Executes when selected object is changed in uiPanelRunMode.
function uiPanelRunMode_SelectionChangeFcn(hObject, eventdata, handles)    % RUN MODE
% hObject    handle to the selected object in uiPanelRunMode
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%   EventName: string 'SelectionChanged' (read only)
%   OldValue: handle of the previously selected object or empty if none was selected
%   NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)
procflag = get(eventdata.NewValue, 'Tag');
a = 'None';
b = 'FITC';
c = 'Cy5';
s = char(a,b,c);
switch procflag
    case 'rdbtAnaly'
        clear handles.ProcFlag
        set(handles.pop_fl2, 'string', s);
        set(handles.pop_fl2, 'visible', 'on');
        handles.ProcFlag=0;
        guidata(hObject, handles);
    case 'rdbtProc'
        clear handles.ProcFlag
        if handles.fl1chan==0
            handles.fl2chan=0;
            set(handles.pop_fl2, 'value', 1);
            set(handles.pop_fl2, 'visible', 'off');
        end
        handles.ProcFlag=1;
        guidata(hObject, handles);
    case 'rdbt_stand'
        clear handles.ProcFlag
        handles.ProcFlag=0;
        
end


% --- Executes on button press in pbtDatPath.
function pbtDatPath_Callback(hObject, eventdata, handles)                  % INPUT DIR
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
    handles.LoadPathVec = ReshuffleControl(handles.LoadPathVec);
    set(handles.txContFold, 'string', handles.LoadPathVec{1,1});
    guidata(hObject, handles);
end

% --- Executes on button press in pbtReshuff.
function pbtReshuff_Callback(hObject, eventdata, handles)                  % SELECT ALTERNATE CONTROL
% hObject    handle to pbtReshuff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clear returnValue
returnValue = uigetdir(handles.ImagePath,'Select replacement control folder: ');
if returnValue ~= 0
    returnValue(returnValue=='\')='/';
    pos1 = strfind(returnValue, '/');
    pos1 = pos1(end);
    replacectr = returnValue(pos1+1:end);
    
    for aa = 1:length(handles.LoadPathVec)  %reused code, getting dir names
        resultfile{aa} = handles.LoadPathVec{aa}(pos1+1:end);
    end
    cfinder = cellfun('isempty', strfind(resultfile, replacectr));
    cidx = find(~cfinder);
    tidx = find(cfinder);
    if cidx~=1
        reshuffle{1} = handles.LoadPathVec{cidx};
        for bb = 2:length(handles.LoadPathVec)
            cc = bb-1;
            reshuffle{bb,1}=handles.LoadPathVec{tidx(cc)};
        end
    else
        reshuffle = handles.LoadPathVec;
    end
    handles.LoadPathVec = reshuffle;
end
set(handles.txContFold, 'string', handles.LoadPathVec{1,1});
guidata(hObject, handles);

% --- Executes on button press in pbtOutFold.
function pbtOutFold_Callback(hObject, eventdata, handles)                  % SET OUTPUT DIR
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


%++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% --- Executes on button press in pbtGO.
function pbtGO_Callback(hObject, eventdata, handles)                       % RUN
% hObject    handle to pbtGO (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ChanFlag = [handles.fl1chan; handles.fl2chan];
if sum(ChanFlag(:))==0
    errordlg('Please Choose At Least One Channel!')
end
tflag(1) = get(handles.pop_thresh, 'Value');
tflag(2) = get(handles.slider1, 'Value');
selcrit_inputs(1) = handles.HighArea;
selcrit_inputs(2) = handles.LowArea;
selcrit_inputs(3) = handles.NoFoci;
selcrit_inputs(4) = handles.wflag;
selcrit_inputs(5) = handles.IntCutFlag;                                    %choosing intensity threshold (at 'run' time to avoid conflicts)
if handles.IntCutFlag==3
    selcrit_inputs(6) = str2double(get(handles.etx_IntVal, 'string'));
elseif handles.IntCutFlag==4
    selcrit_inputs(6) = str2double(get(handles.etx_IntVal2, 'string'));
else
    selcrit_inputs(6) = 0;
end
selcrit_inputs(7)=handles.BitDepth;
graph_flags(1) = handles.GraphScat;
graph_flags(2) = handles.GraphBar;
graph_flags(3) = handles.GraphWhst;
graph_flags(4) = handles.GraphFin;
gettext = get(handles.etxNotes, 'string');
fileID = [handles.OutputFolder '/ExperimentNotes.txt' ];
fid = fopen(fileID, 'w');
fprintf(fid, gettext);
fclose(fid);

ImgLoader2(handles.DateID,handles.OutputFolder,handles.LoadPathVec,handles.ProcFlag, selcrit_inputs, graph_flags, ChanFlag, tflag)
%++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


% --- Executes when selected object is changed in uipIntCut.
function uipIntCut_SelectionChangeFcn(hObject, eventdata, handles)         % INTENSITY CUTOFF
% hObject    handle to the selected object in uipIntCut
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)
intflag = get(eventdata.NewValue, 'Tag');
switch intflag
    case 'rdbtIntNormCont'
        clear handles.IntCutFlag
        handles.IntCutFlag = 1;
        guidata(hObject, handles);
    case 'rdbt_Int2sd'
        clear handles.IntCutFlag
        handles.IntCutFlag = 2;
        guidata(hObject, handles);
    case 'rdbt_IntVal'
        gettext = str2double(get(handles.etx_IntVal, 'string'));
        handles.IntCutFlag = 3;
        handles.IntVal = gettext;
        guidata(hObject, handles);
    case 'rdbt_IntVal2'
        gettext = str2double(get(handles.etx_IntVal2, 'string'));
        handles.IntCutFlag = 4;
        handles.IntVal = gettext;
        guidata(hObject, handles);
end



% --- Executes on button press in pbtHelp.
function pbtHelp_Callback(hObject, eventdata, handles)                     % HELPFILE
% hObject    handle to pbtHelp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if exist([cd '\ReadMe.txt'], 'file')
    textin = strtrim(fileread([cd '\ReadMe.txt']));
else
    textin = ('missing readme file!');
end
msgbox(textin,'Help Box')


% --- Executes on button press in rdbt_wsh.
function rdbt_wsh_Callback(hObject, eventdata, handles)                    % WATERSHED
% hObject    handle to rdbt_wsh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rdbt_wsh
handles.wflag = get(hObject, 'Value');
guidata(hObject, handles)

% --- Executes on selection change in pop_nuc.
function pop_nuc_Callback(hObject, eventdata, handles)                      % SELECT NUCLEAR CHANNEL
% hObject    handle to pop_nuc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pop_nuc contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pop_nuc


% --- Executes on selection change in pop_fl1.
function pop_fl1_Callback(hObject, eventdata, handles)                      % SELECT CHANNEL 1
% hObject    handle to pop_fl1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pop_fl1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pop_fl1

indexval = get(hObject, 'Value');  %If you use get(handles.fl2chan) it doesn't update unless you re-start the GUI!
a = 'None';
b = 'FITC';
c = 'Cy5';
s = char(a,b,c);
switch indexval
    case 1
        handles.fl1chan = 0; %fl1 is none
        if handles.ProcFlag==1
            set(handles.pop_fl2, 'value', 1);
            set(handles.pop_fl2, 'visible', 'off');
        elseif handles.ProcFlag==2
            set(handles.pop_fl2, 'string', s);
            set(handles.pop_fl2, 'visible', 'on');
        end
        guidata(hObject, handles)
    case 2
        handles.fl1chan = 1; %fl1 is FITC
        set(handles.pop_fl2, 'string', s);
        set(handles.pop_fl2, 'visible', 'on');
        guidata(hObject, handles);
    case 3
        handles.fl1chan = 2; %fl1 is Cy5
        set(handles.pop_fl2, 'string', s);
        set(handles.pop_fl2, 'visible', 'on');
        guidata(hObject, handles);
end

% --- Executes on selection change in pop_fl2.
function pop_fl2_Callback(hObject, eventdata, handles)                     % SELECT CHANNEL 2
% hObject    handle to pop_fl2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pop_fl2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pop_fl2

indexval = get(hObject, 'Value');  %If you use get(handles.fl2chan) it doesn't update unless you re-start the GUI!
switch indexval
    case 1
        handles.fl2chan = 0; %fl2 is none
        guidata(hObject, handles)
    case 2
        handles.fl2chan = 1; %fl2 is FITC
        guidata(hObject, handles);
    case 3
        handles.fl2chan = 2; %fl2 is Cy5
        guidata(hObject, handles);
end


% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)                 % RUN STANDARDIZATION MODE (SpotPrinter.m)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
currdir = cd;
currdir(currdir=='\')='/';
run([currdir '/' 'SpotPrinter.m'])

% --- Executes when selected object is changed in uipanel_bitdepth.
function uipanel_bitdepth_SelectionChangeFcn(hObject, eventdata, handles)  % IMAGE BIT DEPTH
% hObject    handle to the selected object in uipanel_bitdepth
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)
bitdepth = get(eventdata.NewValue, 'Tag');
switch bitdepth
    case 'rdbt_16bit'
        clear handles.BitDepth
        handles.BitDepth=16;
        guidata(hObject, handles);
    case 'rdbt_14bit'
        clear handles.BitDepth
        handles.BitDepth=14;
        guidata(hObject, handles);
    case 'rdbt_12bit'
        clear handles.BitDepth
        handles.BitDepth=12;
        guidata(hObject, handles);
end

% --- Executes on button press in pbt_savesettings.
function pbt_savesettings_Callback(hObject, eventdata, handles)            % SAVE SETTINGS
% hObject    handle to pbt_savesettings (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.IntCutFlag==3
    int_multip = str2double(get(handles.etx_IntVal, 'string'));
elseif handles.IntCutFlag==4
    int_multip = str2double(get(handles.etx_IntVal2, 'string'));
else
    int_multip = 0;
end
uisave({'handles','int_multip'}, 'FC_Settings.mat');

% --- Executes on button press in pbt_loadsettings.
function pbt_loadsettings_Callback(hObject, eventdata, handles)            % LOAD SETTINGS
% hObject    handle to pbt_loadsettings (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[infile inloc] = uigetfile;
if exist(infile, 'file')==2 %If it exists as a file
    initialValues = load(infile);
    handles.LowArea = initialValues.handles.LowArea;
    handles.HighArea = initialValues.handles.HighArea;
    handles.NoFoci = initialValues.handles.NoFoci;
    handles.IntCutFlag = initialValues.handles.IntCutFlag;
    set(handles.etxLowArea, 'string', handles.LowArea);
    set(handles.etxHighArea, 'string', handles.HighArea);
    set(handles.etxNoFoci, 'string', handles.NoFoci);
    switch handles.IntCutFlag
        case 1
            set(handles.rdbt_IntNormCont, 'Value',1)
        case 2
            set(handles.rdbt_Int2sd, 'Value',1)
        case 3
            set(handles.rdbt_IntVal, 'Value',1)
            set(handles.etx_IntVal, 'string', initialValues.int_multip);
        case 4
            set(handles.rdbt_IntVal2, 'Value',1)
            set(handles.etx_IntVal2, 'string', initialValues.int_multip);
    end
end
guidata(hObject, handles);


% --- Executes on selection change in pop_thresh.
function pop_thresh_Callback(hObject, eventdata, handles)                  % SPOT DETECTOR THRESHOLDING CHANGER
% hObject    handle to pop_thresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pop_thresh contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pop_thresh
indexval = get(handles.pop_thresh, 'Value');
switch indexval
    case 1
        set(handles.slider1,'Value', str2double('1.4'));
        set(handles.tx_offset, 'String', '1.4');
        guidata(hObject, handles);
    case 2
        set(handles.slider1,'Value', str2double('1'));
        set(handles.tx_offset, 'String', '1');
        guidata(hObject, handles);
    case 3
        set(handles.slider1,'Value', str2double('1'));
        set(handles.tx_offset, 'String', '1');
        guidata(hObject, handles);
end

%__________________________________________________________________________
%__________________________________________________________________________
%createfcns and unused callbacks:

function etx_IntVal_Callback(hObject, eventdata, handles)
% hObject    handle to etx_IntVal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of etx_IntVal as text
%        str2double(get(hObject,'String')) returns contents of etx_IntVal as a double
handles.IntVal = str2double(get(handles.etx_IntVal, 'String'));
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function etx_IntVal_CreateFcn(hObject, eventdata, handles)
% hObject    handle to etx_IntVal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
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

function etx_IntVal2_Callback(hObject, eventdata, handles)                 %INT VAL FOR HARD CODED CUTOFF
% hObject    handle to etx_IntVal2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of etx_IntVal2 as text
%        str2double(get(hObject,'String')) returns contents of etx_IntVal2 as a double
handles.IntVal = str2double(get(handles.etx_IntVal2, 'String'));
guidata(hObject, handles);

%__________________________________________________________________________



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


% --- Executes during object creation, after setting all properties.
function etx_IntVal2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to etx_IntVal2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function pop_thresh_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pop_thresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject, 'String', {'Otsu';'K-Means based'; 'Gradient Based'});

% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)                     % SLIDER MOVEMENT
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
returnval = get(handles.slider1, 'Value');
returnval = round(returnval*100)/100;
set(handles.tx_offset, 'String', returnval);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes during object creation, after setting all properties.
function pop_nuc_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pop_nuc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function pop_fl1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pop_fl1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function pop_fl2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pop_fl2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pbt_FL1.
function pbt_FL1_Callback(hObject, eventdata, handles)
% hObject    handle to pbt_FL1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.arpanel_fl1, 'Visible', 'on');
set(handles.uipIntCut, 'Visible', 'on');
set(handles.uipIntCut_fl2, 'Visible', 'off');
set(handles.arpanel_fl2, 'Visible', 'off');
set(hObject, 'BackgroundColor', [1 1 1]);
set(hObject, 'FontWeight', 'Bold');
set(handles.pbt_FL2, 'BackgroundColor', [0.86 0.86 0.86]);
set(handles.pbt_FL2, 'FontWeight', 'Normal');
guidata(hObject, handles);

% --- Executes on button press in pbt_FL2.
function pbt_FL2_Callback(hObject, eventdata, handles)
% hObject    handle to pbt_FL2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.uipIntCut_fl2, 'Visible', 'on');
set(handles.arpanel_fl2, 'Visible', 'on');
set(handles.uipIntCut, 'Visible', 'off');
set(handles.arpanel_fl1, 'Visible', 'off');
set(hObject, 'BackgroundColor', [1 1 1]);
set(hObject, 'FontWeight', 'Bold');
set(handles.pbt_FL1, 'BackgroundColor', [0.86 0.86 0.86]);
set(handles.pbt_FL1, 'FontWeight', 'Normal');
guidata(hObject, handles)



function etx_IntVal_fl2_Callback(hObject, eventdata, handles)
% hObject    handle to etx_IntVal_fl2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of etx_IntVal_fl2 as text
%        str2double(get(hObject,'String')) returns contents of etx_IntVal_fl2 as a double


% --- Executes during object creation, after setting all properties.
function etx_IntVal_fl2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to etx_IntVal_fl2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function etx_IntVal2_fl2_Callback(hObject, eventdata, handles)
% hObject    handle to etx_IntVal2_fl2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of etx_IntVal2_fl2 as text
%        str2double(get(hObject,'String')) returns contents of etx_IntVal2_fl2 as a double


% --- Executes during object creation, after setting all properties.
function etx_IntVal2_fl2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to etx_IntVal2_fl2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function etx_LowArea_fl2_Callback(hObject, eventdata, handles)
% hObject    handle to etx_LowArea_fl2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of etx_LowArea_fl2 as text
%        str2double(get(hObject,'String')) returns contents of etx_LowArea_fl2 as a double


% --- Executes during object creation, after setting all properties.
function etx_LowArea_fl2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to etx_LowArea_fl2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function etx_HighArea_fl2_Callback(hObject, eventdata, handles)
% hObject    handle to etx_HighArea_fl2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of etx_HighArea_fl2 as text
%        str2double(get(hObject,'String')) returns contents of etx_HighArea_fl2 as a double


% --- Executes during object creation, after setting all properties.
function etx_HighArea_fl2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to etx_HighArea_fl2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit8_Callback(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit8 as text
%        str2double(get(hObject,'String')) returns contents of edit8 as a double


% --- Executes during object creation, after setting all properties.
function edit8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit9_Callback(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit9 as text
%        str2double(get(hObject,'String')) returns contents of edit9 as a double


% --- Executes during object creation, after setting all properties.
function edit9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function arpanel_fl1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to arpanel_fl1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function uipIntCut_CreateFcn(hObject, eventdata, handles)
% hObject    handle to uipIntCut (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
