function outdata = spikeFilter(data, Fs, datareff)
% 滤波器整理自 wave_clus : 修订日期2016-8-11，陈昕枫
% 对wideband数据进行 先滤波 & 再减去基线。零相位滤波器，波形不易变形。
%
%function outdata = spikeFilter(data, Fs, datareffilted)
% -----Input 参数--------
% data           : RAW DATA in a bundle, chans_by_points, 1y = 1chan; unit V
% Fs             : sampling rate
% datareff       : reference-channel-data FILTERED, 1y or 0
%
% -----Output 参数--------
% outdata        : FILTERED, similar to [data]

    %% 默认参数
    if ~exist('datareff','var'); datareff = 0; end
    fmin_detect = 300;
    fmax_detect = 3000;
    
    %% 滤波
    [b,a] = ellip(2, 0.1, 40, [fmin_detect fmax_detect]*2/Fs);
    fdata = filtfilt(b, a, data);
    
    %% 减去基线
    if isequal(datareff, 0); 
        outdata = fdata; 
    else
        outdata = zeros(size(fdata));
        for i = 1:size(fdata, 2)
            outdata(:, i) = fdata(:, i) - datareff;
        end
    end
    