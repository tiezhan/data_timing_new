function result = BF_fileDateCmp(file1, file2)
%% �Ƚ�2���ļ�������޸�ʱ�䣬�Ա���file1����file2 (����1��2ʱ)
% function result = BF_fileDateCmp(file1, file2)
% ----------------Input ����--------------------
% file1, file2   :  �ļ���·��
%
% ----------------Output ����--------------------
% result         :  file1��file2ʱ��ȽϵĽ�� [-1| 0| 1| -2| 2]
% file1 < file2, return -1;
% file1 == file2, return 0;
% file1 > file2, return +1;     //�����file2
% file1(��)  file2,  return -2; //�봴��file1
% file1   file2(��), return 2;  //�봴��file2
% file1(��)   file2(��), error

finfo1 = dir(file1);
finfo2 = dir(file2);

%% ���ݺ�ʵ
assert(~(isempty(finfo1)&&isempty(finfo2)));
if isempty(finfo1)
    result = -2;
    return;
elseif isempty(finfo2)
    result = 2;
    return;
end

%% ʱ��Ƚ�
fdate1 = datetime(finfo1.date, 'InputFormat', 'd-MMM-y HH:mm:ss');
fdate2 = datetime(finfo2.date, 'InputFormat', 'd-MMM-y HH:mm:ss');
if(fdate1>fdate2)
    result = 1;
elseif(fdate1 == fdate2)
    result = 0;
else
    result = -1;
end