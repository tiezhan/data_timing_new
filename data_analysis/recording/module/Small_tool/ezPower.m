function [freqs, powers] = ezPower(varargin)
% �򵥵Ļ��� ���ݵ�power�ֲ�
% function ezPower(hax=��ʡ��, Fs, data_1v, doDB=1, varargin)
% ---------------Input ����--------------
% hax         : ����󣬿�ʡ��
% Fs          : ���ݵĲ�����
% data_1v     : ����
% doDB        : �Ƿ���� @(x)10*log10(x) ��y��ת����Ĭ����
% varargin    : ���� for 'plot()'
%
% ----------------Output ����-------------
% freqs       : Ƶ��, 1v
% powers      : ����, 1v
%
% ----------------ʾ���÷�-----------------
% ezPower(Fs, data_1v);           %���
% ezPower(Fs, data_1v, false);    %��ʹ��y�����
% ezPower(Fs, data_1v, false, 'r', 'linewidth', 2);  %����������ʽ
% ezPower(gca, ___);              %ָ�������
% [freqs, powers] = ezPower(___); %������ͼ��

    if ishandle(varargin{1}) %hax
        hax = varargin{1};
        varargin(1) = [];
    else
        hax = gca;
    end
    Fs = varargin{1};
    data_1v = varargin{2};
    doDB = true;
    if length(varargin)>=3
        doDB = varargin{3};
    end
    n_d = length(data_1v);
    n_d = floor(n_d / 2) *2;
    assert(Fs>0 && isvector(data_1v));
    dft_d = fft(data_1v)/n_d;
    power_dft_d = abs(dft_d).^2;
    if doDB
        power_dft_d = 10*log10(power_dft_d);
    end
    freqs = linspace(0,Fs/2,n_d/2+1); %Լ����
    chooseInd = 1:(length(freqs));
    powers = power_dft_d(chooseInd);
    
    if nargout==0
        plot(hax, freqs, powers, varargin{4:end});
    end

