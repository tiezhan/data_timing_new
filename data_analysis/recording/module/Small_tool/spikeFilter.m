function outdata = spikeFilter(data, Fs, datareff)
% �˲��������� wave_clus : �޶�����2016-8-11����꿷�
% ��wideband���ݽ��� ���˲� & �ټ�ȥ���ߡ�����λ�˲��������β��ױ��Ρ�
%
%function outdata = spikeFilter(data, Fs, datareffilted)
% -----Input ����--------
% data           : RAW DATA in a bundle, chans_by_points, 1y = 1chan; unit V
% Fs             : sampling rate
% datareff       : reference-channel-data FILTERED, 1y or 0
%
% -----Output ����--------
% outdata        : FILTERED, similar to [data]

    %% Ĭ�ϲ���
    if ~exist('datareff','var'); datareff = 0; end
    fmin_detect = 300;
    fmax_detect = 3000;
    
    %% �˲�
    [b,a] = ellip(2, 0.1, 40, [fmin_detect fmax_detect]*2/Fs);
    fdata = filtfilt(b, a, data);
    
    %% ��ȥ����
    if isequal(datareff, 0); 
        outdata = fdata; 
    else
        outdata = zeros(size(fdata));
        for i = 1:size(fdata, 2)
            outdata(:, i) = fdata(:, i) - datareff;
        end
    end
    