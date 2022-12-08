%% z-scored 2second waiting
data = dff2;
zall = zscore(data,1,2);%% z-score all trial & sort
zall = sortrows(zall, 300, 'descend');
zall =  zall - zall(:,50); %% normalize to time 0 aka. wait start
figure(8);
imagesc(zall)
xlabel('Time from waiting onset (s)')
xticklabels({'0','0.5','1','1.5','2','2.5','3','3.5','4','4.5'})
ylabel('# Trial')
%% z-scored 3second waiting
data = dff3;
zall = zscore(data,1,2);%% z-score all trial & sort
zall = sortrows(zall, 400, 'descend');
zall =  zall - zall(:,50); %% normalize to time 0 aka. wait start

figure(9);
imagesc(zall)
xlabel('Time from waiting onset (s)')
xticklabels({'0','0.5','1','1.5','2','2.5','3','3.5','4','4.5'})
ylabel('# Trial')
%% z-scored 2second waiting
data = dff0;
zall = zscore(data,1,2);%% z-score all trial & sort
% zall = sortrows(zall, 50, 'descend');
zall =  zall - zall(:,50); %% normalize to time 0 aka. wait start

figure(10);
imagesc(zall)
xlabel('Time from waiting onset (s)')
xticklabels({'0','0.5','1','1.5','2','2.5','3','3.5','4','4.5'})
ylabel('# Trial')