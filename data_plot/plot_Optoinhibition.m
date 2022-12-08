data = new
figure(1);
sctbarplot(data) %% call sctbarplot
xticks([1.5 3.5])
xticklabels({'Baseline', 'Inhibition'})
ylabel('Waiting Duration (s)') 
[h,p1,ci,stats] = ttest(data(:,1),data(:,3)); %% º∆À„ p value
[h,p2,ci,stats] = ttest(data(:,2),data(:,3)); %% º∆À„ p value
[h,p3,ci,stats] = ttest(data(:,1),data(:,2)); %% º∆À„ p value