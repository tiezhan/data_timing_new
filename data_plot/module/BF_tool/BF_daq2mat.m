function pfmats = BF_daq2mat(pfnames)
% 转化 .daq 文件为 .mat。 可同时转化多个。
%function BF_daq2mat(pfnames)
%----Input 参数---------
% pfnames    : daq文件路径, 可省略
%
%----Output 参数---------
% pfmats     : mat文件路径，cell类型
%
%----Example-------------
%BF_daq2mat(); %弹出对话框

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
