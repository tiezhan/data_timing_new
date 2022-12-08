path = 'D:\lutiezhan\data_number\fiber_recording\DAT-cre-vta\2ds'; %%设置路径，以下函数会自动调取该路径下所有的文件夹，再逐一读取其子文件夹
c = dir(path);
dff0 = [];
dff2 = [];
dff3 = [];
for i = 1:length(c)
    if(isequal(c(i).name,'.')||... %% 跳过根目录
       isequal(c(i).name,'..')||...
       ~c(i).isdir)
   continue;
    end
    secondpath = fullfile(path, c(i).name); %% 读取每个文件夹下的子文件夹
    [a1,a2,a3]= Call_find_dff_signal(secondpath,1); %% call function timewait，计算子文件夹下.mat数据,condition1= 计算wait， 2=计算离开，3=计算喝水
    if ~isempty(a1)
    dff0 = vertcat(dff0,a1);%% 将每次返回的a1,a2,a3值合并到TimeWait,TimeRun和TimeRound这三个变量中
    end
    if ~isempty(a2)
    dff2 = vertcat(dff2,a2);
    end
    if ~isempty(a3)
    dff3 = vertcat(dff3,a3);
    end
end

        
       