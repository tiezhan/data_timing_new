function pfmats = BF_daq2mat(pfnames)
% ת�� .daq �ļ�Ϊ .mat�� ��ͬʱת�������
%function BF_daq2mat(pfnames)
%----Input ����---------
% pfnames    : daq�ļ�·��, ��ʡ��
%
%----Output ����---------
% pfmats     : mat�ļ�·����cell����
%
%----Example-------------
%BF_daq2mat(); %�����Ի���

if ~exist('pfnames', 'var')
    pfnames = uigetfilemult('*.daq');
end
pfmats = cell(size(pfnames));
for i=1:length(pfnames);
    pfmats{i} = trans(pfnames{i});
end

%%
function pfnew = trans(pf)
[~, f, ext] = fileparts(pf);
pfnew = regexprep(pf, '\.daq$', '_daq.mat');
if BF_fileDateCmp(pf, pfnew)<0
    fprintf('> %s%s\t<Existed(skip)>\n\n', f, '_daq.mat');
    return;
end
[data,~ ,abstime,~ ,daqinfo] = daqread(pf);
Fs  = daqinfo.ObjInfo.SampleRate;

fprintf('-------------File-Info--------------\n');
fprintf('> %s%s\n', f, ext);
fprintf('Begin-time\t%d-%d-%d %d:%d:%.0f\n', abstime);
fprintf('Duration \t%.0f min\n\n', size(data,1)/Fs/60);

save(pfnew, 'data', 'Fs');
