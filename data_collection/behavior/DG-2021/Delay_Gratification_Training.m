function varargout = Delay_Gratification_Training(varargin)
% DELAY_GRATIFICATION_TRAINING MATLAB code for Delay_Gratification_Training.fig
%      DELAY_GRATIFICATION_TRAINING, by itself, creates a new DELAY_GRATIFICATION_TRAINING or raises the existing
%      singleton*.
%
%      H = DELAY_GRATIFICATION_TRAIIG returns the handle to a new DELAY_GRATIFICATION_TRAINING or the handle to
%      the existing singleton*

%      DELAY_GRATIFICATION_TRAINING('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DELAY_GRATIFICATION_TRAINING.M with the given input arguments.
%
%      DELAY_GRATIFICATION_TRAINING('Property','Value',...) creates a new DELAY_GRATIFICATION_TRAINING or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Delay_Gratification_Training_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Delay_Gratification_Training_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Delay_Gratification_Training
% 
% Last Modified by Zilong Gao 09-Oct-2020 13:52:56

% Begin initialization code - DO NOT EDIT

% Developed by Rongfeng Hu(email:hurongfeng8829@126.com) 03/07/2016
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Delay_Gratification_Training_OpeningFcn, ...
                   'gui_OutputFcn',  @Delay_Gratification_Training_OutputFcn, ...
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


% --- Executes just before Delay_Gratification_Training is made visible.
function Delay_Gratification_Training_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Delay_Gratification_Training (see VARARGIN)

% Choose default command line output for Delay_Gratification_Training
handles.output = hObject;
%Instrreset disconnects and deletes all instrument objects.
instrreset;
%
global Light;
global Lick_M;
global Timer_Sound;
global Sound;
Sound=timer;
Sound.StartDelay=0;
Sound.TimerFcn={@callback_sound,handles};
Sound.TasksToExecute=1;
Timer_Sound=timer;
Timer_Sound.StartDelay=0;
Timer_Sound.TimerFcn={@call_Sound,handles};
Timer_Sound.TasksToExecute=12;
Timer_Sound.ExecutionMode='fixedRate';
Timer_Sound.Period=1;
Lick_M=0;
Light=serial('COM5'); 
set(Light,'BaudRate',9600,'DataBits',8,'StopBits',1);
set(Light,'BytesAvailableFcnCount',1,'BytesAvailableFcnMode','terminator');
set(Light,'BytesAvailableFcn',{@call_Lick,handles});
fopen(Light);
% modified by ML add filtering kernel here. 
co = 240; %col # of the image
ro = 320; %row # of the iamge
fc = 15; %cut off frequency of the low-pass filter of the image
handles.H = ideal_filter(co,ro,fc); %use idea filter 
%handles.H = gaussian_filter(co,ro,fc); %use gaussian filter

% Update handles structure
guidata(hObject, handles);


%Ideal filter
function H = ideal_filter(co,ro,fc)
    cx = round(co/2); % find the center of the image
    cy = round (ro/2);
    H=zeros(co,ro);
    if fc > cx && fc > cy
        H = ones(co,ro);
        return;
    end;
    for i = 1 : co
        for j = 1 : ro
            if (i-cx).^2 + (j-cy).^2 <= fc .^2
                H(i,j)=1;
            end;
        end;
    end;

 % gaussian filter
function  H = gaussian_filter(co,ro, fc)
     cx = round(co/2); % find the center of the image
    cy = round (ro/2);
    H = zeros(co,ro);
    for i = 1 : co
        for j = 1 : ro
            d = (i-cx).^2 + (j-cy).^2;
            H(i,j) = exp(-d/2/fc/fc);
        end;
    end;

% UIWAIT makes Delay_Gratification_Training wait for user response (see UIRESUME)
% uiwait(handles.figure1);
% Update handles structure
guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = Delay_Gratification_Training_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


function edit_savefile_Callback(hObject, eventdata, handles)
% hObject    handle to edit_savefile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_savefile as text
%        str2double(get(hObject,'String')) returns contents of edit_savefile as a double


% --- Executes during object creation, after setting all properties.
function edit_savefile_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_savefile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_camara_Callback(hObject, eventdata, handles)
% hObject    handle to edit_camara (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_camara as text
%        str2double(get(hObject,'String')) returns contents of edit_camara as a double


% --- Executes during object creation, after setting all properties.
function edit_camara_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_camara (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_threshold_Callback(hObject, eventdata, handles)
% hObject    handle to edit_threshold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_threshold as text
%        str2double(get(hObject,'String')) returns contents of edit_threshold as a double


% --- Executes during object creation, after setting all properties.
function edit_threshold_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_threshold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_preview.
function pushbutton_preview_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_preview (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
device_ID = str2double(get(handles.edit_camara, 'String'));
imaqreset; 
handles.video = videoinput('winvideo',device_ID, 'MJPG_320x240');
preview(handles.video);  
guidata(hObject, handles);

% --- Executes on button press in pushbutton_save.
function pushbutton_save_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
folder_name = uigetdir('D:\data');
if folder_name==0
    return;
end
Time = clock;
Year  = num2str(Time(1));
Month = num2str(Time(2));
Day = num2str(Time(3));
if Time(2)<10
    Month = ['0',Month];
end
if Time(3)<10
    Day = ['0',Day];
end
index = find(folder_name=='\');
Mouse = folder_name(index(end)+1:end);
Date = [Year,Month,Day];
file_path_and_name = [folder_name,'\',Date,'\',Mouse,'#',Date,'.dat'];
set(handles.edit_savefile, 'String', file_path_and_name);
set(handles.pushbutton_refinement, 'enable', 'on');
% handles.fidin = fopen(file_path_and_name, 'w');
% set(handles.pushbutton_refinement, 'BackgroundColor', 'b');
guidata(hObject, handles);

% --- Executes on button press in pushbutton_refinement.
function pushbutton_refinement_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_refinement (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global L_P;
global M_P;
global R_P;
global Sound_S;
global Time_Tone;
global Time_Lick;
global Wait_time;
global Light_set;
global Position;
Light_set=zeros(1000,1);
for i=1:200
x=ones(1,1);
y=zeros(3,1);
z=[x;y];
Light_set(5*i-4:5*i-1)=z(randperm(4));
end
L_P=0;
M_P=0;
R_P=0;
Sound_S=0;
Time_Tone=[];
Time_Lick=[];
Wait_time=[];
Position=[];
device_ID = str2double(get(handles.edit_camara, 'String'));
imaqreset;
handles.video = videoinput('winvideo',device_ID, 'MJPG_1280x720');
set(handles.video,'FramesPerTrigger', 10);
set(handles.video,'TriggerRepeat', 10);
%set(handles.video,'ReturnedColorSpace','YCbCr');
% handles.video =webcam(device_ID);
% set(handles.video,'Resolution','320x240');
start(handles.video); 
data = getdata(handles.video, 10);
stop(handles.video);
flushdata(handles.video); 
axes(handles.axes_refImg);
handles.axes_diffImg.Colormap = gray(256);
refImg = uint8(round(mean(data, 4))); 
handles.refImg = rgb2gray(refImg);
handles.refImg = handles.refImg(1:4:end, 1:4:end);
%J=imadjust(handles.refImg);
[m,n] = size(handles.refImg); 
set(handles.axes_refImg,'XLim',[0 n],'YLim',[0 m]);
set(handles.axes_preview,'XLim',[0 n],'YLim',[0 m]);
set(handles.axes_diffImg,'XLim',[0 n],'YLim',[0 m]);
imshow(handles.refImg); 
imwrite(handles.refImg,'refImg(320x240).bmp','BMP');
% imshow(handles.refImg); 
% imwrite(handles.refImg,gray,'refImg(320x240).bmp','BMP');
co = m; %col # of the image
ro = n; %row # of the iamge
fc = 15; %cut off frequency of the low-pass filter of the image
handles.H = ideal_filter(co,ro,fc); %use idea filter 
handles.n = n;  %320
handles.m = m;  %240
position = [229   70  52  75];
position2=[64   70  50  75];
position3= [203   70  25  75];
handles.rect = imrect(gca,position);
handles.rect2 = imrect(gca,position2);
handles.rect3 = imrect(gca,position3);
set(handles.pushbutton_start, 'enable', 'on');
set(handles.pushbutton_start, 'BackgroundColor', 'g');
set(handles.edit_currenttime, 'String',0);
set(handles.edit_Tone, 'String',0);
set(handles.edit_Lick, 'String',0);
guidata(hObject, handles);

% --- Executes on button press in pushbutton_stop.
function pushbutton_stop_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_stop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Time_Tone;
global Time_Lick;
global Time_Delay;
global Wait_time;
global Light;
global Light_set;
global Wait_in;
global Mark_Light;
path=get(handles.edit_savefile, 'String');
path=path(1:end-4);
fclose(handles.Temp);
Position = importdata('temp.txt');
delete('temp.txt')
save(strcat(path,'-time_Tone.mat'),'Time_Tone');
save(strcat(path,'-time_Position.mat'),'Position');
save(strcat(path,'-Waittime.mat'),'Wait_time');
save(strcat(path,'-Wait_in.mat'),'Wait_in');
save(strcat(path,'-time_Lick_Reward.mat'),'Time_Lick');
save(strcat(path,'-runtime.mat'),'Time_Delay');
POS(1,:)=getPosition(handles.rect);
POS(2,:)=getPosition(handles.rect2);
POS(3,:)=getPosition(handles.rect3);
%save('C:\Dat-Cre\999\POS.mat','POS');
op=get(handles.popupmenu_op,'Value');
switch op
    case 2
    save(strcat(path,'-Light_set.mat'),'Light_set');
    save(strcat(path,'-Mark_Light.mat'),'Mark_Light');
end
stop(handles.video);
set(handles.edit_savefile, 'enable', 'on');
set(handles.pushbutton_save, 'enable', 'on');
set(handles.edit_camara, 'enable', 'on');
set(handles.edit_threshold, 'enable', 'on');
set(handles.pushbutton_preview, 'enable', 'on');
set(handles.pushbutton_refinement, 'enable', 'on');
set(handles.pushbutton_stop, 'enable', 'off');
set(handles.pushbutton_start, 'enable', 'off');
set(handles.pushbutton_stop, 'enable', 'off');
set(handles.pushbutton_preview, 'enable', 'on');
pause(1);
Sound_Y=sin((2*pi*(1:5*1000*2)/5));
%sound(Sound_Y,5*1000,8);
% fprintf(Light,'%s',['4,',get(handles.Water_Volume, 'String')]);
display 'Good end ！'



% --- Executes on button press in pushbutton_start.
function pushbutton_start_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global frame;
global Position;
global Wait_in;
handles.Temp = fopen('temp.txt','w');
path=get(handles.edit_savefile, 'String');
id=find(path=='\');
Dir_name=path(1:id(end));
if ~exist(Dir_name,'dir')
    mkdir(Dir_name);
end
Wait_in=[];
Position=[];
frame=0;
guidata(hObject, handles);
set(handles.text_r, 'UserData', 0);
set(handles.text_c, 'UserData', 0);
set(handles.pushbutton_stop, 'enable', 'on');
set(handles.edit_lefttime, 'String', '0');
set(handles.Water_Volume, 'String', '0');
set(handles.wait_time, 'String', '0');
set(handles.delay_time, 'String', '0');
set(handles.edit_middletime, 'String', '0');
set(handles.edit_righttime, 'String', '0');
set(handles.pushbutton_preview, 'enable', 'off');
set(handles.pushbutton_refinement, 'enable', 'off');
set(handles.pushbutton_start, 'enable', 'off');
set(handles.video,'FramesPerTrigger',...
    1,'TriggerRepeat',...
    inf,'FramesAcquiredFcnCount', 1); 
handles.video.FramesAcquiredFcn = {@call_DG_Training,handles};
start(handles.video);
tic;

function call_DG_Training(hObject,eventdata,handles)
global L_P;
global M_P;
global R_P;
global Sound_S;              
global Time_Tone;
global Time_Lick;
global Time_Delay;
global frame;
global Position;
global Wait_time;
global Light;
global Light_set;
global Lick_M;
global Sound;
global Timer_Sound;
global prot;
global Wait_in;
global Mark_Light
op=get(handles.popupmenu_op,'Value');
Timer_S=get(handles.popupmenu_Timer,'Value');
frame=frame+1;
prot=get(handles.popupmenu_protocol,'Value');
set(handles.edit_currenttime, 'String', num2str(toc));
%image processing
Data = getdata(handles.video, 1);
flushdata(handles.video); 
data = rgb2gray(Data);
data = data(1:4:end, 1:4:end);
diffFrame = handles.refImg - data; 
%diffFrame = imabsdiff(data(:, :, 1, 1), handles.refImg); 
n = handles.n; 
m = handles.m; 
im = zeros(m,n); 
handles.threshold = str2double(get(handles.edit_threshold,'String'));
p = diffFrame > handles.threshold;
im(p) = 100;
imf = fftshift(fft2(im));
%filter  
filteredImg=abs(ifft2(imf.*handles.H));
image(flipud(Data(1:4:end, 1:4:end,:)), 'parent', handles.axes_preview);
image(flipud(filteredImg), 'parent', handles.axes_diffImg);
%Mouse location
[g,h] = find(filteredImg > 60);
filteredImg = sparse(g,h,255,m,n);
[mouse_r,mouse_c] = find(filteredImg == 255);
rr = round(mean(mouse_r));
cc = round(mean(mouse_c));
Location_R = str2double(get(handles.text_r, 'String'));
Location_C = str2double(get(handles.text_c, 'String')); 
if ~isnan(rr)
    Location_R = rr;
    Location_C = cc;
end
set(handles.text_r, 'String', num2str(Location_R));
set(handles.text_c, 'String', num2str(Location_C));
% tell moues location, inside or outside
pos=getPosition(handles.rect);
pos2=getPosition(handles.rect2);
pos3=getPosition(handles.rect3);
time=toc;
Position(1)=toc;
Position(2)=Location_R;
Position(3)=Location_C;
fprintf(handles.Temp,'%6.2f%6.2f%6.2f\n',Position);
if  Location_R > pos(2) && Location_R < pos(2) + pos(4) && Location_C > pos(1) && Location_C < pos(1) + pos(3)
    if M_P==1
    fprintf(Light, '%s','0');
%     start(Sound);
    NO_Tone = str2double(get(handles.edit_Tone, 'String')) + 1;    
    Wait_in(NO_Tone)=toc;
    M_P=0;
    L_P=1;
    R_P=0;
    if Timer_S==2
    %start(Timer_Sound);
    end
    switch op
        case 2
            Light_Status=Light_set(NO_Tone);
            set(handles.edit_light1,'String',num2str(Light_Status));
            Mark_Light(1,NO_Tone)=str2double(get(handles.edit_light1, 'String'));
            if Light_Status==1
%                 light_s=['3,20,30,2'];%Excitation
%                 light_s=['3,20,30,3'];%Excitation
                light_s=['3,20,5,5'];%Excitation
                %     light_s=['5,10'];%Excitation 5为刺激间隔不断减小 后一位是每次脉冲时间
                %     light_s=['6,10,200,16,10'];%Excitation 6为脉冲时间不断增加 分别对应 频率 增加时间（us）总刺激时间 脉冲时长起始值
                fprintf(Light,'%s',light_s);
            end
            % fprintf(Light,'%s',['5,2']);
            %    fprintf(Light,'E');
    end   
    end
    NO_Tone = str2double(get(handles.edit_Tone, 'String')) + 1;
    time=toc;
    waittime=time-Wait_in(NO_Tone);
    set(handles.wait_time, 'String', num2str(waittime));
elseif Location_R > pos2(2) && Location_R < pos2(2) + pos2(4) && Location_C > pos2(1) && Location_C < pos2(1) + pos2(3)    
    L_P=0;
    R_P=1;
    M_P=0;
else
    M_P=1;
%     L_P=0;
%     R_P=0;
end
if L_P==1&& M_P==1&&Location_C>pos3(1)
    %stop(Timer_Sound);
     fprintf(Light,'%s','7');
    NO_Tone = str2double(get(handles.edit_Tone, 'String')) + 1;
    set(handles.edit_Tone, 'String', num2str(NO_Tone));
    switch op
        case 2
            Light_Status=Light_set(NO_Tone);
            if Light_Status==1
                fprintf(Light,'%s','O');
            end
    end
    switch prot
        case 1
            waittime=str2double(get(handles.wait_time, 'String'));
            if waittime<2
                Volumes=0;
            else
                Volumes=4;
            end
        case 2
            waittime=str2double(get(handles.wait_time, 'String'));
            if waittime<3
                Volumes=0;
            else
                Volumes=4;
            end
        case 3
            waittime=str2double(get(handles.wait_time, 'String'));
            if waittime<6
                Volumes=0;
            else
                Volumes=8;
            end
        case 4
            Volumes=10;
%         case 1
%             Volumes=10;
%         case 2
%             ff=str2double(get(handles.edit_time_scale,'string'));
%             waittime=str2double(get(handles.wait_time, 'String'));
%             Volumes=round(2*3.^(floor((waittime-2)/ff)*ff/2));
%             if waittime<2
%                 Volumes=0;
%             elseif waittime>8
%                 Volumes=30;
%             end
%         case 3
%             if waittime>8
%                 Volumes=2;
%             elseif waittime>=2&&waittime<4
%                 Volumes=8;
%             elseif waittime>=4&&waittime<6
%                 Volumes=16;
%             elseif waittime>=6&&waittime<8
%                 Volumes=8;
%             else
%                 Volumes=0;
%             end
    end
    Time_Tone(1,NO_Tone)=toc;
    Wait_time(1,NO_Tone)=str2double(get(handles.wait_time, 'String'));
    L_P=0;
    Sound_S=1;
    set(handles.edit_Volume,'string',Volumes);
    set(handles.wait_time, 'String', 0);
end
NO_Tone = str2double(get(handles.edit_Tone, 'String'));
if R_P==1&&Sound_S==1&&Lick_M==1
    lick_volume=str2double(get(handles.edit_Volume,'String'))*0.025;
    NO_Lick= str2double(get(handles.edit_Lick, 'String')) + 1;
    set(handles.edit_Lick, 'String', num2str(NO_Lick));
    Time_Lick(1,NO_Lick)=toc;
    Time_Delay(1,NO_Lick)=Time_Lick(1,NO_Lick)-Time_Tone(1,NO_Tone);
    set(handles.delay_time,'string',Time_Delay(1,NO_Lick));
    water= str2double(get(handles.Water_Volume, 'String')) + lick_volume/0.025;
    set(handles.Water_Volume, 'String', num2str(water));
    fprintf(Light,'%s',['1,',get(handles.edit_Volume,'String')]);
    Sound_S=0;
    set(handles.edit_lick11,'String',num2str(Lick_M));
end
test_time = str2double(get(handles.edit_test_time,'String'));
Water_Volume = str2double(get(handles.Water_Volume,'String'));
if time > test_time||Water_Volume> 400 
    pushbutton_stop_Callback(hObject,eventdata,handles);
    Email('tiezhantest@163.com','timeup','Computer 1 task finished')
end


function Email(Address,subject,content,file)
props = java.lang.System.getProperties;
props.setProperty('mail.smtp.auth','true');
MyAddress = 'sunlab111@163.com';
Password = 'UBGQFXWRRZQHOCFM';
setpref('Internet','SMTP_Server','smtp.163.com');
setpref('Internet','E_mail',MyAddress);
setpref('Internet','SMTP_Username',MyAddress);
setpref('Internet','SMTP_Password',Password);
if nargin == 2
    sendmail(Address,subject);
elseif nargin == 3
    sendmail(Address,subject,content);
    elseif nargin == 4
    sendmail(Address,subject,content,file);
elseif nargin>4||nargin<2
    error( 'Input Error' );
end

function edit_load_file_name_Callback(hObject, eventdata, handles)
% hObject    handle to edit_load_file_name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_load_file_name as text
%        str2double(get(hObject,'String')) returns contents of edit_load_file_name as a double


% --- Executes during object creation, after setting all properties.
function edit_load_file_name_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_load_file_name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_load.
function pushbutton_load_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_load (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename, pathname] = uigetfile('*.dat', 'Open CPPTest file'); 

handles.file_path_and_name = [pathname filename];

set(handles.edit_load_file_name, 'String', handles.file_path_and_name);

guidata(hObject, handles);


function edit_total_time_Callback(hObject, eventdata, handles)
% hObject    handle to edit_total_time (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_total_time as text
%        str2double(get(hObject,'String')) returns contents of edit_total_time as a double


% --- Executes during object creation, after setting all properties.
function edit_total_time_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_total_time (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_bin_Callback(hObject, eventdata, handles)
% hObject    handle to edit_bin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_bin as text
%        str2double(get(hObject,'String')) returns contents of edit_bin as a double


% --- Executes during object creation, after setting all properties.
function edit_bin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_bin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_from_time_Callback(hObject, eventdata, handles)
% hObject    handle to edit_from_time (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_from_time as text
%        str2double(get(hObject,'String')) returns contents of edit_from_time as a double


% --- Executes during object creation, after setting all properties.
function edit_from_time_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_from_time (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_to_time_Callback(hObject, eventdata, handles)
% hObject    handle to edit_to_time (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_to_time as text
%        str2double(get(hObject,'String')) returns contents of edit_to_time as a double


% --- Executes during object creation, after setting all properties.
function edit_to_time_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_to_time (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_currenttime_Callback(hObject, eventdata, handles)
% hObject    handle to edit_currenttime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_currenttime as text
%        str2double(get(hObject,'String')) returns contents of edit_currenttime as a double


% --- Executes during object creation, after setting all properties.
function edit_currenttime_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_currenttime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_currentposition_Callback(hObject, eventdata, handles)
% hObject    handle to edit_currentposition (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_currentposition as text
%        str2double(get(hObject,'String')) returns contents of edit_currentposition as a double


% --- Executes during object creation, after setting all properties.
function edit_currentposition_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_currentposition (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_lefttime_Callback(hObject, eventdata, handles)
% hObject    handle to edit_lefttime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_lefttime as text
%        str2double(get(hObject,'String')) returns contents of edit_lefttime as a double


% --- Executes during object creation, after setting all properties.
function edit_lefttime_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_lefttime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_middletime_Callback(hObject, eventdata, handles)
% hObject    handle to edit_middletime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_middletime as text
%        str2double(get(hObject,'String')) returns contents of edit_middletime as a double


% --- Executes during object creation, after setting all properties.
function edit_middletime_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_middletime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_righttime_Callback(hObject, eventdata, handles)
% hObject    handle to edit_righttime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_righttime as text
%        str2double(get(hObject,'String')) returns contents of edit_righttime as a double


% --- Executes during object creation, after setting all properties.
function edit_righttime_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_righttime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_leftdistance_Callback(hObject, ~, handles)
% hObject    handle to edit_leftdistance (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_leftdistance as text
%        str2double(get(hObject,'String')) returns contents of edit_leftdistance as a double


% --- Executes during object creation, after setting all properties.
function edit_leftdistance_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_leftdistance (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_middledistance_Callback(hObject, eventdata, handles)
% hObject    handle to edit_middledistance (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_middledistance as text
%        str2double(get(hObject,'String')) returns contents of edit_middledistance as a double


% --- Executes during object creation, after setting all properties.
function edit_middledistance_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_middledistance (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_rightdistance_Callback(hObject, eventdata, handles)
% hObject    handle to edit_rightdistance (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_rightdistance as text
%        str2double(get(hObject,'String')) returns contents of edit_rightdistance as a double


% --- Executes during object creation, after setting all properties.
function edit_rightdistance_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_rightdistance (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_leftnumber_Callback(hObject, eventdata, handles)
% hObject    handle to edit_leftnumber (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_leftnumber as text
%        str2double(get(hObject,'String')) returns contents of edit_leftnumber as a double


% --- Executes during object creation, after setting all properties.
function edit_leftnumber_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_leftnumber (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_middlenumber_Callback(hObject, eventdata, handles)
% hObject    handle to edit_middlenumber (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_middlenumber as text
%        str2double(get(hObject,'String')) returns contents of edit_middlenumber as a double


% --- Executes during object creation, after setting all properties.
function edit_middlenumber_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_middlenumber (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_rightnumber_Callback(hObject, eventdata, handles)
% hObject    handle to edit_rightnumber (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_rightnumber as text
%        str2double(get(hObject,'String')) returns contents of edit_rightnumber as a double


% --- Executes during object creation, after setting all properties.
function edit_rightnumber_CreateFcn(hObject, ~, handles)
% hObject    handle to edit_rightnumber (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_leftp_Callback(hObject, eventdata, handles)
% hObject    handle to edit_leftp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_leftp as text
%        str2double(get(hObject,'String')) returns contents of edit_leftp as a double


% --- Executes during object creation, after setting all properties.
function edit_leftp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_leftp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_middlep_Callback(hObject, eventdata, handles)
% hObject    handle to edit_middlep (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_middlep as text
%        str2double(get(hObject,'String')) returns contents of edit_middlep as a double


% --- Executes during object creation, after setting all properties.
function edit_middlep_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_middlep (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_rightp_Callback(hObject, eventdata, handles)
% hObject    handle to edit_rightp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_rightp as text
%        str2double(get(hObject,'String')) returns contents of edit_rightp as a double


% --- Executes during object creation, after setting all properties.
function edit_rightp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_rightp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_plot.
function pushbutton_plot_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_plot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

inside_total_distance = 0;
outside_total_distance = 0;
old_inside_total_distance = 0;
old_outside_total_distance = 0;

inside_total_time = 0;
outside_total_time = 0;
old_inside_total_time = 0;
old_outside_total_time = 0;

total_cross = 0;
old_total_cross = 0;

number_of_data = 1;
time_array = [];

inside_travel_data = 0;
outside_travel_data = 0;
inside_time_data = 0;
outside_time_data = 0;
cross_data = 0;

from_time = str2double(get(handles.edit_from_time, 'String'));
to_time = str2double(get(handles.edit_to_time, 'String'));
bin = str2double(get(handles.edit_bin, 'String'));

set_time_enable = 1;

if from_time == 0 && to_time == 0
    set_time_enable = 0;
end


file_path_and_name = get(handles.edit_load_file_name, 'String');
fidout = fopen(file_path_and_name, 'r');

fgetl(fidout);
rect = fgetl(fidout);
rect = str2num(rect);
old_data = fgetl(fidout);
old_data = str2num(old_data);

while old_data(2:3) == [0 0]
    old_data = fgetl(fidout);
    old_data = str2num(old_data);
end

if old_data(2) > rect(2) && old_data(2) < rect(2) + rect(4) && old_data(3) > rect(1) && old_data(3) < rect(1) + rect(3)
    old_data_flag = 1;
else
    old_data_flag = 0;
end

figure;
subplot(2,2,1);
axis([0,320,0,240]);
set(gca,'XTick', [],'YTick',[],'Box','on');


while ~feof(fidout)
    new_data = fgetl(fidout);
    new_data = str2num(new_data);
    
    if set_time_enable
        if new_data(1)< from_time
            continue;
        end
        
        if new_data(1)> to_time
            break;  
        end
    end
    
    hold on;
    plot([new_data(3) old_data(3)], [240 - new_data(2) 240-old_data(2)]);
    
    if new_data(2) > rect(2) && new_data(2) < rect(2) + rect(4) && new_data(3) > rect(1) && new_data(3) < rect(1) + rect(3)
        new_data_flag = 1;
        inside_total_distance = sqrt((new_data(2)-old_data(2))^2 + (new_data(3)-old_data(3))^2) + inside_total_distance;
        inside_total_time = new_data(1) - old_data(1) + inside_total_time;
    else
        new_data_flag = 0;
        outside_total_distance = sqrt((new_data(2)-old_data(2))^2 + (new_data(3)-old_data(3))^2) + outside_total_distance;
        outside_total_time = new_data(1) - old_data(1) + outside_total_time;        
    end    
 
    if new_data_flag == 1&&old_data_flag == 0
        total_cross = total_cross + 1;
    end
    

     if new_data(1) <= bin*number_of_data
        % cross time data
        time_array(number_of_data) = bin*number_of_data;
        cross_data(number_of_data) = total_cross - old_total_cross;
        
        %inside time and travel distance data
        inside_travel_data(number_of_data) = inside_total_distance - old_inside_total_distance;
        inside_time_data(number_of_data) = inside_total_time - old_inside_total_time;      
        
        %outside time and travel distance data
        outside_travel_data(number_of_data) = outside_total_distance - old_outside_total_distance;
        outside_time_data(number_of_data) = outside_total_time - old_outside_total_time;
        
     else
         number_of_data = number_of_data + 1;
         time_array(number_of_data) = bin*number_of_data;
         
         cross_data(number_of_data) = 0;
         old_total_cross = total_cross;
         
         inside_travel_data(number_of_data) = 0;
         inside_time_data(number_of_data) = 0;
         old_inside_total_distance = inside_total_distance;
         old_inside_total_time = inside_total_time;
         
         outside_travel_data(number_of_data) = 0;
         outside_time_data(number_of_data) = 0;
         old_outside_total_distance = outside_total_distance;
         old_outside_total_time = outside_total_time;
   
        %curve
   
    end
    
 
    old_data = new_data;
    old_data_flag = new_data_flag;

end

set(handles.edit_total_time, 'String', new_data(1));
set(handles.edit_total_distance_inside, 'String', num2str(inside_total_distance));
set(handles.edit_total_distance_outside, 'String', num2str(outside_total_distance));
inside_travel_per = 100*inside_total_distance/(inside_total_distance+outside_total_distance);
set(handles.edit_inside_travel_per, 'String', num2str(inside_travel_per));
set(handles.edit_time_in, 'String', num2str(inside_total_time));
set(handles.edit_time_out, 'String', num2str(outside_total_time));
inside_time_per = 100*inside_total_time/(inside_total_time+outside_total_time);
set(handles.edit_inside_time_per, 'String', num2str(inside_time_per));
set(handles.edit_cross_time, 'String', num2str(total_cross));

rectangle('Position',rect,'EdgeColor','red');
title('Mouse track');


subplot(2,2,2);
plot(time_array, 100*inside_time_data./(inside_time_data+outside_time_data), 'Color', 'blue','Marker','o','MarkerEdgeColor','red');
hold on;
t = strcat('Time Spent(', 'I: ', num2str(inside_total_time),', O: ',num2str(outside_total_time),', [',num2str(inside_time_per),'%])');
title(t);
set(get(gca,'XLabel'), 'String','Time (s)');
set(get(gca,'YLabel'), 'String','Inside Time Percentage');


subplot(2,2,3);
plot(time_array, 100*inside_travel_data./(inside_travel_data+outside_travel_data), 'Color', 'blue','Marker','o','MarkerEdgeColor','red');
hold on;
t = strcat('Travel Distance(', 'I: ', num2str(inside_total_distance),', O: ',num2str(outside_total_distance),', [',num2str(inside_travel_per),'%])');
title(t);
set(get(gca,'XLabel'), 'String','Time (s)');
set(get(gca,'YLabel'), 'String','Inside Travel Percentage');


subplot(2,2,4);
plot(time_array, cross_data, 'Color', 'blue','Marker','o','MarkerEdgeColor','red');
t = strcat('Entry Time(', 'Total: ', num2str(total_cross),')');
title(t);
set(get(gca,'XLabel'), 'String','Time (s)');
set(get(gca,'YLabel'), 'String','Entry Time');

fclose(fidout);

function edit_test_time_Callback(hObject, eventdata, handles)
% hObject    handle to edit_test_time (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_test_time as text
%        str2double(get(hObject,'String')) returns contents of edit_test_time as a double


% --- Executes during object creation, after setting all properties.
function edit_test_time_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_test_time (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_Volume_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Volume (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Volume as text
%        str2double(get(hObject,'String')) returns contents of edit_Volume as a double


% --- Executes during object creation, after setting all properties.
function edit_Volume_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Volume (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Forward.
function Forward_Callback(hObject, eventdata, handles)
global Light;
fprintf(Light,'%s',['1,',get(handles.edit_Volume,'String')]);    

% hObject    handle to Forward (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in Backward.
function Backward_Callback(hObject, eventdata, handles)
global Light;
fprintf(Light,'%s',['4,',get(handles.edit_Volume,'String')]);    
% hObject    handle to Backward (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit_tone_frequency_Callback(hObject, eventdata, handles)
% hObject    handle to edit_tone_frequency (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_tone_frequency as text
%        str2double(get(hObject,'String')) returns contents of edit_tone_frequency as a double


% --- Executes during object creation, after setting all properties.
function edit_tone_frequency_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_tone_frequency (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_tone_time_Callback(hObject, eventdata, handles)
% hObject    handle to edit_tone_time (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_tone_time as text
%        str2double(get(hObject,'String')) returns contents of edit_tone_time as a double


% --- Executes during object creation, after setting all properties.
function edit_tone_time_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_tone_time (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_tone_test.
function pushbutton_tone_test_Callback(hObject, eventdata, handles)
tf=str2double(get(handles.edit_tone_frequency, 'String'));
tt=str2double(get(handles.edit_tone_time, 'String'))/1000;
Sound_Y=ones(2*tf*tt,1);
Sound_Y(2:2:end)=-1;        
 %sound(Sound_Y,tf*2,8);

% global Light;
%  tone_frequency=get(handles.edit_tone_frequency, 'String');
%  tone_time=get(handles.edit_tone_time, 'String');
%  fprintf(Light,'%s',['2,',tone_frequency,',',tone_time]);
% hObject    handle to pushbutton_tone_test (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function Delay_Reward_Callback(hObject, eventdata, handles)
% hObject    handle to Delay_Reward (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Delay_Reward as text
%        str2double(get(hObject,'String')) returns contents of Delay_Reward as a double


% --- Executes during object creation, after setting all properties.
function Delay_Reward_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Delay_Reward (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function wait_time_Callback(hObject, eventdata, handles)
% hObject    handle to wait_time (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of wait_time as text
%        str2double(get(hObject,'String')) returns contents of wait_time as a double


% --- Executes during object creation, after setting all properties.
function wait_time_CreateFcn(hObject, eventdata, handles)
% hObject    handle to wait_time (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_Tone_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Tone (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Tone as text
%        str2double(get(hObject,'String')) returns contents of edit_Tone as a double


% --- Executes during object creation, after setting all properties.
function edit_Tone_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Tone (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_Lick_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Lick (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Lick as text
%        str2double(get(hObject,'String')) returns contents of edit_Lick as a double


% --- Executes during object creation, after setting all properties.
function edit_Lick_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Lick (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function figure1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called



function Water_Volume_Callback(hObject, eventdata, handles)
% hObject    handle to Water_Volume (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Water_Volume as text
%        str2double(get(hObject,'String')) returns contents of Water_Volume as a double


% --- Executes during object creation, after setting all properties.
function Water_Volume_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Water_Volume (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit35_Callback(hObject, eventdata, handles)
% hObject    handle to edit35 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit35 as text
%        str2double(get(hObject,'String')) returns contents of edit35 as a double


% --- Executes during object creation, after setting all properties.
function edit35_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit35 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_lick11_Callback(hObject, eventdata, handles)
% hObject    handle to edit_lick11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_lick11 as text
%        str2double(get(hObject,'String')) returns contents of edit_lick11 as a double


% --- Executes during object creation, after setting all properties.
function edit_lick11_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_lick11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit46_Callback(hObject, eventdata, handles)
% hObject    handle to edit46 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit46 as text
%        str2double(get(hObject,'String')) returns contents of edit46 as a double


% --- Executes during object creation, after setting all properties.
function edit46_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit46 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_time_scale_Callback(hObject, eventdata, handles)
% hObject    handle to edit_time_scale (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_time_scale as text
%        str2double(get(hObject,'String')) returns contents of edit_time_scale as a double


% --- Executes during object creation, after setting all properties.
function edit_time_scale_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_time_scale (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu_protocol.
function popupmenu_protocol_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_protocol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_protocol contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_protocol


% --- Executes during object creation, after setting all properties.
function popupmenu_protocol_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_protocol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function delay_time_Callback(hObject, eventdata, handles)
% hObject    handle to delay_time (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of delay_time as text
%        str2double(get(hObject,'String')) returns contents of delay_time as a double


% --- Executes during object creation, after setting all properties.
function delay_time_CreateFcn(hObject, eventdata, handles)
% hObject    handle to delay_time (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_light1_Callback(hObject, eventdata, handles)
% hObject    handle to edit_light1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_light1 as text
%        str2double(get(hObject,'String')) returns contents of edit_light1 as a double


% --- Executes during object creation, after setting all properties.
function edit_light1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_light1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu_op.
function popupmenu_op_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_op (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_op contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_op


% --- Executes during object creation, after setting all properties.
function popupmenu_op_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_op (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu_Timer.
function popupmenu_Timer_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_Timer (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_Timer contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_Timer


% --- Executes during object creation, after setting all properties.
function popupmenu_Timer_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_Timer (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function axes14_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes14
