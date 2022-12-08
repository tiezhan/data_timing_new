function wave_ntrial = funa(wave_raw, Fs, event_t, twin)
    samplerange = twin(1)*Fs:twin(2)*Fs;
    ntrial = length(event_t);
    wave_ntrial = zeros(ntrial-2, length(samplerange));
    for i=2:ntrial -5
        et_now = event_t(i);
        sampletick_now = round(et_now * Fs); %SAMPLE TICK 
        wave_trial_now = wave_raw(sampletick_now + samplerange);
        wave_ntrial(i,:) = wave_trial_now';
    end
end

