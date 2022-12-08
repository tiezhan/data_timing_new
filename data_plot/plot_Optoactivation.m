data = new
figure(1);
sctbarplot(data) %% call sctbarplot
xticks([1.5 3.5])
xticklabels({'Baseline', 'Activation'})
ylabel('Waiting Duration (s)') 
[h,p1,ci,stats] = ttest(data(:,1),data(:,3)); %% º∆À„DAY p value
[h,p2,ci,stats] = ttest(data(:,2),data(:,3)); %% º∆À„DAY p value