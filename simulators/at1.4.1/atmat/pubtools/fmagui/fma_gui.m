function varargout = fma_base_gui(varargin)
%
%   
%
% FMA_BASE_GUI M-file for fma_base_gui.fig
%      FMA_BASE_GUI, by itself, creates a new FMA_BASE_GUI or raises the existing
%      singleton*.
%
%      H = FMA_BASE_GUI returns the handle to a new FMA_BASE_GUI or the handle to
%      the existing singleton*.
%
%      FMA_BASE_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FMA_BASE_GUI.M with the given input arguments.
%
%      FMA_BASE_GUI('Property','Value',...) creates a new FMA_BASE_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before fma_base_gui_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to fma_base_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Copyright 2002-2003 The MathWorks, Inc.

% Edit the above text to modify the response to help fma_base_gui

% Last Modified by GUIDE v2.5 11-Oct-2005 17:07:57

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @fma_base_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @fma_base_gui_OutputFcn, ...
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


% --- Executes just before fma_base_gui is made visible.
function fma_base_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to fma_base_gui (see VARARGIN)

% Choose default command line output for fma_base_gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes fma_base_gui wait for user response (see UIRESUME)
% uiwait(handles.fma_base);

% For mesh_type!!!
set(handles.mesh_type,'SelectionChangeFcn',...
    'fma_gui(''mesh_type_SelectionChangeFcn'',gcbo,[],guidata(gcbo))');

setfma(getfmadefaults);

refresh_gui(handles);


function fma = getfmadefaults

% Initialise parameters and variables. (Defaults)
fma.version = 'fma_gui v1.1';

%% Initialise the base parameters
fma.latticefile = '';
fma.resultsfile = '';
fma.datadir = '';     % if datadir empty then use relative paths (default)
fma.starttime = datestr(clock,31);
fma.endtime = '';
fma.comments = '';
fma.nturn1 = 100;
fma.nturn2 = 100;
fma.totaltime = 0; % for computation in seconds

%% What aspect to investigate: transverse or momentum
fma.aperture = 'Transverse';

%% Next: mesh
% Type: linear, inverse.
fma.mesh.type = 'Inverse';

% Horizontal - positive
fma.mesh.hor_pos = 1;
fma.mesh.maxx_p  = 20;
fma.mesh.minx_p  =  1;
fma.mesh.maxdx_p =  2;
fma.mesh.mindx_p =  0.5;
% Horizontal - negative
fma.mesh.hor_neg = 0;
fma.mesh.maxx_n  = 20;
fma.mesh.minx_n  =  1;
fma.mesh.maxdx_n =  2;
fma.mesh.mindx_n =  0.5;

% Vertical - positive
fma.mesh.ver_pos = 1;
fma.mesh.maxy_p  = 10;
fma.mesh.miny_p  =  1;
fma.mesh.maxdy_p =  2;
fma.mesh.mindy_p =  0.5;
% Vertical - negative
fma.mesh.ver_neg = 0;
fma.mesh.maxy_n  = 10;
fma.mesh.miny_n  =  1;
fma.mesh.maxdy_n =  2;
fma.mesh.mindy_n =  0.5;

% Mesh points
fma.mesh.x = [];
fma.mesh.y = [];

%% Initialise DATA (assign size after definition of mesh, just before
%% running FMA_BASE calculations.
fma.data.x = [];
fma.data.y = [];
fma.data.nux1 = [];
fma.data.nuy1 = [];
fma.data.nux2 = [];
fma.data.nuy2 = [];
fma.data.dindex = []; % Diffusion index
fma.data.curr = 0;    % Current particle computing
fma.data.max = 0;     % Total num particles to compute



% --- Outputs from this function are returned to the command line.
function varargout = fma_base_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function lattice_file_Callback(hObject, eventdata, handles)
% hObject    handle to lattice_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of lattice_file as text
%        str2double(get(hObject,'String')) returns contents of lattice_file as a double

latticefile = get(hObject,'String');

% Test lattice file
if latticefileOK(latticefile)
    % If pass all tests then save filename (todo)
    fma = getfma();
    fma.latticefile = latticefile;
    setfma(fma);
    
    % Decide if want to update datafie and resultsfile directory.
    [pathstr namestr ext] = fileparts(latticefile);
    
    if isempty(get(handles.resultsfile,'String'))
        % Only the resultsfile field if it hasn't been set before.
%         fma.resultsfile = [namestr '_fma.dat'];
        set(handles.resultsfile,'String',[namestr '_fma.dat']);
        resultsfile_Callback(handles.resultsfile, eventdata, handles);
    end
end

% --- Executes during object creation, after setting all properties.
function lattice_file_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lattice_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function template_file_Callback(hObject, eventdata, handles)
% hObject    handle to template_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of template_file as text
%        str2double(get(hObject,'String')) returns contents of template_file as a double

% Test if file exists
templatefile = get(hObject,'String');

if isempty(templatefile)
    % Cancel resume status
    fma = getfmadefaults;
    fma.latticefile = get(handles.lattice_file,'String');    
    setfma(fma);
    
    refresh_gui(handles);
    % Call this to update the datadir, reduce possiblity of directory
    % confilct.
    lattice_file_Callback(hObject, eventdata, handles);
    return
else
    
    % Load and read the file
    if loadtemplate(templatefile)
        refresh_gui(handles);
    else
        set(hObject,'String','');
    end
end

% --- Executes during object creation, after setting all properties.
function template_file_CreateFcn(hObject, eventdata, handles)
% hObject    handle to template_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on button press in browse_lattice.
function browse_lattice_Callback(hObject, eventdata, handles)
% hObject    handle to browse_lattice (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[filename, pathname] = uigetfile({'*.m'},'Select AT lattice file');
if filename == 0
    % Cancel selected... do nothing
    return
else
    latticefile = [pathname filename];
end

% Update the text field to reflect selection
set(handles.lattice_file,'String',latticefile);

lattice_file_Callback(handles.lattice_file, eventdata, handles);


% --- Executes on button press in browse_template.
function browse_template_Callback(hObject, eventdata, handles)
% hObject    handle to browse_template (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[filename, pathname] = uigetfile({'*.*'},'Select resume file');
if filename == 0
    % Cancel selected... do nothing
    return
else
    templatefile = [pathname filename];
end

% Update the text field to reflect selection
set(handles.template_file,'String',templatefile);

template_file_Callback(handles.template_file, eventdata, handles);


% --- Executes on button press in hor_pos.
function hor_pos_Callback(hObject, eventdata, handles)
% hObject    handle to hor_pos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of hor_pos

fma = getfma;
if get(hObject,'Value') == get(hObject,'Max')
    fma.mesh.(get(hObject,'Tag')) = 1;
else
    fma.mesh.(get(hObject,'Tag')) = 0;
end
setfma(fma);
refresh_gui(handles);

% --- Executes on button press in hor_neg.
function hor_neg_Callback(hObject, eventdata, handles)
% hObject    handle to hor_neg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of hor_neg

fma = getfma;
if get(hObject,'Value') == get(hObject,'Max')
    fma.mesh.(get(hObject,'Tag')) = 1;
else
    fma.mesh.(get(hObject,'Tag')) = 0;
end
setfma(fma);
refresh_gui(handles);

function maxx_ph_Callback(hObject, eventdata, handles)
% hObject    handle to maxx_ph (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of maxx_ph as text
%        str2double(get(hObject,'String')) returns contents of maxx_ph as a double

generic_update_mesh_limits(hObject, handles)

% --- Executes during object creation, after setting all properties.
function maxx_ph_CreateFcn(hObject, eventdata, handles)
% hObject    handle to maxx_ph (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function minx_p_Callback(hObject, eventdata, handles)
% hObject    handle to minx_p (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of minx_p as text
%        str2double(get(hObject,'String')) returns contents of minx_p as a double

generic_update_mesh_limits(hObject, handles)


% --- Executes during object creation, after setting all properties.
function minx_p_CreateFcn(hObject, eventdata, handles)
% hObject    handle to minx_p (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function maxdx_p_Callback(hObject, eventdata, handles)
% hObject    handle to maxdx_p (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of maxdx_p as text
%        str2double(get(hObject,'String')) returns contents of maxdx_p as a double

generic_update_mesh_limits(hObject, handles)

% --- Executes during object creation, after setting all properties.
function maxdx_p_CreateFcn(hObject, eventdata, handles)
% hObject    handle to maxdx_p (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function mindx_p_Callback(hObject, eventdata, handles)
% hObject    handle to mindx_p (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of mindx_p as text
%        str2double(get(hObject,'String')) returns contents of mindx_p as a double

generic_update_mesh_limits(hObject, handles)

% --- Executes during object creation, after setting all properties.
function mindx_p_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mindx_p (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function maxx_n_Callback(hObject, eventdata, handles)
% hObject    handle to maxx_n (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of maxx_n as text
%        str2double(get(hObject,'String')) returns contents of maxx_n as a double

generic_update_mesh_limits(hObject, handles)

% --- Executes during object creation, after setting all properties.
function maxx_n_CreateFcn(hObject, eventdata, handles)
% hObject    handle to maxx_n (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
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
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function maxdx_n_Callback(hObject, eventdata, handles)
% hObject    handle to maxdx_n (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of maxdx_n as text
%        str2double(get(hObject,'String')) returns contents of maxdx_n as a double

generic_update_mesh_limits(hObject, handles)

% --- Executes during object creation, after setting all properties.
function maxdx_n_CreateFcn(hObject, eventdata, handles)
% hObject    handle to maxdx_n (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function mindx_n_Callback(hObject, eventdata, handles)
% hObject    handle to mindx_n (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of mindx_n as text
%        str2double(get(hObject,'String')) returns contents of mindx_n as a double

generic_update_mesh_limits(hObject, handles)

% --- Executes during object creation, after setting all properties.
function mindx_n_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mindx_n (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function minx_n_Callback(hObject, eventdata, handles)
% hObject    handle to minx_n (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of minx_n as text
%        str2double(get(hObject,'String')) returns contents of minx_n as a double

generic_update_mesh_limits(hObject, handles)

% --- Executes during object creation, after setting all properties.
function minx_n_CreateFcn(hObject, eventdata, handles)
% hObject    handle to minx_n (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on button press in ver_pos.
function ver_pos_Callback(hObject, eventdata, handles)
% hObject    handle to ver_pos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ver_pos

fma = getfma;
if get(hObject,'Value') == get(hObject,'Max')
    fma.mesh.(get(hObject,'Tag')) = 1;
else
    fma.mesh.(get(hObject,'Tag')) = 0;
end
setfma(fma);
refresh_gui(handles);

% --- Executes on button press in ver_neg.
function ver_neg_Callback(hObject, eventdata, handles)
% hObject    handle to ver_neg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ver_neg

fma = getfma;
if get(hObject,'Value') == get(hObject,'Max')
    fma.mesh.(get(hObject,'Tag')) = 1;
else
    fma.mesh.(get(hObject,'Tag')) = 0;
end
setfma(fma);
refresh_gui(handles);

function maxy_p_Callback(hObject, eventdata, handles)
% hObject    handle to maxy_p (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of maxy_p as text
%        str2double(get(hObject,'String')) returns contents of maxy_p as a double

generic_update_mesh_limits(hObject, handles)

% --- Executes during object creation, after setting all properties.
function maxy_p_CreateFcn(hObject, eventdata, handles)
% hObject    handle to maxy_p (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function miny_p_Callback(hObject, eventdata, handles)
% hObject    handle to miny_p (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of miny_p as text
%        str2double(get(hObject,'String')) returns contents of miny_p as a double

generic_update_mesh_limits(hObject, handles)

% --- Executes during object creation, after setting all properties.
function miny_p_CreateFcn(hObject, eventdata, handles)
% hObject    handle to miny_p (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function maxdy_p_Callback(hObject, eventdata, handles)
% hObject    handle to maxdy_p (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of maxdy_p as text
%        str2double(get(hObject,'String')) returns contents of maxdy_p as a double

generic_update_mesh_limits(hObject, handles)

% --- Executes during object creation, after setting all properties.
function maxdy_p_CreateFcn(hObject, eventdata, handles)
% hObject    handle to maxdy_p (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function mindy_p_Callback(hObject, eventdata, handles)
% hObject    handle to mindy_p (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of mindy_p as text
%        str2double(get(hObject,'String')) returns contents of mindy_p as a double

generic_update_mesh_limits(hObject, handles)

% --- Executes during object creation, after setting all properties.
function mindy_p_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mindy_p (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function maxy_n_Callback(hObject, eventdata, handles)
% hObject    handle to maxy_n (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of maxy_n as text
%        str2double(get(hObject,'String')) returns contents of maxy_n as a double

generic_update_mesh_limits(hObject, handles)

% --- Executes during object creation, after setting all properties.
function maxy_n_CreateFcn(hObject, eventdata, handles)
% hObject    handle to maxy_n (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function miny_n_Callback(hObject, eventdata, handles)
% hObject    handle to miny_n (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of miny_n as text
%        str2double(get(hObject,'String')) returns contents of miny_n as a double

generic_update_mesh_limits(hObject, handles)

% --- Executes during object creation, after setting all properties.
function miny_n_CreateFcn(hObject, eventdata, handles)
% hObject    handle to miny_n (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function maxdy_n_Callback(hObject, eventdata, handles)
% hObject    handle to maxdy_n (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of maxdy_n as text
%        str2double(get(hObject,'String')) returns contents of maxdy_n as a double

generic_update_mesh_limits(hObject, handles)

% --- Executes during object creation, after setting all properties.
function maxdy_n_CreateFcn(hObject, eventdata, handles)
% hObject    handle to maxdy_n (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function mindy_n_Callback(hObject, eventdata, handles)
% hObject    handle to mindy_n (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of mindy_n as text
%        str2double(get(hObject,'String')) returns contents of mindy_n as a double

generic_update_mesh_limits(hObject, handles)

% --- Executes during object creation, after setting all properties.
function mindy_n_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mindy_n (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function comments_Callback(hObject, eventdata, handles)
% hObject    handle to comments (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of comments as text
%        str2double(get(hObject,'String')) returns contents of comments as a double

comment = get(hObject,'String');
fma = getfma;
fma.comments = comment;
setfma(fma);

% --- Executes during object creation, after setting all properties.
function comments_CreateFcn(hObject, eventdata, handles)
% hObject    handle to comments (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


function nturn1_Callback(hObject, eventdata, handles)
% hObject    handle to nturn1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of nturn1 as text
%        str2double(get(hObject,'String')) returns contents of nturn1 as a double

val = str2double(get(hObject,'String'));
if isnan(val)
    setmessage(handles.messages,['Invalid value for: ' get(hObject,'Tag')]);
    fma = getfma;
    set(hObject,'String',num2str(fma.(get(hObject,'Tag'))));
    return;
else
    fma = getfma;
    fma.(get(hObject,'Tag')) = val;
    setfma(fma);
end

% --- Executes during object creation, after setting all properties.
function nturn1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to nturn1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function nturn2_Callback(hObject, eventdata, handles)
% hObject    handle to nturn2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of nturn2 as text
%        str2double(get(hObject,'String')) returns contents of nturn2 as a double

val = str2double(get(hObject,'String'));
if isnan(val)
    setmessage(handles.messages,['Invalid value for: ' get(hObject,'Tag')]);
    fma = getfma;
    set(hObject,'String',num2str(fma.(get(hObject,'Tag'))));
    return;
else
    fma = getfma;
    fma.(get(hObject,'Tag')) = val;
    setfma(fma);
end

% --- Executes during object creation, after setting all properties.
function nturn2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to nturn2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


function mesh_type_SelectionChangeFcn(hObject, eventdata, handles)

% disp('Selection Change')
fma = getfma;
fma.mesh.type = get(get(handles.mesh_type,'SelectedObject'),'String');
setfma(fma);
refresh_gui(handles);

% --- Executes on button press in refresh.
function refresh_Callback(hObject, eventdata, handles)
% hObject    handle to refresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

refresh_gui(handles);


function datadir_Callback(hObject, eventdata, handles)
% hObject    handle to datadir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of datadir as text
%        str2double(get(hObject,'String')) returns contents of datadir as a double

fma = getfma;
fma.datadir = get(hObject,'String');
setfma(fma);


% --- Executes during object creation, after setting all properties.
function datadir_CreateFcn(hObject, eventdata, handles)
% hObject    handle to datadir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end






function resultsfile_Callback(hObject, eventdata, handles)
% hObject    handle to resultsfile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of resultsfile as text
%        str2double(get(hObject,'String')) returns contents of resultsfile as a double

fma = getfma;
fma.resultsfile = get(hObject,'String');
setfma(fma);


% --- Executes during object creation, after setting all properties.
function resultsfile_CreateFcn(hObject, eventdata, handles)
% hObject    handle to resultsfile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end





% --- Executes on button press in generate_input.
function generate_input_Callback(hObject, eventdata, handles)
% hObject    handle to generate_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

oldpwd = pwd;
% Do a few checks before proceeding.
% Update everything so I see what I'm meant to see.
refresh_gui(handles);
fma = getfma;

% Has the lattice been selected?
if isempty(fma.latticefile)
    setmessage(handles.messages,'Need to select a lattice file!');
    return
end

% Prep data
% Mesh values are in mm while the values in data must be in meters.
[xx yy] = meshgrid(fma.mesh.x/1000,fma.mesh.y/1000);
fma.data.x = xx;
fma.data.y = yy;
fma.data.nux1 = zeros(fma.data.max,1); fma.data.nux1(:) = NaN;
fma.data.nuy1 = zeros(fma.data.max,1); fma.data.nuy1(:) = NaN;
fma.data.nux2 = zeros(fma.data.max,1); fma.data.nux2(:) = NaN;
fma.data.nuy2 = zeros(fma.data.max,1); fma.data.nuy2(:) = NaN;
fma.data.dindex = zeros(fma.data.max,1); fma.data.dindex(:) = NaN;
fma.data.curr = 1;    % Current particle computing

% Create and change current working directory to data dir or if empty ask
% the user where to put the files.
if isempty(fma.datadir)
    fma.datadir = uigetdir(fileparts(fma.latticefile),'Pick a Directory');
else
    if exist(fma.datadir,'dir') ~= 7
        mkdir(fma.datadir);
    end
end
cd(fma.datadir);
    
% Create a copy of the lattice file in the results/data directory so
% that it can be uniquely identified as being used for this run. Will not
% have path directory for the lattice file as it will always be in datadir.
[pathstr namestr ext] = fileparts(fma.latticefile);
newlatticefile = [namestr '_' strrep(datestr(now,13),':','_') ext];
status = copyfile(fma.latticefile, [fma.datadir filesep newlatticefile]);
fma.latticefile = newlatticefile;

if status == 0
    setmessage(handles.messages,'Could not create copy of lattice file for input file!');
    cd(oldpwd)
    return
end
% Write input file
success = fma_lib('write',[fma.datadir filesep namestr '_fma_input.dat'],fma);
if success
    % write a batch file script for automated processing. Won't deal with
    % multiple instances.
    writescript(fma.datadir, [namestr '_fma_input.dat']);
    setmessage(handles.messages,'Input and batch script file written');
else
    setmessage(handles.messages,['Input file could not be written: ' lasterr]);
end

cd(oldpwd);


% --- Executes on button press in datadir_browse.
function datadir_browse_Callback(hObject, eventdata, handles)
% hObject    handle to datadir_browse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

dirstr = uigetdir;
set(handles.datadir,'String',dirstr);
datadir_Callback(handles.datadir,eventdata,handles);


% ######### User Defined Functions ###############
% Simplify getting the data structure where everything is stored.
function fma = getfma

handles = guihandles;
fma = getappdata(handles.fma_base,'fma');

function setfma(fma)

handles = guihandles;
setappdata(handles.fma_base,'fma',fma);

% Test if the lattice file selected is OK
function val = latticefileOK(latticefile)

val = 1;
handles = guihandles;

% Does it exist
if exist(latticefile,'file') == 0
    setmessage(handles.messages,['AT Lattice File does not exist: ' latticefile]);
    val = 0;
    return
end  
% Load and test file integrity (todo)
disp('Load and test integrity of lattice file (todo)');



% Read and load resume file
function varargout = loadtemplate(templatefile)

varargout{1} = 1;
handles = guihandles;

% Does it exist
if exist(templatefile,'file') == 0
    setmessage(handles.messages,['Template File does not exist: ' templatefile]);
    varargout{1} = 0;
    return
end

% Get current fma data struct
fma = getfma;

[fmatemplate success] = fma_lib('read',templatefile);
if success == 0
    varargout{1} = 0;
    setmessage(handles.messages,['Error reading FMA data file for template: ' lasterr]);
    return
end
% Copy over the mesh and number of turns data.
fma.mesh = fmatemplate.mesh;
fma.nturn1 = fmatemplate.nturn1;
fma.nturn2 = fmatemplate.nturn2;
fma.templatefile = templatefile;

setfma(fma);


function generic_update_mesh_limits(hObject, handles)

val = str2double(get(hObject,'String'));
if isnan(val)
    setmessage(handles.messages,['Invalid value for: ' get(hObject,'Tag')]);
    fma = getfma;
    set(hObject,'String',num2str(fma.mesh.(get(hObject,'Tag'))));
    return;
else
    fma = getfma;
    fma.mesh.(get(hObject,'Tag')) = val;
    setfma(fma);
end


% Function will update the plot from the data stored in fma. The variable
% fma should have been incrementally updated as new values are put into the
% text boxes. Will also update text boxes to values saved in fma.
function refresh_gui(handles)

disp('Refreshing data')

fma = getfma;
% Set general parameters
set(handles.lattice_file,'String',fma.latticefile);
set(handles.datadir,'String',fma.datadir);
set(handles.resultsfile,'String',fma.resultsfile);
set(handles.comments,'String',fma.comments);
set(handles.nturn1,'String',num2str(fma.nturn1));
set(handles.nturn2,'String',num2str(fma.nturn2));

%% Next: mesh
% Update the type selected
mtypehandles = get(handles.mesh_type,'Children');
for i=1:length(mtypehandles)
    if strcmpi(get(mtypehandles(i),'String'),fma.mesh.type) > 0
        set(handles.mesh_type,'SelectedObject',mtypehandles(i))    
        break
    end
end
% Update the 'directions' to create the mesh
temp = {'hor_pos' 'hor_neg' 'ver_pos' 'ver_neg'};
for i=1:length(temp)
    if fma.mesh.(temp{i})
        set(handles.(temp{i}),'Value',get(handles.(temp{i}),'Max'));
    else
        set(handles.(temp{i}),'Value',get(handles.(temp{i}),'Min'));
    end
end
% Update the mesh parameters.
tempnames = fieldnames(fma.mesh);
for i=1:length(tempnames)
    if length(tempnames{i}) < 3
        continue
    end
    if strcmpi(tempnames{i}(1:3),'max') > 0 |...
            strcmpi(tempnames{i}(1:3),'min') > 0
        set(handles.(tempnames{i}),'String',num2str(fma.mesh.(tempnames{i})));
    end
end

%% Start drawing the mesh here
% Check: if pos and neg for either hor or ver is unchecked then do not
% continue plotting.
if fma.mesh.hor_pos == 0 & fma.mesh.hor_neg == 0
    setmessage(handles.messages,...
        'Select either positive and/or negative direction in the horizontal');
    return;
elseif fma.mesh.ver_pos == 0 & fma.mesh.ver_neg == 0
        setmessage(handles.messages,...
        'Select either positive and/or negative direction in the vertical');
    return;
end

% Calculate the mesh positions
switch lower(fma.mesh.type)
    case 'inverse'
        % Temporary variables to store the mesh positions, for the positive and
        % negative directions, in both planes
        temp_pos = [];
        temp_neg = [];
        if fma.mesh.hor_pos
            temp_pos(1) = fma.mesh.minx_p;
            ax = (fma.mesh.maxdx_p - fma.mesh.mindx_p)*fma.mesh.maxx_p*fma.mesh.minx_p/(fma.mesh.maxx_p - fma.mesh.minx_p);
            bx = fma.mesh.mindx_p - ax/fma.mesh.maxx_p;

            while temp_pos(end) < fma.mesh.maxx_p
                % Here, the function dx_i
                % x_i = x_{i-1} + dx_{i-1}
                temp_pos(end+1) = temp_pos(end) + ax/abs(temp_pos(end)) + bx;
            end
        end
        if fma.mesh.hor_neg
            temp_neg(1) = fma.mesh.minx_n;
            ax = (fma.mesh.maxdx_n - fma.mesh.mindx_n)*fma.mesh.maxx_n*fma.mesh.minx_n/(fma.mesh.maxx_n - fma.mesh.minx_n);
            bx = fma.mesh.mindx_n - ax/fma.mesh.maxx_n;

            while temp_neg(end) < fma.mesh.maxx_n
                % Here, the function dx_i
                % x_i = x_{i-1} + dx_{i-1}
                temp_neg(end+1) = temp_neg(end) + ax/abs(temp_neg(end)) + bx;
            end
        end
        fma.mesh.x = [-temp_neg temp_pos];

        temp_pos = [];
        temp_neg = [];
        if fma.mesh.ver_pos
            temp_pos(1) = fma.mesh.miny_p;
            ay = (fma.mesh.maxdy_p - fma.mesh.mindy_p)*fma.mesh.maxy_p*fma.mesh.miny_p/(fma.mesh.maxy_p - fma.mesh.miny_p);
            by = fma.mesh.mindy_p - ay/fma.mesh.maxy_p;

            while temp_pos(end) < fma.mesh.maxy_p
                % Here, the function dy_i
                % y_i = y_{i-1} + dy_{i-1}
                temp_pos(end+1) = temp_pos(end) + ay/abs(temp_pos(end)) + by;
            end
        end
        if fma.mesh.ver_neg
            temp_neg(1) = fma.mesh.miny_n;
            ay = (fma.mesh.maxdy_n - fma.mesh.mindy_n)*fma.mesh.maxy_n*fma.mesh.miny_n/(fma.mesh.maxy_n - fma.mesh.miny_n);
            by = fma.mesh.mindy_n - ay/fma.mesh.maxy_n;

            while temp_neg(end) < fma.mesh.maxy_n
                % Here, the function dy_i
                % y_i = y_{i-1} + dy_{i-1}
                temp_neg(end+1) = temp_neg(end) + ay/abs(temp_neg(end)) + by;
            end
        end
        fma.mesh.y = [-temp_neg temp_pos];
    case 'linear'
        % Create grids whose widths decrease linearly the further out it goes. The
        % algorithm is as follows:
        %   x_i = x_{i-1} + maxdx - (maxdx-mindx)/(maxx-minx)*x_{i-1}
        % The convergence criteria is
        %   asymptote val = maxdx*(maxx - minx)/(maxdx - mindx) > maxx
        % This can be derived by analysing x_i/x_{i-1}. As i -> infinity this ratio
        % has to equal 1 and the value of x_i will be the value of the asymptote.
        % If the value of the asymptote is < maxx this algorithm will loop forever.
        % Temporary variables to store the mesh positions, for the positive and
        % negative directions, in both planes
        temp_pos = [];
        temp_neg = [];
        if fma.mesh.hor_pos
            if fma.mesh.maxdx_p*(fma.mesh.maxx_p - fma.mesh.minx_p)/(fma.mesh.maxdx_p - fma.mesh.mindx_p) <= fma.mesh.maxx_p
                msgstr = 'Reselect limit values for x. Increase (maxx - minx) or decrease (maxdx - mindx)';
                setmessage(handles.messages,msgstr);
                return
            end

            temp_pos(1) = fma.mesh.minx_p;
            while temp_pos(end) < fma.mesh.maxx_p
                % Here, the function dx_i
                % x_i = x_{i-1} + dx_{i-1}
                temp_pos(end+1) = temp_pos(end) + (fma.mesh.maxdx_p - (fma.mesh.maxdx_p-fma.mesh.mindx_p)/(fma.mesh.maxx_p-fma.mesh.minx_p)*temp_pos(end));
            end
        end
        if fma.mesh.hor_neg
            if fma.mesh.maxdx_n*(fma.mesh.maxx_n - fma.mesh.minx_n)/(fma.mesh.maxdx_n - fma.mesh.mindx_n) <= fma.mesh.maxx_n
                msgstr = 'Reselect limit values for x. Increase (maxx - minx) or decrease (maxdx - mindx)';
                setmessage(handles.messages,msgstr);
                return
            end

            temp_neg(1) = fma.mesh.minx_n;
            while temp_neg(end) < fma.mesh.maxx_n
                % Here, the function dx_i
                % x_i = x_{i-1} + dx_{i-1}
                temp_neg(end+1) = temp_neg(end) + (fma.mesh.maxdx_n - (fma.mesh.maxdx_n-fma.mesh.mindx_n)/(fma.mesh.maxx_n-fma.mesh.minx_n)*temp_neg(end));
            end
        end
        fma.mesh.x = [-temp_neg temp_pos];

        temp_pos = [];
        temp_neg = [];
        if fma.mesh.ver_pos
            if fma.mesh.maxdy_p*(fma.mesh.maxy_p - fma.mesh.miny_p)/(fma.mesh.maxdy_p - fma.mesh.mindy_p) <= fma.mesh.maxy_p
                msgstr = 'Reselect limit values for y. Increase (maxy - miny) or decrease (maxdy - mindy)';
                setmessage(handles.messages,msgstr);
                return
            end

            temp_pos(1) = fma.mesh.miny_p;
            while temp_pos(end) < fma.mesh.maxy_p
                % Here, the function dy_i
                % y_i = y_{i-1} + dy_{i-1}
                temp_pos(end+1) = temp_pos(end) + (fma.mesh.maxdy_p - (fma.mesh.maxdy_p-fma.mesh.mindy_p)/(fma.mesh.maxy_p-fma.mesh.miny_p)*temp_pos(end));
            end
        end
        if fma.mesh.ver_neg
            if fma.mesh.maxdy_n*(fma.mesh.maxy_n - fma.mesh.miny_n)/(fma.mesh.maxdy_n - fma.mesh.mindy_n) <= fma.mesh.maxy_n
                msgstr = 'Reselect limit values for y. Increase (maxy - miny) or decrease (maxdy - mindy)';
                setmessage(handles.messages,msgstr);
                return
            end

            temp_neg(1) = fma.mesh.miny_n;
            while temp_neg(end) < fma.mesh.maxy_n
                % Here, the function dy_i
                % y_i = y_{i-1} + dy_{i-1}
                temp_neg(end+1) = temp_neg(end) + (fma.mesh.maxdy_n - (fma.mesh.maxdy_n-fma.mesh.mindy_n)/(fma.mesh.maxy_n-fma.mesh.miny_n)*temp_neg(end));
            end
        end
        fma.mesh.y = [-temp_neg temp_pos];
end

% Make sure that the intervals mesh.x and mesh.y are sorted
fma.mesh.x = sort(fma.mesh.x);
fma.mesh.y = sort(fma.mesh.y);

% Now draw mesh
axes(handles.meshfig);
cla;
for i=1:length(fma.mesh.x)
    line([fma.mesh.x(i) fma.mesh.x(i)],[min(fma.mesh.y) max(fma.mesh.y)]);
end
for i=1:length(fma.mesh.y)
    line([min(fma.mesh.x) max(fma.mesh.x)], [fma.mesh.y(i) fma.mesh.y(i)]);
end

% Update total number of mesh points
fma.data.max = length(fma.mesh.x)*length(fma.mesh.y);
set(handles.nummeshpoints,'String',num2str(fma.data.max));


if get(handles.Transverse,'Value')
    axis equal; axis tight;
elseif get(handles.Momentum,'Value')
    axis normal; axis tight;
end

% Save all changes
setfma(fma);


function setmessage(handle,str)

MAX = 7;

currstr = get(handle,'String');
nmsg = get(handle,'UserData');
if isempty(nmsg)
    nmsg = 0;
end

nmsg = nmsg + 1;
if length(currstr) >= MAX
    currstr = char(currstr);
    currstr(1:MAX-1,:) = currstr(2:MAX,:);
    currstr = cellstr(currstr);
    currstr{MAX} = [num2str(nmsg) ' >> ' str];
else
    currstr{end+1} = [num2str(nmsg) ' >> ' str];
end

set(handle,'String',currstr);
set(handle,'UserData',nmsg);


function writescript(pathstr, inputfilename)

oldpwd = pwd;
cd(pathstr);

if ~strcmpi(pathstr(end),filesep)
    pathstr = [pathstr filesep];
end
[dum name ext] = fileparts(inputfilename);

switch computer
case 'PCWIN'
    fid = fopen('runscript.bat','w');
    
    matlabstr = 'matlab -nosplash -nodesktop -nojvm';
    logfile = sprintf('-logfile %s',['%%CD%%' name '_matlaberrors.log']);
    % Added by Eugene 24/03/05. Temporary while away.
    command = sprintf('-r "fma = fma_lib(''analysis'',''%s''); plot_emailresults(fma); exit;"',['%%CD%%' inputfilename]);
    
    fprintf(fid,'@echo off\r\n');
    fprintf(fid,'echo.\r\n');
    fprintf(fid,'echo Starting MATLAB and running Frequency Map Analysis...\r\n');
    fprintf(fid,'echo Input file : \r\n');
    fprintf(fid,'echo        %s\r\n',['%%CD%%' inputfilename]);
    fprintf(fid,'echo Matlab error logs saved to : \r\n');
    fprintf(fid,'echo        %s\r\n',['%%CD%%' name '_matlaberrors.log']);
    fprintf(fid,'echo.\r\n');
    fprintf(fid,'%s %s %s\r\n',matlabstr,logfile,command);

    fclose(fid);
case {'GLNX86', 'ALPHA', 'SOL2'}
    disp('Never been used on Unix platforms.');
    disp('You''re more than welcome to modify this code... :D');
otherwise
    error('Unsupported platform');
end

cd(oldpwd);


% --- Executes on button press in Transverse.
function Transverse_Callback(hObject, eventdata, handles)
% hObject    handle to Transverse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Transverse


% --- Executes on button press in Momentum.
function Momentum_Callback(hObject, eventdata, handles)
% hObject    handle to Momentum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Momentum




% --- Executes during object creation, after setting all properties.
function nummeshpoints_CreateFcn(hObject, eventdata, handles)
% hObject    handle to nummeshpoints (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function Aperture_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to Aperture (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fma = getfma;
if get(handles.Transverse,'Value')
    fma.aperture = 'Transverse';
    set(handles.HorizontalParameters,'Title','Horizontal (x)');
    set(handles.VerticalParameters,'Title','Vertical (y)');
elseif get(handles.Momentum,'Value')
    fma.aperture = 'Momentum';
    set(handles.HorizontalParameters,'Title','Horizontal (Delta)');
    set(handles.VerticalParameters,'Title','Vertical (x)');
end
setfma(fma);
refresh_gui(handles);