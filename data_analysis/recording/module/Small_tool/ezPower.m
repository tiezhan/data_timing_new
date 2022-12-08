function [freqs, powers] = ezPower(varargin)
% 简单的画出 数据的power分布
% function ezPower(hax=可省略, Fs, data_1v, doDB=1, varargin)
% ---------------Input 参数--------------
% hax         : 轴对象，可省略
% Fs          : 数据的采样率
% data_1v     : 数据
% doDB        : 是否进行 @(x)10*log10(x) 的y轴转化，默认是
% varargin    : 参数 for 'plot()'
%
% ----------------Output 参数-------------
% freqs       : 频率, 1v
% powers      : 功率, 1v
%
% ----------------示例用法-----------------
% ezPower(Fs, data_1v);           %最简单
% ezPower(Fs, data_1v, false);    %不使用y轴对数
% ezPower(Fs, data_1v, false, 'r', 'linewidth', 2);  %定制线条样式
% ezPower(gca, ___);              %指定轴对象
% [freqs, powers] = ezPower(___); %不画出图形

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
    freqs = linspace(0,Fs/2,n_d/2+1); %约等于
    chooseInd = 1:(length(freqs));
    powers = power_dft_d(chooseInd);
    
    if nargout==0
        plot(hax, freqs, powers, varargin{4:end});
    end

