function [comp , amp, theta, freqs] = waveletcomplexExractMultBand(data, Fs)
% 对波形进行 频率谱解析 (利用小波卷积)
% function [comp , amp, theta, freqs] = waveletcomplexExractMultBand(data, Fs)
% --------------------Input 参数-------------------
% data   : 数据, 1v
% Fs     : 采样率, 1num
%
% --------------------Output 参数-------------------
% comp   : data的小波卷积 复数形式, nsample_by_nFreqs, 1y=1Freq trial
% amp    : comp 的振幅
% theta  : comp 的相位
% freqs  : comp 的频率段

    %% 选择的默认观测频率
    freqs =  [2.63, 3.03, 3.48, 4, 4.6, 5.27, 6.06, 6.96, 8, 9.18, 10.55, ...
    12.12, 13.92, 16, 18.37, 21.11, 24.25, 27.85, 32, 36.75, 42.22, 48.5, 55.7, 64, 73.51,...
    84.44  97];

    comp = cell(0);
    amp = cell(0);
    theta = cell(0);
    for i=1:length(freqs)
        [comp_now, amp_now, theta_now] = waveletcomplexExract(data, Fs, freqs(i));
        comp{i} = set1y(comp_now);
        amp{i}  = set1y(amp_now);
        theta{i} = set1y(theta_now);
    end

    comp = cell2mat(comp);
    amp = cell2mat(amp);
    theta = cell2mat(theta);

    %% 如果补输出参数，则作出功率图
    if nargout==0
        power = 10*log10(amp.^2);
        imagesc(power' ,'xdata', [0 length(data)/Fs]);
        xlabel('Time (sec)');
        ylabel('Freq (Hz)');
        set(gca,'ytick', 1:5:length(freqs), ...
            'yticklabel', freqs(1:5:length(freqs)));
        axis xy;
    end
end

function [comp, amp, theta] = waveletcomplexExract(data, Fs, fInterest)
% 对波形进行小波卷积，从而得到该频段的谱信息(振幅、相位)
% function [comp, amp, theta] = waveletcomplexExract(data, Fs, fInterest)
    f = fInterest;
    s = 1/f; %默认的 频率/时间 弥散度
    tMax = 1 / f * 30; %确保无边界效应
    assert(f>=1);
    t = -tMax:(1/Fs):tMax ;
    w = exp(2*pi*1i*f.*t).*exp(-t.^2./(2*s^2));% * sqrt(pi*(2*s^2));
    data_comp = conv(data, w) / length(w);
    data_comp(find(t<0)) = [];
    data_comp = data_comp(1:length(data));
    
    comp =  data_comp;
    amp  = abs(comp);
    theta = angle(comp);
end