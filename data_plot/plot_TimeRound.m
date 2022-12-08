%% plot scatter TimeRun DAY 1 DAY 15 DAY 30 mean +- sem
data = TimeRound
% new = splitDAY(data); %% Timewait 分成3组 ， DAY 1 15 30储存到 new
% figure(1);
% sctbarplot(new) %% call sctbarplot
% xticklabels({'Day 1', 'Day 15','Day 30'})
% ylabel('Waiting Duration (s)') 
% [h,p1,ci,stats] = ttest(new(:,1),new(:,3)); %% 计算DAY 1 15 p value
% [h,p2,ci,stats] = ttest(new(:,2),new(:,3)); %% 计算DAY 15 30 p value
 %% plot scatter Timewait WEEK 1 WEEK 15 WEEK 30 mean +- sem
% new = splitbyweek(data);
% figure(2);
% sctbarplot(new) %% call sctbarplot
% xticklabels({'Week 1', 'Week 2','Week 4'})
% ylabel('Waiting Duration (s)') 
% [h,p1,ci,stats] = ttest(new(:,1),new(:,3)); %% 计算DAY 1 15 p value
% [h,p2,ci,stats] = ttest(new(:,2),new(:,3)); %% 计算DAY 15 30 p value
%% plot scatter Timewait naive midterm final
new = testmice(data) %% Timewait 分成三组，naive，训练到一半，以及训练结束 储存在new
figure(3);
sctbarplot(new) 
xticklabels({'Naive','Trained'})
ylabel('One Round Duration (s)') 

[h,p1,ci,stats] = ttest(new(:,1),new(:,2)); %% 计算DAY 1 15 p value
