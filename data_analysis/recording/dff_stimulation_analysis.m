data = csvread('20221025-.csv'); %% import data (~.csv)
Fs = 100;
[tRise, tDur] = detectTTL(data(:,3), 'up-up', Fs*0.6); %% find stimulation timestamp
tRise_stimu = tRise/Fs;
tDur_stimu  = tDur/Fs;

[tRise, tDur] = detectTTL(data(:,2)); %% find waiting timestamp
tRise_wait = tRise/Fs;
tDur_wait  = tDur/Fs;

wave_raw = data(:,4);

Alg_ms = BF_AlignSg2TgCell(tRise_stimu, tRise_wait, -5,5); %% find stimulated trial in waiting trial,stimulation duration = 5s 
alg_ms_length = cellfun(@length, Alg_ms);
alg_ms_remove = alg_ms_length >=1;
tRise_wait(alg_ms_remove) = []; %% remove stimulated trial in waiting trial

[a1, a2, a3] = signaldff(wave_raw,tRise_wait,100); %% data, ʱ���, 100 = samplerate
dff = a1;
dff_mean = a2;
dff_sem = a3;

[a1, a2, a3, a4] = signaldff(wave_raw,tRise_stimu,100); %% data, ʱ���, 100 = samplerate
dff_stimu= a1;
dff_stimu_mean = a2;
dff_stimu_sem = a3;
ttick = a4;

m_wait = max(dff(:,50:350),[],2); %% ���̼�һ������5�룬���Դ�50ȡ��550 Ҳ����ȡ��250��Ϊ300��2��
m_stimu = max(dff_stimu(:,50:350),[],2);  %% ��ȡ0��2��ȴ��ڼ�VTA DA��ԪGCAMPӫ��ֵ������ֵ
m_2 = max(dff(:,50:550),[],2);
m_3 = max(dff_stimu(:,50:350),[],2);
m_all= horzcat(mean(m_wait),mean(m_stimu));
m_all_5 = horzcat(mean(m_2),mean(m_3));