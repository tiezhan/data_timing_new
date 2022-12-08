
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
Wait_time(:,end) = [] %% 去掉第一个和最后一个小鼠防止可能出现懈怠导致数据不稳
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
    waitt = [waitt mean(Wait_time)]; %% 运行计算waittime
r = exist('Time_Delay','var')   %% 运行计算runtime，如果有runtime input runtime， 如果没有就用time lick 减去time tone计算
if length(Time_Lick) > 0
Time_Tone = paringseq(Time_Lick,Time_Tone); %% 调用paringseq计算time lick time tone 差值
else 
    continue
end
if r > 0
runt = [runt mean(Time_Delay)]
else
    runt(end+1) = mean((Time_Lick - Time_Tone),'omitnan')
end
totaltime = []
r = exist('Wait_in','var') %% 运行计算trial time, 前后两个wait in 相减即为trial time
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
save([path,'\',filename],'waitt','trialt','runt') %% 保存数据至当前文件夹， 并返回waittime