zall = zscore(data,1,2);%% z-score all trial & sort
zall = sortrows(zall, 250, 'ascend');
zall =  zall - zall(:,50); %% normalize to time 0 aka. wait start