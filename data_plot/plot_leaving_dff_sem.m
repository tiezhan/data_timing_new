% plot dff with mean and sem
ttick = (-50:500)/100;
twin = [-0.5 5];
figure(11);
hold on;

 for i=1:1:size(Gleave0s,1)
     h1 = plot(ttick, 100*Gleave0s(i,:), 'Color',[0.7 0.7 0.7]);
 end

 for i=1:1:size(Gleave2s,1)
     h2= plot(ttick, 100*Gleave2s(i,:), 'Color',[0.5 0.5 0.5]);
 end
 
 for i=1:1:size(Gleave3s,1)
     h3 = plot(ttick, 100*Gleave3s(i,:), 'Color',[0.3 0.3 0.3]);
 end
h4 = BF_plotwSEM(ttick,100*Gleave0s_mean,100*Gleave0s_sem);
h5 = BF_plotwSEM(ttick,100*Gleave2s_mean,100*Gleave2s_sem);
h6 = BF_plotwSEM(ttick,100*Gleave3s_mean,100*Gleave3s_sem);
legend([h1 h2 h3 h4 h5 h6], {'leave 0s','leave 2s','leave 3s','mean leave 0s','mean leave 2s', 'mean leave 3s'})
xlim(twin);
xlabel('Time from leaving onset (s)');
ylabel('%\DeltaF/F');
