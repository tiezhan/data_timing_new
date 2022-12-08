function data_1x = set1x(data_1v)
%把一纬的向量转化为 1_by_n 的1x 横向量。类似于set1y
%
% function data_1x = set1x(data_1v)
%  ---------------------------Input---------------------------
% data_1v  :  data, 1v. 非空的一纬向量
%
% ---------------------------Output---------------------------
% data_1x  :  data, 1x. 一纬横向量
assert(isvector(data_1v), 'data_1v should be a vector!')
data_1x = reshape(data_1v, 1, []);