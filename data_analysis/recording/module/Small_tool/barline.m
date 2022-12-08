function hline = barline(x, HL, varargin)
%�޶�ʱ��2017-3-23����꿷�
%���barline_old()����������������Ϊһ�����塣
%
%function hline = barline(x, HL, varargin)
% -----Input ����--------
% x              : bar(x), 1_vector
% HL             : High and Low, 2_nums
% varargin       : pars for 'plot()'
%
% -----Output ����--------
% hline          : handle for plot-line, 1x1

    %% ׼������ -- barline_old()һ��
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
    
    %% ��������
    xtick = [x';x'; nan(2,length(x))];
    ytick = repmat(HL', 2, length(x));
    xtick = xtick(:) ; %1y [x1 x1 nan nan, x2 x2 nan nan,...]
    ytick = ytick(:) ; %1y [L H L H L H L H.....])
    %% �������� -- barline_old()һ��
    hline = plot(xtick', ytick', varargin{:});
    if nargout==0;
        clear hline
    end
    