function h = plotHz(varargin)
% 简单plot出 数据Y 在采样率XHz下的图形。
% function h = plotHz(ax, XHz, Y, varargin)
% function h = plotHz(XHz, Y, varargin)
%  ----Input 参数---------
%   ax            : 轴对象，可省略
%   XHz           : 数据Y的采样率, 1num
%   Y             : 数据Y
%   varargin      : plot(X,Y, varargin) 的设置参数
%
%  ----Output 参数---------
%   h             : 线段句柄
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
assert(isscalar(XHz), '检测到XHz不为标量!');
sz = size(Y);
assert(length(sz) == 2, '检测到Y的维度大于2!');
if isvector(Y)
    n = length(Y);
    xtick = (0 : n-1)' / XHz;
    X = reshape(xtick, size(Y));
else
   [n, m] = size(Y);  %1y 表示一条线段
   xtick = (0 : n-1)' / XHz; %1y
   X = repmat(xtick, 1, m); % n X m
end
h = plot(ax, X, Y, args{:});
switch nargout
    case 0
        clear h
    case 1
    otherwise
        error('输出参数过多');
end