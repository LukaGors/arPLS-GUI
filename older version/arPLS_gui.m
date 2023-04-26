function varargout = arPLS_gui(varargin)
% ARPLS_GUI MATLAB code for arPLS_gui.fig
%      ARPLS_GUI, by itself, creates a new ARPLS_GUI or raises the existing
%      singleton*.
%
%      H = ARPLS_GUI returns the handle to a new ARPLS_GUI or the handle to
%      the existing singleton*.
%
%      ARPLS_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ARPLS_GUI.M with the given input arguments.
%
%      ARPLS_GUI('Property','Value',...) creates a new ARPLS_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before arPLS_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to arPLS_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help arPLS_gui

% Last Modified by GUIDE v2.5 29-Jan-2020 16:20:57

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @arPLS_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @arPLS_gui_OutputFcn, ...
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


% --- Executes just before arPLS_gui is made visible.
function arPLS_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to arPLS_gui (see VARARGIN)
clc;
% Check and set path
fileLocationAndName = mfilename('fullpath');
[~,name,~] = fileparts(fileLocationAndName);
currentLocationToTest = [pwd filesep name];
if strcmp(fileLocationAndName,currentLocationToTest)
    addpath(pwd);
    savepath;
end
% Setup
set(handles.exportFitToFile, 'Enable', 'off');
set(handles.exportFitToWorkspace, 'Enable', 'off');
set(handles.listOfVariables, 'Enable', 'off');
set(handles.includePotentials, 'Enable', 'off');
set(handles.reversPeaks, 'Enable', 'off');
set(handles.fit, 'Enable', 'off');
set(handles.varBeg, 'Enable', 'off');
set(handles.varEnd, 'Enable', 'off');
set(handles.plotSignalsWithoutBkg, 'Enable', 'off');
set(handles.includeCurves, 'Enable', 'off');
set(handles.includeAll, 'Enable', 'off');
set(handles.excludeAll, 'Enable', 'off');
set(handles.includeEndsCheck,'Enable', 'off');
set(handles.includeEndsValue,'Enable', 'off');
set(handles.refineWeightsCheck,'Enable', 'off');
set(handles.refineWeightsValue,'Enable', 'off');
set(handles.includePotentials, 'Value', 0);
set(handles.reversPeaks, 'Value', 0);
set(handles.includeEndsCheck, 'Value', 0);
set(handles.includeCurves,'Data',{});
handles.selectedVariable = 0;
handles.background = 0;
handles.weights = 0;
handles.variableWithoutBkg = 0;
handles.plotSwitch = 1;
handles.lambdaValue = 10^(get(handles.lambdaSlider,'Value'));
handles.ratioValue = 10^-(get(handles.ratioSlider,'Value'));
handles.maxIterationsMin = 1;
handles.maxIterationsMax = 1000;
handles.refineWeightsValueMin = 0.001;
handles.refineWeightsValueMax = 0.5;
set(handles.maxIterations,'Value',str2double(get(handles.maxIterations,'String')));
set(handles.includeEndsValue,'Value',str2double(get(handles.includeEndsValue,'String')));
set(handles.refineWeightsValue,'Value',str2double(get(handles.refineWeightsValue,'String')));

% Choose default command line output for arPLS_gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes arPLS_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = arPLS_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on slider movement.
function lambdaSlider_Callback(hObject, eventdata, handles)
% hObject    handle to lambdaSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
handles.lambdaValue = 10^(get(hObject,'Value'));
set(handles.lambdaText,'String',handles.lambdaValue);
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function lambdaSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lambdaSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


function lambdaText_Callback(hObject, eventdata, handles)
% hObject    handle to lambdaText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of lambdaText as text
%        str2double(get(hObject,'String')) returns contents of lambdaText as a double
val = log10(str2double(get(hObject,'String')));
if val >= get(handles.lambdaSlider,'Min') && val <= get(handles.lambdaSlider,'Max')
    handles.lambdaValue = str2double(get(hObject,'String'));
    set(handles.lambdaSlider,'Value',val);
else
    warndlg(sprintf('Lambda out of range MIN(%g) - MAX(%g)',10^get(handles.lambdaSlider,'Min'),10^get(handles.lambdaSlider,'Max')),'Warning');
    valSlid = get(handles.lambdaSlider,'Min');
    valText = 10^valSlid;
    handles.lambdaValue = valText;
    set(handles.lambdaSlider,'Value',valSlid);
    set(handles.lambdaText,'Value',valText);
    set(handles.lambdaText,'String',valText);
end
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function lambdaText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lambdaText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in includeEndsCheck.
function includeEndsCheck_Callback(hObject, eventdata, handles)
% hObject    handle to includeEndsCheck (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of includeEndsCheck
if get(hObject,'Value')
    set(handles.includeEndsValue, 'Enable', 'on');
else
    set(handles.includeEndsValue, 'Enable', 'off');
end
guidata(hObject, handles);


function includeEndsValue_Callback(hObject, eventdata, handles)
% hObject    handle to includeEndsValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of includeEndsValue as text
%        str2double(get(hObject,'String')) returns contents of includeEndsValue as a double
val = str2double(get(hObject,'String'));
if val >= handles.includeEndsValueMin && val <= handles.includeEndsValueMax
    set(handles.includeEndsValue,'Value',str2double(get(handles.includeEndsValue,'String')));
else
    warndlg(sprintf('Value out of range MIN(%g) - MAX(%g)',handles.includeEndsValueMin,handles.includeEndsValueMax),'Warning');
    set(handles.includeEndsValue,'Value',handles.includeEndsValueMin);
    set(handles.includeEndsValue,'String',handles.includeEndsValueMin);
end

guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function includeEndsValue_CreateFcn(hObject, eventdata, handles)
% hObject    handle to includeEndsValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function ratioSlider_Callback(hObject, eventdata, handles)
% hObject    handle to ratioSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
handles.ratioValue = 10^-(get(hObject,'Value'));
set(handles.ratioText,'String',handles.ratioValue);
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function ratioSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ratioSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


function ratioText_Callback(hObject, eventdata, handles)
% hObject    handle to ratioText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ratioText as text
%        str2double(get(hObject,'String')) returns contents of ratioText as a double
val = log10(str2double(get(hObject,'String')));
if val <= -get(handles.ratioSlider,'Min') && val >= -get(handles.ratioSlider,'Max')
    handles.ratioValue = str2double(get(hObject,'String'));
    set(handles.ratioSlider,'Value',abs(val));
else
    warndlg(sprintf('Ratio out of range MIN(%g) - MAX(%g)',10^-get(handles.ratioSlider,'Min'),10^-get(handles.ratioSlider,'Max')),'Warning');
    valSlid = get(handles.ratioSlider,'Min');
    valText = 10^-valSlid;
    handles.ratioValue = valText;
    set(handles.ratioSlider,'Value',valSlid);
    set(handles.ratioText,'Value',valText);
    set(handles.ratioText,'String',valText);
end
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function ratioText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ratioText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in fit.
function fit_Callback(hObject, eventdata, handles)
% hObject    handle to fit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if sum(handles.curvesIncluded) >= 1
    varToFitBkg = handles.selectedVariable;
    varBeg = get(handles.varBeg,'Value');
    varEnd = get(handles.varEnd,'Value');
    curvesIncluded = handles.curvesIncluded;
    set(handles.info, 'String', 'Calculating');
    set(handles.fit, 'Enable', 'off');
    drawnow
    if get(handles.includePotentials,'Value');
        curvesIncluded = [0; curvesIncluded];
        handles = arPLS(varToFitBkg(varBeg:varEnd,curvesIncluded>0),handles);
        handles.variableWithoutBkg = [varToFitBkg(varBeg:varEnd,1) varToFitBkg(varBeg:varEnd,curvesIncluded>0)-handles.background];
    else
        handles = arPLS(varToFitBkg(varBeg:varEnd,curvesIncluded>0),handles);
        handles.variableWithoutBkg = varToFitBkg(varBeg:varEnd,curvesIncluded>0)-handles.background;
    end
    plot_Data_And_Bkg(handles);
    set(handles.fit, 'Enable', 'on');
    set(handles.plotSignalsWithoutBkg, 'Enable', 'on');
    set(handles.info, 'String', 'Background calculated');
    handles.plotSwitch = 1;
    set(handles.plotSignalsWithoutBkg,'String','Signals without background');
else
    warndlg('No signal to fit background','Warning');
end
guidata(hObject, handles);



% --- Executes on selection change in listOfVariables.
function listOfVariables_Callback(hObject, eventdata, handles)
% hObject    handle to listOfVariables (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listOfVariables contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listOfVariables
contents = cellstr(get(hObject,'String'));
handles.selectedVariableName = contents{get(hObject,'value')};
if ~strcmp(handles.selectedVariableName,'Variables')
    var = handles.loadedFileStruct.(contents{get(hObject,'value')});
    [m,n] = size(var);
    if m < n; var = var'; end;
    handles.selectedVariable = var;
    set(handles.fit, 'Enable', 'on');
    set(handles.plotSignalsWithoutBkg, 'Enable', 'off');
    [m,n] = size(var);
    set(handles.varBeg, 'String', 1);
    set(handles.varEnd, 'String', m);
    set(handles.varBeg, 'Value', 1);
    set(handles.varEnd, 'Value', m);
    set(handles.exportFitToFile, 'Enable', 'on');
    set(handles.exportFitToWorkspace, 'Enable', 'on');
    set(handles.varBeg, 'Enable', 'on');
    set(handles.varEnd, 'Enable', 'on');
    set(handles.includePotentials, 'Enable', 'on');
    set(handles.reversPeaks, 'Enable', 'on');
    set(handles.includeCurves,'Enable', 'on');
    set(handles.includeAll, 'Enable', 'on');
    set(handles.excludeAll, 'Enable', 'on');
    set(handles.includeEndsCheck,'Enable', 'on');
    set(handles.refineWeightsCheck,'Enable', 'on');
    set(handles.info, 'String', 'Ready');
    handles.includeEndsValueMin = 1;
    handles.includeEndsValueMax = floor(m/2);
    if get(handles.includePotentials,'Value') && n == 1
        set(handles.includePotentials,'Value',0);
        handles.curvesIncluded(1:n,:) = 1;
    elseif get(handles.includePotentials,'Value') && n > 1
        handles.curvesIncluded(1:n-1,:) = 1;
    else
        handles.curvesIncluded(1:n,:) = 1;
    end;
    if get(handles.reversPeaks,'Value'); handles = reversPeaks(handles); end;
    handles.background = 0;
    handles.weights = 0;
    handles.variableWithoutBkg = 0;
    handles = create_list_of_curves(handles);
    plot_Data(handles);
end
guidata(hObject, handles);



% --- Executes during object creation, after setting all properties.
function listOfVariables_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listOfVariables (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in includePotentials.
function includePotentials_Callback(hObject, eventdata, handles)
% hObject    handle to includePotentials (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of includePotentials
handles = create_list_of_curves(handles);
includePotentials(handles);
guidata(hObject, handles);


% --- Executes on button press in reversPeaks.
function reversPeaks_Callback(hObject, eventdata, handles)
% hObject    handle to reversPeaks (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of reversPeaks
[handles] = reversPeaks(handles);
guidata(hObject, handles);


function varBeg_Callback(hObject, eventdata, handles)
% hObject    handle to varBeg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of varBeg as text
%        str2double(get(hObject,'String')) returns contents of varBeg as a double
val = str2double(get(hObject,'String'));
valEnd = get(handles.varEnd,'Value');
[m,~] = size(handles.selectedVariable);
if m > valEnd; m = valEnd; end; 
if val >= 1 && val <= m-1
    set(hObject,'Value',str2double(get(hObject,'String')));
else
%     warndlg(sprintf('Value out of range MIN(%g) - MAX(%g)',1,m-1),'Warning');
    set(hObject,'Value',1);
    set(hObject,'String',1);
end
handles.background = 0;
handles.weights = 0;
handles.variableWithoutBkg = 0;
handles.includeEndsValueMax = floor( (get(handles.varEnd,'Value') - get(handles.varBeg,'Value')) / 2 );
plot_Data(handles);
guidata(hObject, handles);



% --- Executes during object creation, after setting all properties.
function varBeg_CreateFcn(hObject, eventdata, handles)
% hObject    handle to varBeg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function varEnd_Callback(hObject, eventdata, handles)
% hObject    handle to varEnd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of varEnd as text
%        str2double(get(hObject,'String')) returns contents of varEnd as a double
val = str2double(get(hObject,'String'));
valBeg = get(handles.varBeg,'Value');
[m,~] = size(handles.selectedVariable);
if val < valBeg; cond = valBeg; else cond = 2; end;
if val >= cond && val <= m
    set(hObject,'Value',str2double(get(hObject,'String')));
else
%     warndlg(sprintf('Value out of range MIN(%g) - MAX(%g)',cond,m),'Warning');
    set(hObject,'Value',m);
    set(hObject,'String',m);
end
handles.background = 0;
handles.weights = 0;
handles.variableWithoutBkg = 0;
handles.includeEndsValueMax = floor( (get(handles.varEnd,'Value') - get(handles.varBeg,'Value')) / 2 );
plot_Data(handles);
guidata(hObject, handles);



% --- Executes during object creation, after setting all properties.
function varEnd_CreateFcn(hObject, eventdata, handles)
% hObject    handle to varEnd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --------------------------------------------------------------------
function file_Callback(hObject, eventdata, handles)
% hObject    handle to file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function loadFile_Callback(hObject, eventdata, handles)
% hObject    handle to loadFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[file,path] = uigetfile('*.*');
path_file = fullfile(path,file);
[~,~,file_ext] = fileparts(path_file);
switch lower(file_ext)
    case '.mat'
        S = load(path_file);
        handles.loadedFileStruct = S;
        fields = fieldnames(S);
        set(handles.listOfVariables, 'Enable', 'on');
        set(handles.listOfVariables, 'String', ...
            [{'Variables'} ; fields ]);
        set(handles.listOfVariables, 'Value', 1);
        set(handles.info, 'String', 'Select signal');
        handles = clearAndDefaultGUI(handles);
    case '.txt'
        A = load(path_file);
        S = struct('x',A);
        handles.loadedFileStruct = S;
        fields = fieldnames(S);
        set(handles.listOfVariables, 'Enable', 'on');
        set(handles.listOfVariables, 'String', ...
            [{'Variables'} ; fields ]);
        set(handles.listOfVariables, 'Value', 1);
        set(handles.info, 'String', 'Select signal');
        handles = clearAndDefaultGUI(handles);
    otherwise
        %not ok
        warndlg(sprintf('Unexpected file extension: %s . Accepted file formats: .mat, .txt', file_ext),'Warning');
end
handles.background = 0;
handles.weights = 0;
handles.variableWithoutBkg = 0;
guidata(hObject, handles);



% --------------------------------------------------------------------
function exportFitToFile_Callback(hObject, eventdata, handles)
% hObject    handle to exportFitToFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if length(handles.background) > 1 && sum(handles.curvesIncluded) >= 1
    [filename, pathname] = uiputfile('arPLS_bkg_results.mat','Save as');
    if length(filename) > 1 && length(pathname) > 1
        path_file = fullfile(pathname,filename);
        varBeg = get(handles.varBeg,'Value');
        varEnd = get(handles.varEnd,'Value');
        curvesIncluded = handles.curvesIncluded;
        if get(handles.includePotentials,'Value') 
            curvesIncluded = [1; curvesIncluded]; 
        end;
        x = handles.selectedVariable(varBeg:varEnd,curvesIncluded>0);
        bkg = handles.background;
        x_bkg = handles.variableWithoutBkg;
        w = handles.weights;
        save(path_file,'x','bkg','x_bkg','w');
        set(handles.info, 'String', sprintf('The data has been exported to %s file.',filename));
        fprintf('The data has been exported to %s file.\n',filename);
    end;
else
    warndlg('No data to export. Fit background first.','Warning');
end


% --------------------------------------------------------------------
function exportFitToWorkspace_Callback(hObject, eventdata, handles)
% hObject    handle to exportFitToWorkspace (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if length(handles.background) > 1 && sum(handles.curvesIncluded) >= 1
    beg = get(handles.varBeg,'Value');
    endd = get(handles.varEnd,'Value');
    curvesIncl = handles.curvesIncluded;
    if get(handles.includePotentials,'Value') 
        curvesIncl = [1; curvesIncl]; 
    end
    x = handles.selectedVariable(beg:endd,curvesIncl>0);
    bkg = handles.background;
    x_bkg = handles.variableWithoutBkg;
    w = handles.weights;
    assignin('base','x',x);
    assignin('base','bkg',bkg);
    assignin('base','x_bkg',x_bkg);
    assignin('base','w',w);
    set(handles.info, 'String', 'The data has been exported to workspace.');
    fprintf('The data has been exported to workspace.\n');
else
    warndlg('No data to export. Fit background first.','Warning');
end


function maxIterations_Callback(hObject, eventdata, handles)
% hObject    handle to maxIterations (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of maxIterations as text
%        str2double(get(hObject,'String')) returns contents of maxIterations as a double
val = str2double(get(hObject,'String'));
if val >= handles.maxIterationsMin && val <= handles.maxIterationsMax
    set(hObject,'Value',str2double(get(hObject,'String')));
else
    warndlg(sprintf('Value out of range MIN(%g) - MAX(%g)',handles.maxIterationsMin,handles.maxIterationsMax),'Warning');
    set(hObject,'Value',100);
    set(hObject,'String',100);
end
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function maxIterations_CreateFcn(hObject, eventdata, handles)
% hObject    handle to maxIterations (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in refineWeightsCheck.
function refineWeightsCheck_Callback(hObject, eventdata, handles)
% hObject    handle to refineWeightsCheck (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of refineWeightsCheck
if get(hObject,'Value')
    set(handles.refineWeightsValue, 'Enable', 'on');
else
    set(handles.refineWeightsValue, 'Enable', 'off');
end
guidata(hObject, handles);


function refineWeightsValue_Callback(hObject, eventdata, handles)
% hObject    handle to refineWeightsValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of refineWeightsValue as text
%        str2double(get(hObject,'String')) returns contents of refineWeightsValue as a double
val = str2double(get(hObject,'String'));
if val >= handles.refineWeightsValueMin && val <= handles.refineWeightsValueMax
    set(hObject,'Value',str2double(get(hObject,'String')));
else
    warndlg(sprintf('Value out of range MIN(%g) - MAX(%g)',handles.refineWeightsValueMin,handles.refineWeightsValueMax),'Warning');
    set(hObject,'Value',0.01);
    set(hObject,'String',0.01);
end
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function refineWeightsValue_CreateFcn(hObject, eventdata, handles)
% hObject    handle to refineWeightsValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in plotSignalsWithoutBkg.
function plotSignalsWithoutBkg_Callback(hObject, eventdata, handles)
% hObject    handle to plotSignalsWithoutBkg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.plotSwitch
    plot_Data_Without_Bkg(handles);
    handles.plotSwitch = 0;
    set(hObject,'String','Signals and fitted background');
else
    plot_Data_And_Bkg(handles);
    handles.plotSwitch = 1;
    set(hObject,'String','Signals without background');
end
guidata(hObject, handles);


% --- Executes when entered data in editable cell(s) in includeCurves.
function includeCurves_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to includeCurves (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)
[~,n] = size(handles.selectedVariable);
if get(handles.includePotentials,'Value'); n=n-1; end;
includeList = get(hObject,'Data');
for i = 1:n
   included(i,1) = double(includeList{i,2});
end
handles.curvesIncluded = included;
plot_Data(handles);
guidata(hObject, handles);


% --- Executes on button press in includeAll.
function includeAll_Callback(hObject, eventdata, handles)
% hObject    handle to includeAll (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[~,n] = size(handles.selectedVariable);
if get(handles.includePotentials,'Value'); n=n-1; end;
includeList = get(handles.includeCurves,'Data');
for i = 1:n
   includeList{i,2} = true;
   included(i,1) = true;
end
handles.curvesIncluded = included;
set(handles.includeCurves,'Data',includeList);
plot_Data(handles);
guidata(hObject, handles);


% --- Executes on button press in excludeAll.
function excludeAll_Callback(hObject, eventdata, handles)
% hObject    handle to excludeAll (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[~,n] = size(handles.selectedVariable);
if get(handles.includePotentials,'Value'); n=n-1; end;
includeList = get(handles.includeCurves,'Data');
for i = 1:n
   includeList{i,2} = false;
   included(i,1) = false;
end
handles.curvesIncluded = included;
set(handles.includeCurves,'Data',includeList);
plot_Data(handles);
guidata(hObject, handles);





% plot Data
function plot_Data(handles)
varToPlot = handles.selectedVariable;
curvesIncluded = handles.curvesIncluded;
varBeg = get(handles.varBeg,'Value');
varEnd = get(handles.varEnd,'Value');
if get(handles.includePotentials,'Value') && sum(curvesIncluded) >= 1
    curvesIncluded = [0; curvesIncluded];
    axes(handles.plot1);
    plot(varToPlot(varBeg:varEnd,1),varToPlot(varBeg:varEnd,curvesIncluded>0),'-b');
    xlabel('E / mV');
    ylabel('I');
    set(gca,'FontSize',9);
    grid on;
    axes(handles.plot2);
    plot(NaN);
    set(gca,'FontSize',9);
    grid on;
elseif sum(curvesIncluded) >= 1
    axes(handles.plot1);
    plot(varToPlot(varBeg:varEnd,curvesIncluded>0),'-b');
    xlabel('Point number');
    ylabel('I');
    set(gca,'FontSize',9);
    grid on;
    axes(handles.plot2);
    plot(NaN);
    set(gca,'FontSize',9);
    grid on;
else
    axes(handles.plot1);
    plot(NaN);
    xlabel('');
    ylabel('');
    set(gca,'FontSize',9);
    grid on;
    axes(handles.plot2);
    plot(NaN);
    set(gca,'FontSize',9);
    grid on;
end


% plot Data with fitted background
function plot_Data_And_Bkg(handles)
varToPlot = handles.selectedVariable;
bkg = handles.background;
w = handles.weights;
curvesIncluded = handles.curvesIncluded;
varBeg = get(handles.varBeg,'Value');
varEnd = get(handles.varEnd,'Value');
[m,~] = size(bkg);
if get(handles.includePotentials,'Value') && sum(curvesIncluded) >= 1
    curvesIncluded = [0; curvesIncluded];
    axes(handles.plot1);
    plot(varToPlot(varBeg:varEnd,1),varToPlot(varBeg:varEnd,curvesIncluded>0),'-b',varToPlot(varBeg:varEnd,1),bkg,'-r');
    xlabel('E / mV');
    ylabel('I');
    set(gca,'FontSize',9);
    grid on;
    axes(handles.plot2);
    plot(varToPlot(varBeg:varEnd,1),w,'-k');
    xlabel('E / mV');
    ylabel('W');
    set(gca,'FontSize',9);
    handles.plot2.YLim = [-0.1 1.1];
    grid on;
elseif sum(curvesIncluded) >= 1
    axes(handles.plot1);
    plot(1:m,varToPlot(varBeg:varEnd,curvesIncluded>0),'-b',1:m,bkg,'-r');
    xlabel('Point number');
    ylabel('I');
    set(gca,'FontSize',9);
    grid on;
    axes(handles.plot2);
    plot(1:m,w,'-k');
    xlabel('Point number');
    ylabel('W');
    set(gca,'FontSize',9);
    handles.plot2.YLim = [-0.1 1.1];
    grid on;
else
    axes(handles.plot1);
    plot(NaN);
    xlabel('');
    ylabel('');
    set(gca,'FontSize',9);
    grid on;
    axes(handles.plot2);
    plot(1:m,w,'-k');
    xlabel('');
    ylabel('');
    set(gca,'FontSize',9);
    grid on;
end


% plot Data without background
function plot_Data_Without_Bkg(handles)
varToPlot = handles.variableWithoutBkg;
curvesIncluded = handles.curvesIncluded;
if get(handles.includePotentials,'Value') && sum(curvesIncluded) >= 1
    axes(handles.plot1);
    plot(varToPlot(:,1),varToPlot(:,2:end),'-b');
    xlabel('E / mV');
    ylabel('I');
    set(gca,'FontSize',9);
    grid on;
elseif sum(curvesIncluded) >= 1
    axes(handles.plot1);
    plot(varToPlot,'-b');
    xlabel('Point number');
    ylabel('I');
    set(gca,'FontSize',9);
    grid on;
else
    axes(handles.plot1);
    plot(NaN);
    xlabel('');
    ylabel('');
    set(gca,'FontSize',9);
    grid on;
end



function includePotentials(handles)
plot_Data(handles);



function [handles] = reversPeaks(handles)
if get(handles.includePotentials,'Value')
    handles.selectedVariable(:,2:end) = handles.selectedVariable(:,2:end) * -1;
else
    handles.selectedVariable = handles.selectedVariable * -1;
end
plot_Data(handles);



% arPLS
function [handles] = arPLS(y,handles)

set(handles.fit, 'Enable', 'off');
set(handles.fit, 'String', 'Calculating');

lambda = handles.lambdaValue;
ratio = handles.ratioValue;
maxIter = get(handles.maxIterations,'Value');

[m2,n2] = size(y);

for i = 1:n2
    
    set(handles.info, 'String', ['Calculating background for curve: ' num2str(i)]);
    drawnow
    
    N = m2;
    D = diff(speye(N),2);
    H = lambda*D'*D;
    w = ones(N,1);
    cnt = 0;
    while true
        W = spdiags(w,0,N,N);
        %Cholesky decomposition
        C = chol(W + H);
        z = C \ (C'\(w.*y(:,i)));
        d = y(:,i)-z;
        %make d-, and get w^t with m and s
        dn = d(d<0);
        m = mean(dn);
        s = std(dn);
        wt = 1./ (1+ exp(2*(d-(2*s-m))/s));
        %check exit condition and backup
        if norm(w-wt)/norm(w) < ratio || cnt >= maxIter
            [z,w] = includeEndsValueFunc(handles,y(:,i),z,wt,N,H);
            [z,w] = refineWeightsFunc(handles,y(:,i),z,w,N,H);
            break
        end
        w = wt;
        cnt = cnt + 1;
    end
    
Z(:,i) = z;
Weights(:,i) = w;
end
handles.background = Z;
handles.weights = Weights;
set(handles.fit, 'Enable', 'on');
set(handles.fit, 'String', 'Fit background');


 % Set w=1 for ends
function [z,w] = includeEndsValueFunc(handles,yt,zt,wt,N,H)
if get(handles.includeEndsCheck,'Value') && get(handles.includeEndsValue,'Value')
    includeEndsNb = get(handles.includeEndsValue,'Value');
    wt(1:includeEndsNb) = 1;
    wt(end-includeEndsNb:end) = 1;
    w = wt;
    W = spdiags(w,0,N,N);
    %Cholesky decomposition
    C = chol(W + H);
    z = C \ (C'\(w.*yt));
else
    z = zt;
    w = wt;
end


% refine Weights
function [z,w] = refineWeightsFunc(handles,yt,zt,wt,N,H)
if get(handles.refineWeightsCheck,'Value') && get(handles.refineWeightsValue,'Value')
    threshold = get(handles.refineWeightsValue,'Value');
    wt(wt>threshold) = 1;
    wt(wt<threshold) = 0;
    w = wt;
    W = spdiags(w,0,N,N);
    %Cholesky decomposition
    C = chol(W + H);
    z = C \ (C'\(w.*yt));
else
    z = zt;
    w = wt;
end


% create list of included curves
function [handles] = create_list_of_curves(handles)
[~,n] = size(handles.selectedVariable);
if get(handles.includePotentials,'Value'); n=n-1; end;
includeList = {};
included = 0;
for i = 1:n
   includeList{i,1} = sprintf('Curve_%d',i);
   includeList{i,2} = true;
   included(i,1) = true;
end
handles.curvesIncluded = included;
set(handles.includeCurves,'Data',includeList);



% clear app from data
function [handles] = clearAndDefaultGUI(handles)
if length(handles.selectedVariable) > 1
    set(handles.exportFitToFile, 'Enable', 'off');
    set(handles.exportFitToWorkspace, 'Enable', 'off');
    set(handles.includePotentials, 'Enable', 'off');
    set(handles.reversPeaks, 'Enable', 'off');
    set(handles.fit, 'Enable', 'off');
    set(handles.varBeg, 'Enable', 'off');
    set(handles.varEnd, 'Enable', 'off');
    set(handles.includeAll, 'Enable', 'off');
    set(handles.excludeAll, 'Enable', 'off');
    set(handles.includeEndsCheck,'Enable', 'off');
    set(handles.includeEndsValue,'Enable', 'off');
    set(handles.refineWeightsCheck,'Enable', 'off');
    set(handles.refineWeightsValue,'Enable', 'off');
    set(handles.includePotentials,'Enable', 'off');
    set(handles.plotSignalsWithoutBkg, 'Enable', 'off');
    set(handles.includeCurves, 'Enable', 'off');
    set(handles.includePotentials, 'Value', 0);
    set(handles.reversPeaks, 'Value', 0);
    set(handles.includeEndsCheck,'Value', 0);
    set(handles.refineWeightsCheck,'Value', 0);
    set(handles.varBeg, 'String', 0);
    set(handles.varEnd, 'String', 1);
    set(handles.varBeg, 'Value', 0);
    set(handles.varEnd, 'Value', 1);
    handles.includeEndsValueMin = 0;
    handles.includeEndsValueMax = 1;
    set(handles.includeCurves, 'Data', {});
    set(handles.maxIterations,'Value',100);
    set(handles.includeEndsValue,'Value',10);
    set(handles.refineWeightsValue,'Value',0.01);
    set(handles.maxIterations,'String',100);
    set(handles.includeEndsValue,'String',10);
    set(handles.refineWeightsValue,'String',0.01);
    handles.selectedVariableName = '';
    handles.curvesIncluded = 0;
    handles.selectedVariable = 0;
    handles.background = 0;
    handles.weights = 0;
    handles.variableWithoutBkg = 0;
    handles.plotSwitch = 1;
    axes(handles.plot1);
    plot(NaN);
    xlabel('');
    ylabel('');
    set(gca,'FontSize',9);
    grid on;
    axes(handles.plot2);
    plot(NaN);
    xlabel('');
    ylabel('');
    set(gca,'FontSize',9);
    grid on;
else
    handles = handles;
end
