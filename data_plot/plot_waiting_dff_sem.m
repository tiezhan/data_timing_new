%% plot dff with mean and sem
ttick = (-50:500)/100;
twin = [-0.5 5];
figure(11);
hold on;
% data = xxxxx;
% data_mean = mean(data, 1);
% data_sem  = std(data, 0, 1)/sqrt(size(data,1));
% 

 for i=1:1:size(Gwait0s,1)
     h1 = plot(ttick, 100*Gwait0s(i,:), 'Color',[0.7 0.7 0.7]);
 end

 for i=1:1:size(Gwait2s,1)
     h2= plot(ttick, 100*Gwait2s(i,:), 'Color',[0.5 0.5 0.5]);
 end
 
 for i=1:1:size(Gwait3s,1)
     h3 = plot(ttick, 100*Gwait3s(i,:), 'Color',[0.3 0.3 0.3]);
 end
h4 = BF_plotwSEM(ttick,100*Gwait0s_mean,100*Gwait0s_sem);
h5 = BF_plotwSEM(ttick,100*Gwait2s_mean,100*Gwait2s_sem);
h6 = BF_plotwSEM(ttick,100*Gwait3s_mean,100*Gwait3s_sem);
legend([h1 h2 h3 h4 h5 h6], {'waiting 0s','waiting 2s','waiting 3s','mean waiting 0s','mean waiting 2s', 'mean waiting 3s'})
xlim(twin);
xlabel('Time from waiting onset (s)');
ylabel('%\DeltaF/F');
title('Neuron Response during time-waiting for 0/2/3 seconds')
