data = TimeWait0s
new = splitbyweek(data);
figure(2);
sctbarplot(new); %% call sctbarplot
hold on;
data = TimeWait2s
new = splitbyweek(data);
sctbarplot(new) %% call sctbarplot
data = TimeWait3s
new = splitbyweek(data);
sctbarplot(new) %% call sctbarplot
xticklabels({'Week 1', 'Week 2','Week 4'})
ylabel('Waiting Duration (s)') 