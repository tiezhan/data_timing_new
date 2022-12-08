function [dff,dff_mean,dff_sem, ttick]=signaldff(wave_raw,event_time,samplerate)
Fs = samplerate;
twin = [-0.5 0];
event_base = event_time;
wave_base = funa(wave_raw, Fs, event_base, twin);
wave_base(all(wave_base == 0, 2),:) = []; %%delete NA value

twin = [-0.5 5];
samplerange = twin(1)*Fs:twin(2)*Fs;
event_interest = event_time; %% et2,et3.....etc
wave_data = funa(wave_raw, Fs, event_interest, twin);
wave_data(all(wave_data == 0, 2),:) = []; %%delete NA value
base_mean = mean(wave_base,2);

dff = (wave_data - base_mean) ./ (base_mean - mean(wave_raw(5:100)));
dff = dff - dff(:,50); %% no

ntrial = size(dff,1);
dff_mean = mean(dff, 1);
dff_std  = std(dff, 0, 1);
dff_sem  = dff_std/sqrt(ntrial);

ttick = samplerange/Fs;