path = 'D:\lutiezhan\data_number\wait_behavior\VTA_cfos\3second'; %%����·�������º������Զ���ȡ��·�������е��ļ��У�����һ��ȡ�����ļ���
c = dir(path);
TimeWait = [];
TimeRun = [];
TimeRound = [];

for i = 1:length(c)
    if(isequal(c(i).name,'.')||... %% ������Ŀ¼
       isequal(c(i).name,'..')||...
       ~c(i).isdir)
   continue;
    end
    secondpath = fullfile(path, c(i).name); %% ��ȡÿ���ļ����µ����ļ���
    [a1,a2,a3]= Call_TimeWait_Run_Round(secondpath); %% call function timewait���������ļ�����.mat����, a1,a2,a3�ֱ𷵻�wait,run,trial duration
    TimeWait = vertcat(TimeWait, a1);%% ��ÿ�η��ص�a1,a2,a3ֵ�ϲ���TimeWait,TimeRun��TimeRound������������
    TimeRun = vertcat(TimeRun, a2);
    TimeRound = vertcat(TimeRound, a3);
end

% TimeWait2s = vertcat(TimeWait2s,TimeWait)
% TimeRun2s = vertcat(TimeRun2s,TimeRun)
% TimeRound2s = vertcat(TimeRound2s,TimeRound)

% TimeWait3s = vertcat(TimeWait3s,TimeWait) 
% TimeRun3s = vertcat(TimeRun3s,TimeRun)
% TimeRound3s = vertcat(TimeRound3s,TimeRound)