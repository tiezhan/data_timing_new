path = 'D:\lutiezhan\data_number\wait_behavior\VTA_cfos\3second'; %%设置路径，以下函数会自动调取该路径下所有的文件夹，再逐一读取其子文件夹
c = dir(path);
TimeWait = [];
TimeRun = [];
TimeRound = [];

for i = 1:length(c)
    if(isequal(c(i).name,'.')||... %% 跳过根目录
       isequal(c(i).name,'..')||...
       ~c(i).isdir)
   continue;
    end
    secondpath = fullfile(path, c(i).name); %% 读取每个文件夹下的子文件夹
    [a1,a2,a3]= Call_TimeWait_Run_Round(secondpath); %% call function timewait，计算子文件夹下.mat数据, a1,a2,a3分别返回wait,run,trial duration
    TimeWait = vertcat(TimeWait, a1);%% 将每次返回的a1,a2,a3值合并到TimeWait,TimeRun和TimeRound这三个变量中
    TimeRun = vertcat(TimeRun, a2);
    TimeRound = vertcat(TimeRound, a3);
end

% TimeWait2s = vertcat(TimeWait2s,TimeWait)
% TimeRun2s = vertcat(TimeRun2s,TimeRun)
% TimeRound2s = vertcat(TimeRound2s,TimeRound)

% TimeWait3s = vertcat(TimeWait3s,TimeWait) 
% TimeRun3s = vertcat(TimeRun3s,TimeRun)
% TimeRound3s = vertcat(TimeRound3s,TimeRound)