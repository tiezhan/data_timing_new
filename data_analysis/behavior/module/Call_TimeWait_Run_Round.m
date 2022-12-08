
function [waitt, runt, trialt]=Call_TimeWait_Run_Round(path)
waitt = [] %% save mean data
runt = []%% save runtime
trialt = []
% path = uigetdir('choose a file')
a=dir(path)
for i = 1:length(a)
    if(isequal(a(i).name,'.')||...
       isequal(a(i).name,'..')||...
       isequal(a(i).name,'1mw')||...
       isequal(a(i).name,'5mw')||...
       isequal(a(i).name,'inhibition')||...
       isequal(a(i).name,'chr2')||...
       isequal(a(i).name,'10mw')||...
       ~a(i).isdir)
   continue;
    end
    subpath = fullfile(path, a(i).name, '*.mat')
    aa = dir(subpath)
% 
    for j =1:length(aa)
        await = fullfile(path,a(i).name,aa(j).name)
        load(await)
%         curve_wait_2s = [curve_wait_2s mean(Wait_time)];      %% collect means all over
%         curve_sd_2s = [curve_sd_2s std(Wait_time)];
    end
Wait_time(:,1) = []
Wait_time(:,end) = [] %% ȥ����һ�������һ��С���ֹ���ܳ���и���������ݲ���
    label = 1
while label
    mean_wait = mean(Wait_time);
    std_wait = std(Wait_time);
    new_wait = [];
    % delete outliers mean +- 5*sd
    for i = 1:length(Wait_time)
        if (Wait_time(i) < mean_wait + 5*std_wait) && (Wait_time(i) > mean_wait - 5*std_wait)
            new_wait(end + 1) = Wait_time(i);
        end
    end
    if length(new_wait) == length(Wait_time)
        label = 0 
    else
        Wait_time = new_wait
    end
end
    waitt = [waitt mean(Wait_time)]; %% ���м���waittime
r = exist('Time_Delay','var')   %% ���м���runtime�������runtime input runtime�� ���û�о���time lick ��ȥtime tone����
if length(Time_Lick) > 0
Time_Tone = paringseq(Time_Lick,Time_Tone); %% ����paringseq����time lick time tone ��ֵ
else 
    continue
end
if r > 0
runt = [runt mean(Time_Delay)]
else
    runt(end+1) = mean((Time_Lick - Time_Tone),'omitnan')
end
totaltime = []
r = exist('Wait_in','var') %% ���м���trial time, ǰ������wait in �����Ϊtrial time
if r > 0
for i = 1:length(Wait_in) - 1
    totaltime(end + 1) = Wait_in(i+1) - Wait_in(i)
end
trialt = [trialt mean(totaltime)]
else trialt(end+1) = NaN
end

end


    waitt(end:100) = NaN
    trialt(end:100) = NaN
    runt(end:100) = NaN


filename = 'mice.mat'; 
save([path,'\',filename],'waitt','trialt','runt') %% ������������ǰ�ļ��У� ������waittime