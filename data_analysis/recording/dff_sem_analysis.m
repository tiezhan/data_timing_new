data = csvread('20221025-.csv'); %% import data (~.csv)
%% figure;plotHz(Fs, sub1.D1); import data
Fs = 100;

[tRise, tDur] = detectTTL(data(:,2));
tRise_wait = tRise/Fs;
tDur_wait  = tDur/Fs;

wave_raw = raw(:,4);

[wait0,wait2,wait3] = setcondition(tRise_wait,tDur_wait); %% call setcondition, 将tRise_wait和Dur_wait分成wait, duration, leave后返回
%%第一列=等待少于1.2秒的起始点，第二行=等待2至3秒的起始点，第三行=等待3至4秒的起始点
[a1, a2, a3] = signaldff(wave_raw,wait0(1,:),100); %% data, 时间点, 100 = samplerate
dff_0s = a1;
dff_0s_mean = a2;
dff_0s_sem = a3;

[a1, a2, a3] = signaldff(wave_raw,wait2(1,:),100); %% data, 时间点, 100 = samplerate
dff_2s = a1;
dff_2s_mean = a2;
dff_2s_sem = a3;

[a1, a2, a3, a4] = signaldff(wave_raw,wait3(1,:),100); %% data, 时间点, 100 = samplerate
dff_3s = a1;
dff_3s_mean = a2;
dff_3s_sem = a3;
ttick = a4;


% %% z-scored
% ztest = zscore(wave_all,1,2)%% z-score all trial & sort
% zall = sortrows(ztest, 300, 'ascend')
% zall =  zall - zall(:,100) %% normalize to time 0 aka. wait start
% ntrial = size(zall,1);
% zall_mean = mean(zall, 1);
% zall_std  = std(zall, 0, 1);
% zall_sem  = zall_std/sqrt(ntrial);
% ttick          = samplerange/Fs;
% 
% figure(8);
% imagesc(zall)
% xlabel('Time from waiting onset (s)')
% xticklabels({'0','1','2','3','4','5','6','7','8'})
% ylabel('# Trial')
% 
% figure(9);
% hold on;
%  for i=1:1:size(zall,1)
%      plot(samplerange/Fs, zall(i,:), 'Color',[0.8 0.8 0.8]);
%  end
%  
%  BF_plotwSEM(ttick,zall_mean,zall_sem);
% xlim(twin);
% xlabel('Time (sec)');
% ylabel('Z-score DeltaF/F');
% title('Trial Z-scored')
% 
% figure(10);
% hold on;
%  for i=1:1:size(wave_all,1)
%      plot(samplerange/Fs, 100*wave_all(i,:), 'Color',[0.8 0.8 0.8]);
%  end
%  
%  BF_plotwSEM(ttick,100*wave_all_mean,100*wave_all_sem);
% xlim(twin);
% xlabel('Time (sec)');
% ylabel('%DeltaF/F');
% title('Trial Z-scored')