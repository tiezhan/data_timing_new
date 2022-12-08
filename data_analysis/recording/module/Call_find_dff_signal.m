function [dff_0s, dff_2s, dff_3s]= Call_find_dff_signal(path,condition)
dff_0s= [];
dff_2s = [];
dff_3s = [];
%% save dff data
% path = uigetdir('choose a file')
a=dir(path); %%转到DAY1目录
for j = 1:length(a)
    if(isequal(a(j).name,'.')||...
       isequal(a(j).name,'..')||...
       isequal(a(j).name,'1mw')||...
       isequal(a(j).name,'5mw')||...
       isequal(a(j).name,'inhibition')||...
       isequal(a(j).name,'chr2')||...
       isequal(a(j).name,'10mw')||...
       ~a(j).isdir)
   continue;
    end
    subpath = fullfile(path, a(j).name, '*.csv'); %%找到DAY1 目录下第i个子文件中所有含有csv文件的子文件夹
    aa = dir(subpath); %%转到含有csv文件的第一个子文件夹
        data = csvread(aa.name); %% 读取csv文件存为矩阵
        Fs = 100;
        [tRise, tDur] = detectTTL(data(:,2));
        tRise_wait = tRise/Fs;
        tDur_wait  = tDur/Fs;
        wave_raw = data(:,4);
        [wait0,wait2,wait3] = setcondition(tRise_wait,tDur_wait); %% call setcondition, 将tRise_wait和Dur_wait分成wait, leave,drink,duration后返回
        if ~isempty(wait0)
        [dff,~,~, ~] = signaldff(wave_raw,wait0(condition,:),100); %% data, 时间点, 100 = samplerate
        dff_0s = vertcat(dff_0s, dff);
        end
        if ~isempty(wait2)
        [dff,~,~, ~] = signaldff(wave_raw,wait2(condition,:),100); %% data, 时间点, 100 = samplerate
        dff_2s = vertcat(dff_2s, dff);
        end
        if ~isempty(wait3)
        [dff,~,~, ~] = signaldff(wave_raw,wait3(condition,:),100); %% data, 时间点, 100 = samplerate
        dff_3s = vertcat(dff_3s, dff);
        end
       
end

filename = 'signal.mat'; 
save([path,'\',filename],'dff_0s','dff_2s','dff_3s') %% 保存数据至当前文件夹， 并返回waittime

