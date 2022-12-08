function hline = barline(x, HL, varargin)
%修订时间2017-3-23，陈昕枫
%替代barline_old()函数，所有线条作为一个整体。
%
%function hline = barline(x, HL, varargin)
% -----Input 参数--------
% x              : bar(x), 1_vector
% HL             : High and Low, 2_nums
% varargin       : pars for 'plot()'
%
% -----Output 参数--------
% hline          : handle for plot-line, 1x1

    %% 准备参数 -- barline_old()一致
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
    if isempty(x)
        hline = [];
        warning('barline for empty data');
        return;
    end
    if ~isvector(x);error('input:x show be a vector');end
    x = reshape(x,[],1); %1y
    HL = reshape(HL,1,[]); %1x
    
    %% 制作数据
    xtick = [x';x'; nan(2,length(x))];
    ytick = repmat(HL', 2, length(x));
    xtick = xtick(:) ; %1y [x1 x1 nan nan, x2 x2 nan nan,...]
    ytick = ytick(:) ; %1y [L H L H L H L H.....])
    %% 画出数据 -- barline_old()一致
    hline = plot(xtick', ytick', varargin{:});
    if nargout==0;
        clear hline
    end
    