function pfmats = BF_lst2mat(pfnames)
% ת�� .daq �ļ�Ϊ .mat�� ��ͬʱת�������
%function BF_lst2mat(pfnames)
%----Input ����---------
% pfnames    : daq�ļ�·��, ��ʡ��
%
%----Output ����---------
% pfmats     : mat�ļ�·����cell����
%
%----Example-------------
%BF_lst2mat(); %�����Ի���

if ~exist('pfnames', 'var')
    pfnames = uigetfilemult('*zdat.txt');
end
pfmats = cell(size(pfnames));
for i=1:length(pfnames)
    pfmats{i} = trans(pfnames{i});
end

%%
function pfnew = trans(pf)
[~, f, ext] = fileparts(pf);
pfnew = regexprep(pf, '\.txt$', '.mat');
if BF_fileDateCmp(pf, pfnew)<0
    fprintf('> %s%s\t<Existed(skip)>\n\n', f, '.mat');
    return;
end
pfnew =BF_textfilter(pf);


fprintf('-------------File-Info--------------\n');
fprintf('> %s%s\n', f, ext);
