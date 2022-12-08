ttick = (-50:500)/100;
twin = [-0.5 5];
figure(11);
hold on;

 for i=1:1:size(Glick0s,1)
     h1 = plot(ttick, 100*Glick0s(i,:), 'Color',[0.7 0.7 0.7]);
 end

 for i=1:1:size(Glick2s,1)
     h2= plot(ttick, 100*Glick2s(i,:), 'Color',[0.5 0.5 0.5]);
 end
 
 for i=1:1:size(Glick3s,1)
     h3 = plot(ttick, 100*Glick3s(i,:), 'Color',[0.3 0.3 0.3]);
 end
h4 = BF_plotwSEM(ttick,100*Glick0s_mean,100*Glick0s_sem);
h5 = BF_plotwSEM(ttick,100*Glick2s_mean,100*Glick2s_sem);
h6 = BF_plotwSEM(ttick,100*Glick3s_mean,100*Glick3s_sem);
legend([h1 h2 h3 h4 h5 h6], {'lick 0s','lick 2s','lick 3s','mean lick 0s','mean lick 2s', 'mean lick 3s'})
xlim(twin);
xlabel('Time from licking onset (s)');
ylabel('%\DeltaF/F');