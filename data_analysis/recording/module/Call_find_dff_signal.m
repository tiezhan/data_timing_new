function [dff_0s, dff_2s, dff_3s]= Call_find_dff_signal(path,condition)
dff_0s= [];
dff_2s = [];
dff_3s = [];
%% save dff data
% path = uigetdir('choose a file')
a=dir(path); %%ת��DAY1Ŀ¼
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
    subpath = fullfile(path, a(j).name, '*.csv'); %%�ҵ�DAY1 Ŀ¼�µ�i�����ļ������к���csv�ļ������ļ���
    aa = dir(subpath); %%ת������csv�ļ��ĵ�һ�����ļ���
        data = csvread(aa.name); %% ��ȡcsv�ļ���Ϊ����
        Fs = 100;
        [tRise, tDur] = detectTTL(data(:,2));
        tRise_wait = tRise/Fs;
        tDur_wait  = tDur/Fs;
        wave_raw = data(:,4);
        [wait0,wait2,wait3] = setcondition(tRise_wait,tDur_wait); %% call setcondition, ��tRise_wait��Dur_wait�ֳ�wait, leave,drink,duration�󷵻�
        if ~isempty(wait0)
        [dff,~,~, ~] = signaldff(wave_raw,wait0(condition,:),100); %% data, ʱ���, 100 = samplerate
        dff_0s = vertcat(dff_0s, dff);
        end
        if ~isempty(wait2)
        [dff,~,~, ~] = signaldff(wave_raw,wait2(condition,:),100); %% data, ʱ���, 100 = samplerate
        dff_2s = vertcat(dff_2s, dff);
        end
        if ~isempty(wait3)
        [dff,~,~, ~] = signaldff(wave_raw,wait3(condition,:),100); %% data, ʱ���, 100 = samplerate
        dff_3s = vertcat(dff_3s, dff);
        end
       
end

filename = 'signal.mat'; 
save([path,'\',filename],'dff_0s','dff_2s','dff_3s') %% ������������ǰ�ļ��У� ������waittime

