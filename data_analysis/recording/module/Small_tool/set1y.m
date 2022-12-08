function data_1y = set1y(data_1v)
%把一纬的向量转化为 n_by_1 的1y 纵向量。类似于set1x
%
% function data_1x = set1x(data_1v)
%  ---------------------------Input---------------------------
% data_1v  :  data, 1v. 非空的一纬向量
%
% ---------------------------Output---------------------------
% data_1y  :  data, 1y. 一纬纵向量
assert(isvector(data_1v), 'data_1v should be a vector!')
data_1y = reshape(data_1v, [], 1);