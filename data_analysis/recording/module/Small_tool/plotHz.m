function h = plotHz(varargin)
% ��plot�� ����Y �ڲ�����XHz�µ�ͼ�Ρ�
% function h = plotHz(ax, XHz, Y, varargin)
% function h = plotHz(XHz, Y, varargin)
%  ----Input ����---------
%   ax            : ����󣬿�ʡ��
%   XHz           : ����Y�Ĳ�����, 1num
%   Y             : ����Y
%   varargin      : plot(X,Y, varargin) �����ò���
%
%  ----Output ����---------
%   h             : �߶ξ��
narginchk(2, inf);
if isa(varargin{1}, 'matlab.graphics.axis.Axes')
    ax = varargin{1};
    XHz = varargin{2};
    Y = varargin{3};
    args = varargin(4:end);
else
    ax = gca;
    XHz = varargin{1};
    Y = varargin{2};
    args = varargin(3:end);
end
assert(isscalar(XHz), '��⵽XHz��Ϊ����!');
sz = size(Y);
assert(length(sz) == 2, '��⵽Y��ά�ȴ���2!');
if isvector(Y)
    n = length(Y);
    xtick = (0 : n-1)' / XHz;
    X = reshape(xtick, size(Y));
else
   [n, m] = size(Y);  %1y ��ʾһ���߶�
   xtick = (0 : n-1)' / XHz; %1y
   X = repmat(xtick, 1, m); % n X m
end
h = plot(ax, X, Y, args{:});
switch nargout
    case 0
        clear h
    case 1
    otherwise
        error('�����������');
end