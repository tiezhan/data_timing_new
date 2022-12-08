function pfmats = BF_lst2mat(pfnames)
% 转化 .daq 文件为 .mat。 可同时转化多个。
%function BF_lst2mat(pfnames)
%----Input 参数---------
% pfnames    : daq文件路径, 可省略
%
%----Output 参数---------
% pfmats     : mat文件路径，cell类型
%
%----Example-------------
%BF_lst2mat(); %弹出对话框

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
