function hline = barline_old(x, HL, varargin)
%修订时间2016-8-30，陈昕枫
%替代bar()函数，做time-stamp的Raster。
%
%function hline = barline_old(x, HL, varargin)
% -----Input 参数--------
% x              : bar(x), 1_vector
% HL             : High and Low, 2_nums
% varargin       : pars for 'plot()'
%
% -----Output 参数--------
% hline          : handle for plot-line, 1y
    %% 准备参数
    if ~exist('HL','var');HL=[0 1];end
    switch length(HL)
        case 0
            HL = [0 1];
        case 1
            HL=HL+[0 1];
        case 2
        otherwise
            error('Entry a number')
    end
     if isempty(varargin);varargin{1}='k';end
    if ~isvector(x);error('input:x show be a vector');end
    x = reshape(x,[],1); %1y
    HL = reshape(HL,1,[]); %1x
    %% 制作数据
    xtick = [x,x];
    ytick = repmat(HL, length(x), 1);
     
    %% 画出数据
    hline = plot(xtick', ytick', varargin{:});
    if nargout==0;
        clear hline
    end

end