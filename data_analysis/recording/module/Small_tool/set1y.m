function data_1y = set1y(data_1v)
%��һγ������ת��Ϊ n_by_1 ��1y ��������������set1x
%
% function data_1x = set1x(data_1v)
%  ---------------------------Input---------------------------
% data_1v  :  data, 1v. �ǿյ�һγ����
%
% ---------------------------Output---------------------------
% data_1y  :  data, 1y. һγ������
assert(isvector(data_1v), 'data_1v should be a vector!')
data_1y = reshape(data_1v, [], 1);