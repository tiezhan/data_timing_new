% figure(1)
% CategoricalScatterplot(fosGFP,'color',[255 0 0]/255,'BoxColor',[216 213 211]/255,'MedianColor',[1 0 0],'WhiskerColor',[1 0 0])
figure(2)
CategoricalScatterplot(foscount,'color',[200 22 30]/255,'BoxColor',[216 213 211]/255,'MedianColor',[200 22 30]/255,'WhiskerColor',[200 22 30]/255)
xticklabels({'Homecage', 'Pre-trainning','Trained wait (2s)','Trained wait (3s)'})
ylabel('Number of cFos positive cells in the DRN') 
[h,p1,ci,stats] = ttest(foscount(:,1),foscount(:,2)); %% p1: Homecage vs. 0s
[h,p2,ci,stats] = ttest(foscount(:,2),foscount(:,3)); %% p2: 0s vs.2s
[h,p3,ci,stats] = ttest(foscount(:,3),foscount(:,4)); %% p3: 2s vs 3s
% [h,p4,ci,stats] = ttest(fosGFP(:,2),fosGFP(:,4)); %% p4: 0s vs 3s
