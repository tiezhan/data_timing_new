data = csvread('da36.csv'); %% import data (~.csv)
Fs = 100;
[tRise, tDur] = detectTTL(data(:,2)); %% find waiting timestamp
tRise_wait = tRise/Fs;
tDur_wait  = tDur/Fs;
tlea = tRise_wait + tDur_wait;
[tRise, tDur] = detectTTL(data(:,1));
tlick = tRise/Fs

wave_raw = data(:,4);

[a1, a2, a3] = signaldff(wave_raw,tRise_wait,100); %% data, 时间点, 100 = samplerate
dff = a1;
dff_mean = a2;
dff_sem = a3;

[a1, a2, a3] = signaldff(wave_raw,tlea,100); %% data, 时间点, 100 = samplerate
dff_lea= a1;
dff_lea_mean = a2;
dff_lea_sem = a3;

[a1, a2, a3] = signaldff(wave_raw,tlick,100); %% data, 时间点, 100 = samplerate
dff_lick= a1;
dff_lick_mean = a2;
dff_lick_sem = a3;

dat_mean = vertcat(dat_mean,dff_mean)
dat_lick_mean = vertcat(dat_lick_mean,dff_lick_mean)
dat_lea_mean = vertcat(dat_lea_mean, dff_lea_mean)