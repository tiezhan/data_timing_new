function data_1x = set1x(data_1v)
%��һγ������ת��Ϊ 1_by_n ��1x ��������������set1y
%
% function data_1x = set1x(data_1v)
%  ---------------------------Input---------------------------
% data_1v  :  data, 1v. �ǿյ�һγ����
%
% ---------------------------Output---------------------------
% data_1x  :  data, 1x. һγ������
assert(isvector(data_1v), 'data_1v should be a vector!')
data_1x = reshape(data_1v, 1, []);