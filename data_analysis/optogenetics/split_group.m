Wait_time(:,1) = []
Wait_time(:,end) = [] %% 去掉第一个和最后一个小鼠防止可能出现懈怠导致数据不稳
Mark_Light(length(Wait_time)+1:end) = []; %% delete last trial from raw data to make M and W same length
Exction = []; %% creat dataframe to store data
Nonex = []; %% creat dataframe to store data
for i = 1:length(Mark_Light)
    if Mark_Light(i) == 1
        Exction(end+1) = Wait_time(i)  %% filter out activation
    else
        Nonex(end+1) = Wait_time(i)  %% normal trial, no activation
    end
end


stmu = mean(Exction) %% record mean waittime after stimulated 
normal = mean(Nonex)%% record mean waittime unstimulated 
