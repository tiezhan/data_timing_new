ttick = (-50:500)/100;
figure(11);

data = peakGnorm;
% data_mean = dff_mean;
% data_sem = dff_sem;
data_mean = mean(data, 1);
data_sem  = std(data, 0, 1)/sqrt(size(data,1));
data_stimu = peakGstimu;
% data_stimu_mean = dff_stimu_mean;
% data_stimu_sem = dff_stimu_sem;
data_stimu_mean = mean(data_stimu, 1);
data_stimu_sem  = std(data_stimu, 0, 1)/sqrt(size(data_stimu,1));
for i=1:1:size(data,1)
hold on
    h3= plot(ttick, 100*data(i,:), 'Color',[0.3 0.3 0.3]);
end

 for i=1:1:size(data_stimu,1)
hold on
     h4= plot(ttick, 100*data_stimu(i,:), 'Color',[0.5 0.5 0.5]);
 end

[h1,h1_patch] = BF_plotwSEM(ttick,100*data_mean,100*data_sem);
hold on;
[h2,h2_patch] = BF_plotwSEM(ttick,100*data_stimu_mean,100*data_stimu_sem);
legend([h1 h2 h3 h4], {'mean Stimulation Off','mean Stimulation On', 'Stimulation Off','Stimulation On'})

xlim(twin);
xlabel('Time from waiting onset (sec)');
ylabel('%\DeltaF/F');
title('VTA Dopamine Response under DRN GABA Activation versus None Activation')